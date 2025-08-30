# my-website

## Commands

```sh
# Build Jekyll image
docker build -t jekyll-website ./jekyll

# Init a website
docker run -v $(pwd)/app:/usr/src/app jekyll-website init

# Serve a website for local dev
docker run -p 4000:4000 -v $(pwd)/app:/usr/src/app jekyll-website serve

# Export the static website
docker run -v $(pwd)/app:/usr/src/app jekyll-website build
```
