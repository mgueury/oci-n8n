variable no_policy { default=null }

resource "oci_identity_policy" "starter_policy" {
    count          = var.no_policy=="true" ? 0 : 1      
    provider       = oci.home    
    name           = "${var.prefix}-policy"
    description    = "${var.prefix} policy"
    compartment_id = local.lz_serv_cmp_ocid

    statements = [
        "allow any-user to manage generative-ai-family in compartment id ${local.lz_serv_cmp_ocid} where request.principal.id='${oci_core_instance.starter_compute.id}'"
    ]
}