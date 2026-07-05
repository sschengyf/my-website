# my-website

Personal blog and static site ([ivancheng.xyz](https://ivancheng.xyz)). Jekyll source is built and deployed to Google Cloud Storage; comments are served by a self-hosted Remark42 instance.

## Components

| Folder | Description | Docs |
|---|---|---|
| [`app/`](app/) | Jekyll site source (posts, layouts, styles) | [app/README.md](app/README.md) |
| [`jekyll/`](jekyll/) | Docker image and dev entrypoint | [jekyll/README.md](jekyll/README.md) |
| [`remark42/`](remark42/) | Self-hosted comment server (GCP VM) | [remark42/README.md](remark42/README.md) |
| [`.github/`](.github/) | GitHub Actions CI/CD | [.github/README.md](.github/README.md) |

## Quick start

```sh
docker build -t jekyll-website ./jekyll
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve
```

For local comments, also run `cd remark42 && docker compose up -d` — see [remark42/README.md](remark42/README.md).

## Deployment

```text
git push master  →  GitHub Actions  →  GCS  →  ivancheng.xyz
Remark42         →  manual deploy   →  GCP VM  →  comments.ivancheng.xyz
```

Details: [.github/README.md](.github/README.md) (site) and [remark42/README.md](remark42/README.md) (comments).
