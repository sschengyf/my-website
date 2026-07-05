# my-website

## Commands

```sh
# Build Jekyll image
docker build -t jekyll-website ./jekyll

# Init a website
docker run -v $(pwd)/app:/usr/src/app jekyll-website init

# Serve a website for local dev (uses _config_dev.yml for local Remark42)
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve

# Remark42 locally (in another terminal)
cd remark42 && docker compose up -d

# Export the static website
docker run -v $(pwd)/app:/usr/src/app jekyll-website build

# Creates a new post with the given NAME
docker run -v $(pwd)/app:/usr/src/app jekyll-website post "$NAME"

# Creates a new draft post with the given NAME
docker run -v $(pwd)/app:/usr/src/app jekyll-website draft "$NAME"

# Moves a draft into the _posts directory and sets the date
docker run -v $(pwd)/app:/usr/src/app jekyll-website publish _drafts/$FILE_NAME

```
