---
title:  "Tech Tips #1 — Fixing bibtex-ruby with Ruby 3.0"
date:   2026-02-17 12:00:00 +0000
categories: tech tutorial ruby jekyll
---

If you're running Jekyll with `jekyll-scholar` on Ruby 3.0+, you've probably hit this error:

```
Liquid Exception: tried to create Proc object without a block in index.html
```

The root cause is that `bibtex-ruby 4.4.7` uses `Proc.new` without an explicit block — a pattern that was deprecated in Ruby 2.7 and **removed entirely in Ruby 3.0**.

## The Problem

In `bibtex-ruby`, several methods use this pattern:

```ruby
def each
  if block_given?
    data.each(&Proc.new)  # This fails in Ruby 3.0+
    self
  else
    to_enum
  end
end
```

`Proc.new` without an argument used to implicitly capture the block passed to the enclosing method. Ruby 3.0 removed this behavior because it was considered too "magical."

## The Fix

You need to patch the gem files directly. The affected files are:

**`bibtex-ruby/lib/bibtex/bibliography.rb`** — methods `each`, `each_entry`, `unify`, `select_duplicates_by`:

```ruby
# Change:
def each
  data.each(&Proc.new)

# To:
def each(&block)
  data.each(&block)
```

**`bibtex-ruby/lib/bibtex/entry.rb`** — methods `each`, `convert`:

```ruby
# Change:
def convert(*filters)
  block_given? ? dup.convert!(*filters, &Proc.new) : dup.convert!(*filters)

# To:
def convert(*filters, &block)
  block_given? ? dup.convert!(*filters, &block) : dup.convert!(*filters)
```

## Finding the Gem Files

To locate where the gem lives:

```bash
bundle info bibtex-ruby
# or
bundle show bibtex-ruby
```

Then edit the files at that path.

## Why Not Just Upgrade?

The issue is a dependency chain: `github-pages` gem locks Jekyll to 3.10.0, and `jekyll-scholar >= 7.0` requires Jekyll 4. So you're stuck with `jekyll-scholar 5.x` and `bibtex-ruby 4.x` unless you drop the `github-pages` gem entirely.

## Takeaway

When upgrading Ruby versions, always check your gem dependencies for deprecated patterns. The `Proc.new` change is one of the most common Ruby 3.0 breaking changes, and it affects more gems than just `bibtex-ruby`.
