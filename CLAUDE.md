# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Jekyll static site (ivancheng.xyz) running Jekyll 4.4.x. All site source lives under `app/`, and the Docker-based development environment is defined in `jekyll/`.

## Development

The site is developed via Docker. All commands mount `app/` into the container.

**Serve locally (with live reload):**
```sh
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve
```

**Build the static site:**
```sh
docker run -v $(pwd)/app:/usr/src/app jekyll-website build
```

**Create a new post (via jekyll-compose):**
```sh
docker run -v $(pwd)/app:/usr/src/app jekyll-website post "$NAME"
```

The `serve` and `build` entrypoints run `bundle install` automatically — no separate step needed after adding gems.

To build the Docker image first:
```sh
docker build -t jekyll-website jekyll/
```

If running Jekyll directly (requires Ruby + Bundler):
```sh
cd app && bundle install && bundle exec jekyll serve --livereload
```

## Architecture

- `app/_config.yml` — site config: title, URL (`https://ivancheng.xyz`), default `lang`, permalink pattern (`/:categories/:title/`), and plugins (`jekyll-feed`, `jekyll-sitemap`)
- `app/_posts/` — blog posts as Markdown with YAML front matter. Filenames must follow `YYYY-MM-DD-title.md`. Posts use `layout: post`, `categories:`, and a custom `caption:` field shown on the home page
- `app/_layouts/` — two layouts: `home.html` (landing page with self-intro sidebar) and `post.html` (article view with back-nav). All layouts use dynamic `lang` attribute via `page.lang | default: site.lang`
- `app/_includes/` — `meta.html` (shared `<head>` with SEO tags: description, canonical, Open Graph, Twitter Card) and `footer.html`
- `app/robots.txt` — allows all crawlers and references the sitemap URL
- `app/_sass/` — partials imported by the CSS entry points: `breakpoints.scss`, `normalize.scss`, `list.scss`, `code-block.scss`
- `app/assets/css/` — two SCSS entry points: `styles.scss` (home page) and `post.scss` (post pages)
- `app/_site/` — generated output, not committed

## Post Front Matter

```yaml
---
layout: post
title: 'Post Title'
caption: 'Short teaser shown on home page'
author: Ivan Cheng
date: YYYY-MM-DD HH:MM +0000
categories: CategoryName
lang: zh  # set for non-English posts; defaults to site.lang (en)
---
```

The `caption` field is rendered on the home page (`index.html`) via `{{ post.caption }}` and also used as the SEO meta description. Posts are sorted by date descending; the home page shows the 3 most recent.
