---
title:  "Tech Tips #4 — Data-Driven Sections in Jekyll"
date:   2026-02-17 15:00:00 +0000
categories: tech tutorial jekyll web-development
---

Instead of hardcoding content in your Jekyll HTML templates, you can use data files to separate content from presentation. This makes updates trivial — edit a JSON file instead of digging through HTML.

## The Pattern

1. Create a data file at `_data/content.json`
2. Access it in templates via `site.data.content`
3. Use Liquid loops to render dynamic sections

## Example: Role Cards

**`_data/content.json`:**

```json
{
  "roles": [
    {
      "icon": "bi bi-journal-text",
      "title": "Researcher",
      "description": "PhD in Health Data Science, 9+ publications",
      "link": "#resume"
    },
    {
      "icon": "bi bi-globe2",
      "title": "Consultant",
      "description": "FHIR/IHE expert, 13+ countries",
      "link": "#resume"
    }
  ]
}
```

**Template:**

{% raw %}
```html
<div class="row">
  {% for role in site.data.content.roles %}
  <div class="col-lg-4 col-md-6">
    <div class="role-card">
      <div class="role-icon"><i class="{{ role.icon }}"></i></div>
      <h4>{{ role.title }}</h4>
      <p>{{ role.description }}</p>
    </div>
  </div>
  {% endfor %}
</div>
```
{% endraw %}

## Filtering with Liquid

You can filter data inline. For example, showing only current positions:

{% raw %}
```html
{% for item in site.data.content.professional %}
  {% if item.date contains "Present" %}
    <div class="current-role">
      <h4>{{ item.position }}</h4>
      <p>{{ item.date }}</p>
    </div>
  {% endif %}
{% endfor %}
```
{% endraw %}

This is how you can show concurrent roles side by side — filter for "Present" in the date field and render them in a grid.

## Supported Formats

Jekyll supports data files in:
- **JSON** — `_data/content.json`
- **YAML** — `_data/content.yml`
- **CSV** — `_data/content.csv`

YAML is the most common in Jekyll projects, but JSON works great if you're more comfortable with it or want to share the data with JavaScript.

## Benefits

- **Non-developers can update content** by editing a JSON file
- **No risk of breaking HTML** structure when updating text
- **Easy to add/remove items** — just add an object to the array
- **Reusable** — the same data can power multiple sections

## Gotcha: HTML Entities

If your JSON contains HTML entities (like `&amp;`), Jekyll will render them correctly. But if you need actual HTML tags in your data, use the `| raw` filter or store the content in a separate include file.
