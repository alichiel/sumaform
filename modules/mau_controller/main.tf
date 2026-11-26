variable "testsuite-branch" {
  default = {
    "5.1-released"   = "Manager-5.1"
    "5.1-nightly"    = "Manager-5.1"
    "5.2-released"   = "Manager-5.2"
    "5.2-nightly"    = "Manager-5.2"
    "head"           = "master"
    "head-staging"   = "master"
    "uyuni-master"   = "master"
    "uyuni-released" = "master"
  }
}

locals {
  product_version = var.product_version != null ? var.product_version : var.base_configuration["product_version"]
}

module "controller" {
  source = "../host"

  base_configuration            = var.base_configuration
  name                          = var.name
  additional_repos              = var.additional_repos
  additional_repos_only         = var.additional_repos_only
  additional_packages           = var.additional_packages
  swap_file_size                = var.swap_file_size
  ssh_key_path                  = var.ssh_key_path
  ipv6                          = var.ipv6
  connect_to_base_network       = true
  connect_to_additional_network = false
  roles                         = ["mau_controller"]
  product_version               = local.product_version
  grains = {
    cc_username     = var.base_configuration["cc_username"]
    cc_password     = var.base_configuration["cc_password"]
    cc_ptf_username = var.cc_ptf_username
    cc_ptf_password = var.cc_ptf_password
    git_username    = var.git_username
    git_password    = var.git_password
    git_repo        = var.git_repo
    branch          = var.branch == "default" ? var.testsuite-branch[var.base_configuration["product_version"]] : var.branch
    mirror          = var.no_mirror == true ? null :  var.base_configuration["mirror"]

    server            = length(var.server_configuration["hostnames"]) > 0 ? var.server_configuration["hostnames"][0] : null
    proxy             = length(var.proxy_configuration["hostnames"]) > 0 ? var.proxy_configuration["hostnames"][0] : null
    minion            = length(var.minion_configuration["hostnames"]) > 0 ? var.minion_configuration["hostnames"][0] : null
    sshminion         = length(var.sshminion_configuration["hostnames"]) > 0 ? var.sshminion_configuration["hostnames"][0] : null

    git_profiles_repo         = var.git_profiles_repo == "default" ? "https://github.com/uyuni-project/uyuni.git#:testsuite/features/profiles" : var.git_profiles_repo
    no_auth_registry          = var.no_auth_registry
    auth_registry             = var.auth_registry
    auth_registry_username    = var.auth_registry_username
    auth_registry_password    = var.auth_registry_password
    server_http_proxy         = var.server_http_proxy
    custom_download_endpoint  = var.custom_download_endpoint
    pxeboot_image             = var.pxeboot_configuration["image"]
    is_using_paygo_server     = var.is_using_paygo_server
    is_using_build_image      = var.is_using_build_image
    is_using_scc_repositories = var.is_using_scc_repositories
    server_instance_id        = var.server_instance_id
    product_version           = local.product_version
    container_runtime         = lookup(var.server_configuration, "runtime", "")
    catch_timeout_message     = var.catch_timeout_message
    prometheus_push_gateway_url = var.prometheus_push_gateway_url
    beta_enabled              = var.beta_enabled
    web_server_hostname       = var.web_server_hostname
    container_registry                           = var.kubernetes_server_container_registry
    local_path_provisioner_default_class         = var.local_path_provisioner_default_class
    use_devel_oci                                = var.use_devel_oci
    deploy_coco_attestation                      = var.deploy_coco_attestation
    deploy_saline                                = var.deploy_saline
    deploy_hub_api                               = var.deploy_hub_api
    deploy_tftp                                  = var.deploy_tftp
    install_uyuni_via_testsuite                  = var.install_uyuni_via_testsuite

    sles15sp7_minion          = length(var.sles15sp7_minion_configuration["hostnames"]) > 0 ? var.sles15sp7_minion_configuration["hostnames"][0] : null
    sles15sp7_sshminion       = length(var.sles15sp7_sshminion_configuration["hostnames"]) > 0 ? var.sles15sp7_sshminion_configuration["hostnames"][0] : null
    sles160_minion            = length(var.sles160_minion_configuration["hostnames"]) > 0 ? var.sles160_minion_configuration["hostnames"][0] : null
    sles160_sshminion         = length(var.sles160_sshminion_configuration["hostnames"]) > 0 ? var.sles160_sshminion_configuration["hostnames"][0] : null
    sles161_minion            = length(var.sles161_minion_configuration["hostnames"]) > 0 ? var.sles161_minion_configuration["hostnames"][0] : null
    sles161_sshminion         = length(var.sles161_sshminion_configuration["hostnames"]) > 0 ? var.sles161_sshminion_configuration["hostnames"][0] : null
    slmicro61_minion         = length(var.slmicro61_minion_configuration["hostnames"]) > 0 ? var.slmicro61_minion_configuration["hostnames"][0] : null
    slmicro61_sshminion      = length(var.slmicro61_sshminion_configuration["hostnames"]) > 0 ? var.slmicro61_sshminion_configuration["hostnames"][0] : null
    slmicro62_minion         = length(var.slmicro62_minion_configuration["hostnames"]) > 0 ? var.slmicro62_minion_configuration["hostnames"][0] : null
    slmicro62_sshminion      = length(var.slmicro62_sshminion_configuration["hostnames"]) > 0 ? var.slmicro62_sshminion_configuration["hostnames"][0] : null
  }

  image   = "opensuse160o"
  provider_settings = var.provider_settings
}

output "configuration" {
  value = {
    id       = length(module.controller.configuration["ids"]) > 0 ? module.controller.configuration["ids"][0] : null
    hostname = length(module.controller.configuration["hostnames"]) > 0 ? module.controller.configuration["hostnames"][0] : null
    branch   = var.branch == "default" ? var.testsuite-branch[var.server_configuration["product_version"]] : var.branch
  }
}
