data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name = "${local.project_prefix}"

  tags = var.tags
}

module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}

module "network" {
  source                      = "./modules/network"
  aws_region                  = data.aws_region.current.name
  project_prefix              = local.project_prefix
  subnet_suffix               = local.subnet_suffix
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnet_count         = var.public_subnet_count
  private_subnet_count        = var.private_subnet_count
  public_subnet_cidr_blocks   = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks  = var.private_subnet_cidr_blocks
}

module "ecr_repo" {
  source      = "./modules/ecr"
  ecr_prefix  = local.author_username

  tags = var.tags
}

module "alb" {
  source          = "./modules/alb"
  name_prefix     = local.author_username
  vpc_id          = module.network.vpc_id
  subnets         = slice(module.network.public_subnets, 0, 2)
  log_bucket      = module.s3_bucket.s3_bucket_name

  depends_on = [module.network, module.s3_bucket]

  tags = var.tags
}

module "ecs" {
  source              = "./modules/ecs"
  name_prefix         = local.author_username
  aws_region          = data.aws_region.current.name
  cloudwatch_group    = aws_cloudwatch_log_group.cloudwatch_group.id
  ecr_repo_uri        = module.ecr_repo.ecr_repo_url
  ecs_iam_role_arn    = module.ecr_repo.ecr_iam_role_arn
  lb_target_group_arn = module.alb.lb_target_group_arn
  vpc_id              = module.network.vpc_id
  alb_sg_id           = module.alb.alb_sg_id
  subnets             = slice(module.network.private_subnets, 0, 2)

  desired_count = var.desired_count
  port          = var.port
  memory        = var.memory
  cpu           = var.cpu

  depends_on = [module.ecr_repo, module.alb, aws_cloudwatch_log_group.cloudwatch_group]

  tags = var.tags
}