# CI/CD

GitHub Actions workflows for automated deployment.

## Workflows

| File                   | Trigger                                        | Action                       |
| ---------------------- | ---------------------------------------------- | ---------------------------- |
| `workflows/deploy.yml` | Push to `master`, manual (`workflow_dispatch`) | Build Jekyll → deploy to GCS |

## Site deployment (`deploy.yml`)

1. Checkout repo
2. `bundle exec jekyll build` in `app/`
3. Authenticate to GCP via **Workload Identity Federation** (no long-lived keys)
4. `gsutil rsync` `app/_site/` to the GCS bucket

### Required GitHub configuration

| Type     | Name                             | Purpose                    |
| -------- | -------------------------------- | -------------------------- |
| Variable | `GCS_BUCKET`                     | Target bucket name         |
| Secret   | `GCP_WORKLOAD_IDENTITY_PROVIDER` | WIF provider resource name |
| Secret   | `GCP_SERVICE_ACCOUNT_EMAIL`      | Deploy service account     |

Environment: `production`

### Cache headers

Deployed files get `Cache-Control: public, no-cache`. Browsers may store a copy but must revalidate with GCS (ETag → 304 when unchanged) before reuse, so publishes show up immediately.

## Remark42

The comment server is **not** deployed by these workflows. Deploy manually to the GCP VM — see [`../remark42/README.md`](../../remark42/README.md).
