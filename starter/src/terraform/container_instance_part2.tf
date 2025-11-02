locals {
  docker_image_ui=data.external.env_part2.result.docker_image_ui
  docker_image_app=data.external.env_part2.result.docker_image_app
}

resource oci_container_instances_container_instance starter_container_instance {
  depends_on = [ local.docker_image_ui ]

  availability_domain = local.availability_domain_name
  compartment_id      = local.lz_app_cmp_ocid  
  container_restart_policy = "ALWAYS"
  containers {
    display_name = "app"
    image_url = local.docker_image_app
    is_resource_principal_disabled = "false"
    environment_variables = { 
    }    
  }
  containers {
    display_name = "ui"
    image_url = local.docker_image_ui
    is_resource_principal_disabled = "false"
  }  
  display_name = "${var.prefix}-ci"
  graceful_shutdown_timeout_in_seconds = "0"
  shape = startswith(var.instance_shape, "VM.Standard.A") ? "CI.Standard.A1.Flex" : "CI.Standard.E4.Flex"  
  shape_config {
    memory_in_gbs = "4"
    ocpus         = "1"
  }
  state = "ACTIVE"
  vnics {
    display_name           = "${var.prefix}-ci"
    hostname_label         = "${var.prefix}-ci"
    skip_source_dest_check = "true"
    subnet_id              = data.oci_core_subnet.starter_app_subnet.id
  }
  freeform_tags = local.freeform_tags    
}

locals {
  apigw_dest_private_ip = try(oci_container_instances_container_instance.starter_container_instance.vnics[0].private_ip, "")
}

resource "oci_apigateway_deployment" "starter_apigw_deployment" {   
  compartment_id = local.lz_app_cmp_ocid
  display_name   = "${var.prefix}-apigw-deployment"
  gateway_id     = local.apigw_ocid
  path_prefix    = "/${var.prefix}"
  specification {
    logging_policies {
      access_log {
        is_enabled = true
      }
      execution_log {
        #Optional
        is_enabled = true
      }
    }
    routes {
      path    = "/app/{pathname*}"
      methods = [ "ANY" ]
      backend {
        type = "HTTP_BACKEND"
        url    = "http://${local.apigw_dest_private_ip}:8080/$${request.path[pathname]}"
      }
    }     
    routes {
      path    = "/{pathname*}"
      methods = [ "ANY" ]
      backend {
        type = "HTTP_BACKEND"
        url    = "http://${local.apigw_dest_private_ip}/$${request.path[pathname]}"
      }
    }
  }
  freeform_tags = local.api_tags
}

