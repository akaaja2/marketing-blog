# Marketing Blog — Claude Code Instructions
## About this project
- 11ty (Eleventy) static blog
- GitHub repo: akaaja2/marketing-blog
- Live site: https://claude4marketing.netlify.app/
- Posts live in: src/posts/
- Deploy: pushing to main triggers Netlify auto-deploy
## Publishing a new post
### File naming
src/posts/YYYY-MM-DD-slug.md
Use today's date and a lowercase hyphenated slug from the title.
### Required frontmatter
---
title: "Post Title Here"
description: "One sentence summary"
date: YYYY-MM-DD
tags: [post]
layout: layouts/post.njk
---
### Publishing steps
1. Write the post as a .md file with correct frontmatter
2. Commit with message: "Add post: [title]"
3. Push to origin/main using gh CLI
4. Confirm push succeeded
## Style guidelines
- Write in first person, conversational tone
- Posts should be 300-600 words unless otherwise specified
- Use subheadings for posts over 400 words
- No keyword stuffing — write for humans
## Do not
- Modify any files in _site/
- Change .eleventy.js without being asked
- Push to any branch other than main
## Eleventy 3.x compatibility notes
These are known issues that have already bitten us — don't reintroduce them.
### Date filter
Templates use `%B %d, %Y` (strftime-style). The date filter must handle
this format and return dates in US locale order (March 19, 2026 — not
19 March 2026). The working implementation uses `toLocaleDateString`
with `en-US` locale. Do not switch to `MMMM dd, yyyy` format.
### Reading time on collection items
In Eleventy 3.x, `post.templateContent` is not reliably available on
collection items in templates. Always use `post.content` instead.
`templateContent` will silently return undefined and break the
readingTime filter without throwing an error.
### Passthrough copy
CSS and favicon files must be explicitly added via `addPassthroughCopy`
in `.eleventy.js` or they will not appear in `_site/`. Current entries:
- `eleventyConfig.addPassthroughCopy("src/css");`
- `eleventyConfig.addPassthroughCopy("src/favicon.svg");`
## Images
### Featured/hero image (optional, per post)
Add to post frontmatter:
image: "/images/filename.jpg"
imageAlt: "Descriptive alt text for accessibility"
The image file must be placed in src/images/ before pushing.
It will appear as a hero image on the post page, a card image
on the homepage, and populate og:image for social previews.
### Images in post body
Standard Markdown:
![Alt text](/images/filename.jpg)
For captions, wrap in a figure:
<figure>
  <img src="/images/filename.jpg" alt="Alt text">
  <figcaption>Caption text here</figcaption>
</figure>
### External image URLs (Unsplash, Cloudinary etc.)
Can be used directly in frontmatter or Markdown:
image: "https://images.unsplash.com/photo-xxx?w=1200"
No need to download — reference the URL directly.

---
## Current state — updated 2026-03-19
### Live site
https://claude4marketing.netlify.app/
### Features now live
- Clean minimal design — Inter + Lora fonts, accent blue #2563eb
- Dark mode with manual toggle (☀/☾) and localStorage persistence
- Reading progress bar on post pages (3px, accent blue, fixed top)
- Post tags — pill style, link to /tags/[tag]/ pages
- Reading time estimate — wordCount ÷ 200, shown in post meta
- Social share links — Twitter/X, LinkedIn, copy link (post pages)
- Related posts — shows up to 3 posts sharing tags (post pages)
- Hero images — frontmatter: image: and imageAlt:
- Body images — standard Markdown ![alt](/images/file.png)
- Favicon — serif "C" monogram, accent blue, SVG
- Open Graph + Twitter Card meta tags — auto-populates social previews
- og:image — uses post hero image if present
- Google Search Console verification tag — in base.njk
- Custom 404 page — mascot image, links to home and search
- About page — /about/
- Pagefind search — /search/, indexes on every build
- Back to top button — appears after 400px scroll, bottom-right
- netlify.toml — explicit build command and publish directory
### Pages
- / — homepage, reverse chronological post list
- /about/ — about page
- /search/ — Pagefind search
- /tags/[tag]/ — tag listing pages
- /404.html — custom 404
### File structure
src/
  posts/         ← blog posts go here
  images/        ← local images go here
  css/style.css  ← all styles
  _includes/layouts/
    base.njk     ← global HTML wrapper, nav, head
    post.njk     ← individual post template
  index.njk      ← homepage
  about.njk      ← about page
  search.njk     ← search page
  404.njk        ← 404 page
  _data/metadata.json ← site title, url, description
  .claude/skills/image-style.md ← image style guide
### Post frontmatter — full reference
---
title: "Post Title"
description: "One sentence summary"
date: YYYY-MM-DD
tags: [post, tag2, tag3]
layout: layouts/post.njk
image: "/images/filename.png"        # optional hero image
imageAlt: "Alt text for image"       # required if image present
takeaways:                           # optional, for posts 400+ words
  - Key point one
  - Key point two
  - Key point three
---
### Image guidelines
- Local files: save to src/images/, reference as /images/filename.png
- External URLs (Unsplash, Cloudinary): use full URL directly in image:
- Style: flat vector cartoon, Notion/Linear style, see .claude/skills/image-style.md
- DALL-E 3 prompt template in image-style.md
### Eleventy 3.x compatibility notes
- Date filter uses toLocaleDateString with en-US locale for %B %d, %Y format
- Use post.content not post.templateContent in collection loops
- All passthrough assets must be explicitly declared in .eleventy.js
### Build
- npm run build → eleventy + pagefind
- npm start → local dev server at localhost:8080
- Push to main → Netlify auto-deploys in ~20s
### MCP connectors (Claude Code)
- GitHub MCP: ✅ connected via npx @modelcontextprotocol/server-github
- Netlify MCP: ❌ blocked (Node/npx issue on Windows — retry after machine restart)
- Publishing workaround: use gh CLI (already authenticated)
### Tomorrow's priority
- ERD-111 — JSON-LD structured data (Urgent)
- ERD-125 — Clickable post card images (High)
- ERD-107 — Buttondown newsletter signup (High)
- ERD-101 — Sitemap + RSS feed (High)
---
