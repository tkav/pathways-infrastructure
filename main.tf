data "aws_region" "current" {}

module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}

module network {
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
  ecr_prefix  = local.project_prefix

  tags = var.tags
}
