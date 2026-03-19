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
