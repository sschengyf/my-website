# remark42 — Comment server

Self-hosted [Remark42](https://remark42.com/) backend for the Jekyll site. The static site embeds the widget on post pages; this service handles auth, storage, and moderation.

Site embed config: [`../app/README.md`](../app/README.md) · Repo overview: [`../README.md`](../README.md)

## Architecture

| Component | Role |
|---|---|
| Jekyll site (GCS) | Serves blog pages with embedded widget |
| Remark42 (this folder) | Comment API on a GCP Compute Engine VM |
| Caddy | HTTPS termination, reverse proxy to `localhost:8080` |
| BoltDB (`./var/`) | Comment storage and automatic JSON backups |

## Prerequisites

- GCP Compute Engine VM (e2-micro in `us-central1`, `us-east1`, or `us-west1` for Always Free)
- DNS A record: `comments.<your-domain>` → VM external IP
- Firewall rules allowing TCP 80 and 443 to the VM
- GitHub OAuth app (callback: `https://comments.<your-domain>/auth/github/callback`)

Set these shell variables before running the commands below:

```sh
export GCP_PROJECT_ID="your-gcp-project-id"
export GCP_ZONE="us-central1-a"
export VM_NAME="remark42"
export COMMENTS_HOST="comments.example.com"
export SITE_URL="https://example.com"
```

## Deploy to the VM

Copy files from your laptop:

```sh
gcloud compute scp --recurse remark42/ ${VM_NAME}:~/remark42 \
  --zone=${GCP_ZONE} --project=${GCP_PROJECT_ID}
```

On the VM:

```sh
cd ~/remark42
cp .env.example .env
# Edit .env — set SECRET, GitHub OAuth, REMARK_URL, ALLOWED_HOSTS, etc.
sudo mkdir -p var
sudo docker compose up -d
```

Or copy a local production env file:

```sh
gcloud compute scp remark42/.env.prod ${VM_NAME}:~/remark42/.env \
  --zone=${GCP_ZONE} --project=${GCP_PROJECT_ID}
```

Verify on the VM (use GET, not HEAD — `/web` returns 405 for HEAD):

```sh
curl -s -o /dev/null -w "HTTP %{http_code}\n" http://127.0.0.1:8080/web
```

After DNS and HTTPS:

```sh
curl -s -o /dev/null -w "HTTP %{http_code}\n" https://${COMMENTS_HOST}/web/
```

## DNS

Add an A record at your DNS provider:

```text
comments.example.com  →  <VM_EXTERNAL_IP>
```

## Caddy (HTTPS)

On the VM:

```sh
sudo apt-get update && sudo apt-get install -y caddy
```

`/etc/caddy/Caddyfile`:

```caddyfile
comments.example.com {
    reverse_proxy localhost:8080
}
```

```sh
sudo systemctl enable caddy
sudo systemctl reload caddy
```

## Environment variables

See `.env.example`. Required for production:

| Variable | Description |
|---|---|
| `REMARK_URL` | Public URL of this server (e.g. `https://comments.example.com`) |
| `SECRET` | Random string (`openssl rand -hex 32`) |
| `SITE` | Site ID, must match `site_id` in Jekyll `_config.yml` |
| `AUTH_GITHUB_CID` / `AUTH_GITHUB_CSEC` | GitHub OAuth credentials |
| `AUTH_SAME_SITE` | Set to `none` when the blog and comment server use different origins |
| `ALLOWED_HOSTS` | Domains allowed to embed the widget (see note below) |
| `ADMIN_SHARED_ID` | Your GitHub user ID after first login (grants admin) |

**`ALLOWED_HOSTS` quoting:** Docker Compose requires double quotes around values containing commas:

```bash
ALLOWED_HOSTS="'self',https://example.com"
```

## Admin

There is no separate admin login. Set `ADMIN_SHARED_ID` to your GitHub user ID, restart Remark42, then sign in via GitHub on any post page.

To find your user ID (after signing in, in the browser console):

```javascript
fetch('https://comments.example.com/api/v1/user', { credentials: 'include' })
  .then(r => r.json())
  .then(u => console.log('Your ID:', u.id))
```

## Per-post toggle

Disable comments on a single post via front matter:

```yaml
comments: false
```

Site-wide kill switch: set `remark42.enabled: false` in `app/_config.yml`.

## Local development

```sh
cd remark42 && cp .env.example .env
# Set REMARK_URL=http://127.0.0.1:8080 and AUTH_ANON=true for quick testing
docker compose up -d

docker build -t jekyll-website ./jekyll
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve
```

Jekyll merges `app/_config_dev.yml` when serving via Docker (local Remark42 URL and site URL).

## Updates

On the VM:

```sh
cd ~/remark42
sudo docker compose pull && sudo docker compose up -d
```

## Data and backups

All data lives in `./var/` (BoltDB + automatic JSON backups). Back up this directory regularly (e.g. copy to a GCS bucket).

## Cost

On GCP Always Free tier (e2-micro + Standard persistent disk ≤ 30 GB in US regions): **~$0/month** for a personal blog.
