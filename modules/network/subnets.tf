locals {
  # needed because you'll get this error sporadically: Cannot create cluster 'tf-cluster-timestamp-app-0' because us-east-1e, the targeted availability zone, does not currently have sufficient capacity to support the cluster. Retry and choose from these availability zones
  az_index_offset = 0
}

resource "aws_subnet" "app" {
  count = 2

  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.10.1${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index + local.az_index_offset]

  tags = {
    "kubernetes.io/cluster/tf-cluster-${var.project_name}-0" = "shared"
    Name                                                     = "tf-sn-${var.project_name}-app-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.10.2${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index + local.az_index_offset]

  tags = {
    Name = "tf-sn-${var.project_name}-public-${count.index}"
  }
}
