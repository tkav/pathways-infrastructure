data "aws_region" "current" {}

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
  alb_sg_id       = module.network.alb_sg_id
  public_subnets  = slice(module.network.public_subnets, 0, 1)
  log_bucket      = module.s3_bucket.s3_bucket_name

  depends_on = [module.network, module.s3_bucket]

  tags = var.tags
}

module "ecs" {
  source              = "./modules/ecs"
  name_prefix         = local.author_username
  ecr_repo_uri        = module.ecr_repo.ecr_repo_url
  ecs_iam_role_id     = module.ecr_repo.ecr_iam_policy_id
  lb_target_group_arn = module.alb.lb_target_group_arn
  ecs_sg_id           = module.network.ecs_sg_id
  private_subnets     = slice(module.network.private_subnets, 0, 1)

  desired_count = 1
  memory        = 512
  cpu           = 256

  depends_on = [module.ecr_repo]

  tags = var.tags
}