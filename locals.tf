locals {
  tags_base = merge(var.tags, {
    creator = "instanceswitcher"
  })
}
