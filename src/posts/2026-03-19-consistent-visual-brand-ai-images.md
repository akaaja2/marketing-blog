---
title: "Building a Consistent Visual Brand for Your Blog Using AI Images"
description: "Why random stock photos make blogs feel generic, how we defined a cartoon illustration style, and how a style guide file keeps every image consistent automatically."
date: 2026-03-19
tags: [post, behind-the-scenes, ai-tools, visual-design]
layout: layouts/post.njk
image: "/images/consistent-visual-brand-ai-images.png"
imageAlt: "Cartoon robot going from confused mismatched images to a consistent illustrated style"
---
There's a version of this blog that looked like every other AI-generated content site on the internet. Random stock photos of people pointing at whiteboards. Disconnected hero images with no relationship to each other. The kind of visual experience that says "we needed an image so we grabbed one."

That's not what we wanted. Here's how we fixed it — and how you can do the same for your blog, without a designer.

## Why random stock photos make a blog feel generic

A blog's visual identity is made up of dozens of small signals. The font. The spacing. The colour of a link. And the images. When those images are inconsistent — a photograph here, a flat illustration there, a dark moody shot followed by a bright sunny one — readers don't consciously notice, but they feel the lack of cohesion.

Stock photos are the biggest offender. They're shot by different photographers, in different lighting conditions, with different aesthetic intentions. Even if they're all "professional," they don't belong to each other. Your blog ends up looking like it was assembled from spare parts.

## What visual consistency actually means

Consistency isn't about every image looking identical. It's about every image feeling like it came from the same world. Same colour palette. Same illustration style. Same mood. Same level of abstraction.

Think about how Notion, Linear, or Basecamp use illustrations. The characters are simple. The colours are controlled. The style is flat. You could pull any illustration from their websites and immediately know which company it belongs to. That's the goal.

For this blog we settled on four constraints that define every image:

- **Flat vector cartoon style** — no photography, no gradients, no shadows
- **Controlled palette** — white background, accent blue, warm yellow, soft green, bold black outlines
- **Consistent characters** — a round-headed robot represents AI, a glowing laptop represents the writing interface, a rocket represents publishing
- **Left-to-right flow** — process illustrations always read as panels moving from left to right

Once those four constraints were in place, every new image feels like it belongs.

## The real prompts, the rejects, the process

The first attempt at a visual style was too abstract — flowing lines and glowing nodes that looked more like a network diagram than a blog image. The second attempt was too photorealistic — DALL-E 3 gave us a moody dark desk with a dramatic lamp and it felt completely at odds with the blog's clean minimal design.

The breakthrough came from being more specific about the *character* of the illustration, not just the content. Adding "similar to Notion or Linear's illustration language" as a reference point immediately shifted the output. Adding "no gradients, no shadows, bold black outlines" locked in the flat style. Specifying the exact hex value for blue (#2563eb) ensured the images matched the blog's CSS variables.

The final template looks like this:

> "A flat vector cartoon illustration in a clean motion-graphic style, wide 16:9 format. [panel descriptions]. Colour palette: white background, accent blue (#2563eb) for arrows and highlights, warm yellow for energy/action elements, soft green for positive/success elements. Bold black outlines. No gradients, no shadows. Friendly and optimistic mood. No text labels anywhere in the image. Flat design illustration style similar to Notion or Linear's illustration language."

The panel descriptions change per post. Everything else stays the same.

## Creating a style guide Claude Code can reference automatically

The style guide lives in .claude/skills/image-style.md in the project root. Claude Code reads it automatically during any session. When writing a new post and asked to suggest an image, it references the character library and palette defined in that file and describes the panels accordingly.

The result: every post gets an image brief that's consistent with every other post, generated without having to remember or re-specify the style constraints each time.

## The before and after

With no images the blog was functional but felt incomplete — just text on a white page. With the first few random images it looked patchy and inconsistent. With the current style guide in place, each new post gets an illustration that feels deliberately designed rather than hastily grabbed.

The total time investment was about 30 minutes to establish the style. Every image since has taken under 5 minutes to brief, generate, and add to a post. That's a reasonable trade for a blog that looks like it has a point of view.
