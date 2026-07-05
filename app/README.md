# app — Jekyll site source

Static site content for [ivancheng.xyz](https://ivancheng.xyz). Built with Jekyll 4.4.x; output goes to `_site/` (gitignored).

Dev environment: [`../jekyll/README.md`](../jekyll/README.md) · Comments: [`../remark42/README.md`](../remark42/README.md) · Deploy: [`../.github/README.md`](../.github/README.md)

## Structure

| Path | Purpose |
|---|---|
| `_config.yml` | Site URL, plugins, Remark42 settings |
| `_config_dev.yml` | Local dev overrides (merged via Docker `serve` only) |
| `_posts/` | Blog posts — filenames must be `YYYY-MM-DD-title.md` |
| `_layouts/` | Page templates: `home.html`, `post.html`, `page.html` |
| `_includes/` | Partials: `meta.html`, `comments.html`, `bio.html`, `footer.html` |
| `_sass/` | SCSS partials (imported, not compiled directly) |
| `assets/css/` | SCSS entry points: `styles.scss` (site), `post.scss` (code blocks) |
| `tools/` | Standalone client-side tools |
| `index.html` | Home page |

## Post front matter

```yaml
---
layout: post
title: 'Post Title'
caption: 'Teaser shown on the home page and in SEO meta'
author: Ivan Cheng
date: YYYY-MM-DD HH:MM +0000
categories: CategoryName
lang: zh              # optional; defaults to site lang (en)
comments: false       # optional; disable Remark42 on this post
---
```

**Permalink:** `/:categories/:title/` — multiple categories produce nested URLs (e.g. `categories: Technology AI` → `/technology/ai/title/`).

## Comments

Post pages embed Remark42 when `remark42.enabled` is true in `_config.yml` and the post does not set `comments: false`. See [`../remark42/README.md`](../remark42/README.md).

## Development

Use the Docker workflow from [`../jekyll/README.md`](../jekyll/README.md):

```sh
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve
```

Or run Jekyll directly (requires Ruby + Bundler):

```sh
cd app && bundle install && bundle exec jekyll serve --livereload
```

`_config.yml` changes require a server restart; they are not picked up by live reload.

## Build

```sh
docker run -v $(pwd)/app:/usr/src/app jekyll-website build
# output: app/_site/
```

Production builds use `_config.yml` only (not `_config_dev.yml`).

## New content

```sh
docker run -v $(pwd)/app:/usr/src/app jekyll-website post "$NAME"
docker run -v $(pwd)/app:/usr/src/app jekyll-website draft "$NAME"
docker run -v $(pwd)/app:/usr/src/app jekyll-website publish _drafts/$FILE_NAME
```

Drafts live in `_drafts/` until published.
