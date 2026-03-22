---
title: "How I Turned a Claude Workflow Into a Codex Blog Post Template"
description: "A short conversation turned into a reusable Codex workflow for writing, previewing, and publishing blog posts in this Eleventy site."
date: 2026-03-22
tags: ["post", "codex", "workflow", "blogging", "eleventy"]
layout: "layouts/post.njk"
image: "/images/codex-blog-post-workflow.svg"
imageAlt: "Three-panel vector illustration showing Codex reading instructions, drafting a blog post, and publishing to a live site beneath a TEST IMAGE banner"
takeaways:
  - A good Codex prompt starts by pointing at the repo's source-of-truth instructions.
  - The publishing workflow is simple when the filename, frontmatter, and build steps are fixed.
  - Keeping image generation optional avoids broken post pages while the writing workflow is still being refined.
---

Today I did something I keep meaning to do more often: I turned a quick working conversation into a repeatable workflow.

The starting point was simple. I asked Codex to read the Claude files in this repo and show me the workflow for creating a blog post. Instead of inventing a process from scratch, it checked the actual project instructions first, read the image style guide, and looked through the existing posts to understand the pattern already in use.

That part matters more than it sounds. In a small content repo like this one, the workflow is not hidden in a giant app architecture. It lives in a handful of files: the publishing rules, the post folder, the build command, and the examples that are already working. Once Codex had those, the rest became a formatting and execution problem instead of a guessing problem.

## The workflow we ended up with

The core workflow is now very straightforward.

First, point Codex at the repo instructions. In this project that means reading `CLAUDE.md`, because that file defines the filename format, the required frontmatter, the writing style, and the publishing rules.

Second, give Codex the post inputs: title, topic, goal, date, and target length. That is enough to generate the slug, create the markdown file in `src/posts/`, and write a draft that fits the house style.

Third, decide whether the post should include a hero image. The repo supports one, but the image is optional. We also have a style guide in `.claude/skills/image-style.md`, which means Codex can generate a prompt for a matching illustration even if I do not create the image asset yet.

Fourth, run the build. This repo uses Eleventy plus Pagefind, so `npm run build` is the real check that the post is shaped correctly for the site.

That is basically the whole system: read the rules, write the post, optionally plan the image, then build before publishing.

## Why I like this as a Codex workflow

What I like most is that it removes the vague part of AI writing.

Without repo-specific context, a coding agent will usually produce something that looks plausible but misses local conventions. It might choose the wrong filename, forget a required field, use the wrong layout, or write in a tone that does not match the rest of the site. None of those mistakes are dramatic, but they create cleanup work.

By contrast, this workflow makes Codex start from the source of truth. It reads the file that defines the rules, checks the current post directory, and only then writes. That makes the output feel much closer to working with a careful teammate than with a generic text generator.

I also like that the workflow is modular. The writing part can be done in one pass. The image part can happen later. The build step gives a clear acceptance check. And the final output can include small operational details like the commit message, which is exactly the kind of thing I do not want to think about twice.

## The reusable prompt

The reusable version is short enough that I can actually imagine using it regularly:

1. Tell Codex to read `CLAUDE.md` and the image style guide.
2. Pass in the post title, topic, goal, date, and target length.
3. Ask it to create the file in `src/posts/[YYYY-MM-DD]-[slug].md`.
4. Have it run `npm run build`.
5. Ask it to report the file path, slug, image prompt, and commit message.

That is the key shift for me. I am not asking Codex to "write a blog post" in the abstract. I am asking it to operate inside a documented editorial system.

This post is a nice example of that loop in action because it is literally built from the conversation that defined the workflow. We started by asking Codex to explain the process. Then we turned that explanation into a reusable template. Then we used the template to create a real post that summarises the conversation and documents the workflow itself.

That is a satisfying pattern: document the process, templatise the process, then use the process immediately while it is still fresh.

The next refinement is obvious. I want to keep a small library of these repo-specific Codex prompts so that creating a post, adding an image, or shipping an edit feels like running a known playbook instead of re-explaining the project every time.
