# Portfolio site

n**Live:** https://kind-dune-0c3cac10f.5.azurestaticapps.net
Static portfolio hosted on Azure Static Web Apps (Free plan), provisioned with
Terraform and shipped by GitHub Actions.

```
site/        the website (plain HTML)
terraform/   resource group + Static Web App
.github/     CI (lint, links, secrets, Terraform checks) and deploy
```

## Pipeline

- **CI** (every push and pull request): HTML lint, broken-link check, secret
  scan, `terraform fmt` / `validate`, Trivy security scan.
- **Deploy**: preview site per pull request, production on merge to `main`,
  then a smoke test. Off until `DEPLOY_ENABLED` is set.

## One-time Azure setup

```bash
az login
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
cd terraform
terraform init
terraform apply
gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN --body "$(terraform output -raw deploy_token)"
gh variable set SITE_URL --body "$(terraform output -raw site_url)"
gh variable set DEPLOY_ENABLED --body true
```

Re-run the Deploy workflow (or push a commit) and the site is live.
