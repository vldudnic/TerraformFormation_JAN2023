  
  variable "subscription_id" {
    type = string
    default = "2c7684a0-ec26-4999-bce8-40fadd9d7b3f"
  }

  variable "client_id" {
    type = string
    default = "b9770af7-0c56-463a-a6c3-012a90d6f0bd"
  }

  variable "client_certificate_path" {
    type = string
    default = "./service-principal.pfx"
  }
  
  variable "tenant_id" {
    type = string
    default = "029c7c0d-55be-409d-9798-41f3f7837048"
  }
  