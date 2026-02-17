---
title:  "Tech Tips #3 — Compress Images on macOS Without Extra Tools"
date:   2026-02-17 14:00:00 +0000
categories: tech tutorial macos performance
---

Your website's hero image is 3.2MB. Your page takes 4 seconds to load. You don't want to install ImageMagick or Photoshop. Here's a one-liner using `sips` — a tool that comes pre-installed on every Mac.

## The Command

```bash
sips --resampleWidth 1920 -s formatOptions 80 input.jpg --out output.jpg
```

This does three things:
1. **Resizes** the image to 1920px width (maintaining aspect ratio)
2. **Sets JPEG quality** to 80 (out of 100)
3. **Outputs** to a new file (preserving the original)

## Real-World Example

I had a hero background image at 3805x2538px (3.2MB) and a duplicate copy at 5MB. After compression:

```bash
$ ls -lh hero-bg.jpg
-rw-r--r--  3.2M  hero-bg.jpg

$ sips --resampleWidth 1920 -s formatOptions 80 hero-bg.jpg --out hero-bg-compressed.jpg

$ ls -lh hero-bg-compressed.jpg
-rw-r--r--  307K  hero-bg-compressed.jpg
```

**3.2MB to 307KB** — a 90% reduction with no visible quality loss on screen.

## Why 1920px?

1920px is the width of a standard Full HD display. For a background image, there's no point shipping pixels that no one will see. Even on a 4K display, a well-compressed 1920px image stretched to full width looks fine for a background with a dark overlay.

## Batch Processing

Need to compress multiple images?

```bash
for img in assets/img/*.jpg; do
  sips --resampleWidth 1920 -s formatOptions 80 "$img" --out "${img%.jpg}-compressed.jpg"
done
```

## Other sips Tricks

```bash
# Convert PNG to JPEG
sips -s format jpeg input.png --out output.jpg

# Get image dimensions
sips --getProperty pixelWidth --getProperty pixelHeight image.jpg

# Resize to exact dimensions (may crop)
sips -z 600 800 image.jpg

# Rotate 90 degrees
sips --rotate 90 image.jpg
```

## When to Use Something Else

`sips` is great for quick, scriptable compression. For more control (progressive JPEGs, WebP output, fine-tuned quality), consider:

- `cwebp` — Google's WebP converter
- `jpegoptim` — lossless JPEG optimization (`brew install jpegoptim`)
- `squoosh.app` — browser-based, no install needed

But for a quick "make this image smaller" task, `sips` is hard to beat since it's already on your Mac.
