#!/bin/sh
set -e

MODE="$1"
shift

case "$MODE" in
  init)
    if [ ! -f "./_config.yml" ]; then
      echo "🔧 Initializing new Jekyll site..."
      jekyll new . --force
      bundle install
    else
      echo "⚠️ Jekyll site already exists. Skipping init."
    fi
    ;;

  serve)
    echo "🚀 Starting local server at http://localhost:4000"
    bundle install
    exec bundle exec jekyll serve --livereload --host 0.0.0.0 --force_polling "$@"
    ;;

  build)
    echo "🏗️ Building static site..."
    bundle install
    exec bundle exec jekyll build "$@"
    ;;

  post|draft|publish)
    echo "📝 Running jekyll-compose command: $MODE $@"
    bundle install
    exec bundle exec jekyll $MODE "$@"
    ;;

  *)
    echo "❌ Unknown mode: $MODE"
    echo "Usage: docker run <image> [init|serve|build]"
    exit 1
    ;;
esac
