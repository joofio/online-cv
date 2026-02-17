---
title:  "Tech Tips #2 — Jekyll + GitHub Pages on Ruby 3.0"
date:   2026-02-17 13:00:00 +0000
categories: tech tutorial ruby jekyll github-pages
---

Getting Jekyll with the `github-pages` gem to work on Ruby 3.0+ is surprisingly painful. Here's the checklist of everything that breaks and how to fix it.

## Problem 1: Missing webrick

Ruby 3.0 removed `webrick` from the standard library. When you run `bundle exec jekyll serve`, you'll get:

```
cannot load such file -- webrick
```

**Fix:**

```bash
bundle add webrick
```

## Problem 2: Stale Gemfile.lock

If your `Gemfile.lock` was generated with an older Bundler version (e.g., 1.17.2), you'll see:

```
Could not find 'bundler' (1.17.2) required by `$BUNDLER_VERSION`
```

**Fix:**

```bash
rm Gemfile.lock
bundle install
```

This regenerates the lock file with your current Bundler version.

## Problem 3: bibtex-ruby Proc.new

If you use `jekyll-scholar`, `bibtex-ruby 4.x` uses `Proc.new` without a block — removed in Ruby 3.0. See my [previous post](/tech/tutorial/ruby/jekyll/2026-02-17-fixing-bibtex-ruby3.html) for the full fix.

## Problem 4: GitHub API Rate Limits

The `jekyll-github-metadata` plugin calls the GitHub API during builds. Without authentication, you're limited to 60 requests/hour and will hit:

```
403 - API rate limit exceeded
```

**Fix:**

```bash
export JEKYLL_GITHUB_TOKEN=your_personal_access_token
bundle exec jekyll serve
```

Create a token at [GitHub Settings > Tokens](https://github.com/settings/tokens) with `public_repo` scope.

## The Nuclear Option

If you're tired of fighting compatibility issues, the cleanest options are:

1. **Use Ruby 2.7** via rbenv — this is what `github-pages` was designed for
2. **Drop the `github-pages` gem** and manage Jekyll + plugins directly
3. **Use Docker** with a pre-configured Jekyll image

## My Recommended Setup

```bash
# Install Ruby 2.7 (most compatible)
rbenv install 2.7.8
rbenv local 2.7.8

# Fresh install
rm Gemfile.lock
bundle install
bundle exec jekyll serve
```

Or if you want to stay on Ruby 3.0+, apply all the fixes above and add `webrick` to your Gemfile. It works — it just takes some patching.
