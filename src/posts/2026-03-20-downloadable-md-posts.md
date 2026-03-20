---
title: "Let Readers Download Your Raw Markdown"
date: 2026-03-20
description: "A tiny 11ty feature that makes every blog post a living document — one passthrough rule and a download link and you're done."
tags: ["post", "11ty", "tutorial", "blog"]
image: "/images/downloadable-md-posts.png"
imageAlt: "Three-panel illustration showing a blog post, the mascot robot copying a file, and a reader's laptop with a downloaded markdown document"
downloadable: true
layout: layouts/post.njk
---

Some readers don't just want to read your post — they want to take it home with them. Marketers saving prompts, developers copying templates, writers remixing your structure. A raw Markdown file is genuinely useful and costs almost nothing to offer.

This is a three-minute feature: one line in `.eleventy.js`, one conditional block in your post layout, and a frontmatter toggle you control per post.

---

## What we're building

When `downloadable: true` is set in a post's frontmatter, a download link appears on that post. Clicking it saves the raw `.md` source file to the reader's device — not a render, the actual Markdown.

The URL pattern is simple: `/downloads/[post-slug].md`

---

## Step 1 — Copy the source files at build time

Open `.eleventy.js` and add a passthrough copy rule alongside your other static asset rules:

```js
eleventyConfig.addPassthroughCopy({ "src/posts/*.md": "downloads" });
```

This tells 11ty to take every `.md` file in `src/posts/` and copy it into `_site/downloads/` when it builds. On Netlify, that folder becomes publicly accessible at `/downloads/`.

That's the whole back-end. One line.

---

## Step 2 — Add the download link to the post layout

Open `src/_includes/layouts/post.njk` and add this wherever you want the button to appear — after the post content is a natural spot:

```html
{% if downloadable %}
  <a href="/downloads/{{ page.fileSlug }}.md" download class="download-link">
    Download .md
  </a>
{% endif %}
```

The `download` attribute tells the browser to save the file rather than try to render it. `page.fileSlug` is 11ty's built-in variable for the filename without extension — so a post at `src/posts/my-great-post.md` becomes `/downloads/my-great-post.md` automatically.

Style the link however you like. You might match it to your existing button styles, or keep it as a subtle text link.

---

## Step 3 — Turn it on per post

In any post you want to offer the download on, add one line to the frontmatter:

```yaml
---
title: "My Post"
date: 2026-03-20
downloadable: true
---
```

Posts without the flag get no link. You stay in control of what's downloadable.

---

## Why this is worth doing

The people most likely to download your Markdown are exactly the people you want reading you closely — developers, writers, and power users who find your work genuinely useful. It's a small trust signal that you're not hiding anything, and a practical gift to readers who work in Markdown themselves.

It also quietly makes every post a distributable template. If you write a structured prompt, a decision framework, or a recurring document format, readers can grab the source and adapt it immediately.

---

## Deploy it

Push to GitHub, let Netlify rebuild, and test by hitting `/downloads/[your-test-slug].md` directly in the browser. If the file downloads rather than renders, you're done.

The whole change is two files and three lines of code. Ship it.

{% downloadLink "2026-03-20-downloadable-md-posts.md", "Download this post as Markdown" %}
