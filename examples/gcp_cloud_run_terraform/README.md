# gcp_cloud_run_terraform
Terraform example for deploy to Cloud Run

## Usage
1. Copy `*.tf` files
2. Put and edit [terraform.tfvars](terraform.tfvars), or use as module

e.g.

```tf
module "emoy_webhook" {
  source = "./modules/path/to/emoy_webhook"

  gcp_project_id    = "YOUR_GCP_PROJECT_ID"
  slack_webhook_url = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
}
```
