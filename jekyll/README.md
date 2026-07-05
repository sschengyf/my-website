# jekyll — Docker dev environment

Ruby 3.3 Alpine image with Jekyll, Bundler, and jekyll-compose. Mounts `../app/` at `/usr/src/app` at runtime — the image contains no site source.

Site source: [`../app/README.md`](../app/README.md) · Repo overview: [`../README.md`](../README.md)

## Build

From the repo root:

```sh
docker build -t jekyll-website ./jekyll
```

## Entrypoint commands

```sh
docker run -v $(pwd)/app:/usr/src/app jekyll-website <command>
```

| Command | Description |
|---|---|
| `init` | Scaffold a new Jekyll site in `app/` (skipped if `_config.yml` exists) |
| `serve` | Dev server at `http://localhost:4000` with livereload; merges `_config.yml` + `_config_dev.yml` |
| `build` | Compile static site to `app/_site/` |
| `post NAME` | Create a new post in `_posts/` |
| `draft NAME` | Create a draft in `_drafts/` |
| `publish FILE` | Move draft to `_posts/` with today's date |

### Examples

```sh
# Local dev (map port 4000)
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve

# Production build
docker run -v $(pwd)/app:/usr/src/app jekyll-website build

# New post
docker run -v $(pwd)/app:/usr/src/app jekyll-website post "my-new-post"
```

`serve` and `build` run `bundle install` automatically on each invocation.

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | Ruby 3.3 Alpine + Jekyll gems |
| `docker-entrypoint.sh` | Routes commands to Jekyll / jekyll-compose |

## Local comments

Remark42 is not part of this image. To test comments locally, run the Remark42 stack separately — see [`../remark42/README.md`](../remark42/README.md).
