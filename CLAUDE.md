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
