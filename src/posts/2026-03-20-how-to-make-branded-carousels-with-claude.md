---
title: "How to Make Branded Instagram Carousels with Claude — In Minutes"
description: "A step-by-step walkthrough of using Claude to plan, write, and render fully branded Instagram carousel slides as PNG files — complete with mascot characters, brand typography, and a swipeable phone mockup on the post."
date: 2026-03-20
tags: [post, tutorial, claude-for-marketers, instagram, content-marketing]
layout: layouts/post.njk
image: "/images/how-to-make-branded-carousels-with-claude.png"
imageAlt: "The blog mascot robot sitting at a laptop with three Instagram carousel slides floating above it, each with a different mascot pose"
showCarousel: true
carouselSlides:
  - /images/carousels/how-to-make-branded-carousels/slide-01-cover.png
  - /images/carousels/how-to-make-branded-carousels/slide-02.png
  - /images/carousels/how-to-make-branded-carousels/slide-03.png
  - /images/carousels/how-to-make-branded-carousels/slide-04.png
  - /images/carousels/how-to-make-branded-carousels/slide-05.png
  - /images/carousels/how-to-make-branded-carousels/slide-06.png
  - /images/carousels/how-to-make-branded-carousels/slide-07-cta.png
---

Most Instagram carousels that marketers produce follow a familiar production path: open Canva, pick a template, resize seven times, write the copy, argue with the fonts, export one slide at a time. On a good day it takes an hour. On a bad day it takes an afternoon and still looks off-brand.

This post documents a different approach — one where Claude handles the arc planning, slide copy, image generation, and file export in a single session. The carousel you can swipe through above this post was built that way. Start to finish, it took under ten minutes.

Here's exactly how to replicate it.

## What Claude is actually doing

Before walking through the steps, it's worth being clear about what's happening technically.

Claude isn't using a drag-and-drop design tool. It's writing a Python script — using the Pillow image library — that constructs each slide programmatically: placing text, drawing shapes, applying the brand colour palette, and compositing your mascot images onto each frame. The output is a folder of 1080×1080px PNG files, ready to upload directly to Instagram.

This means the output is perfectly consistent across slides (no "oops, I used the wrong shade of blue on slide 4"), reproducible (run the script again and you get identical files), and completely under your control (every colour, font size, and layout decision is visible and editable in the script).

It also means you need to upload your brand assets once — your mascot PNGs, in this case — and Claude handles the rest.

## The four-step process

### Step 1: Upload your mascot images

Drop your PNG files into the conversation. Claude scans the uploads automatically, looking for filenames that suggest brand assets: mascot, robot, logo, avatar, icon, brand, character. If none match, it falls back to picking up all PNGs in the upload.

In this case, three mascot variants were uploaded: the checklist robot, the laptop robot, and the lightbulb robot. Claude detects all three and assigns them to slots A, B, and C for rotation across slides.

### Step 2: Describe your topic and audience

One sentence is genuinely enough. Something like:

> "Create a carousel about this exact process — how to make branded carousels with Claude, simple steps, for marketers who don't code."

Claude then:

- Chooses a narrative arc (in this case: Problem → Steps → CTA)
- Writes the hook, one idea per slide, and the CTA
- Plans which mascot goes on which slide before rendering anything

### Step 3: Review and approve the mascot plan

Before a single pixel renders, Claude prints a plan:

```
Mascot plan:
  Slide 1 (cover) → mascot1.png [character, 270px]
  Slide 2 (body)  → mascot2.png [watermark, 130px]
  Slide 3 (body)  → mascot3.png [watermark, 130px]
  Slide 4 (body)  → mascot1.png [watermark, 130px]
  Slide 5 (body)  → mascot2.png [watermark, 130px]
  Slide 6 (body)  → mascot3.png [watermark, 130px]
  Slide 7 (CTA)   → mascot3.png [character, 270px]
```

The distinction matters: body slides get the mascot as a small semi-transparent watermark in the bottom-right corner — brand presence without distraction. The cover and CTA slides get a larger, fully opaque character treatment, where the mascot is part of the composition.

You can override any assignment in plain English: "use the lightbulb robot on the cover" and Claude will update the plan before rendering.

### Step 4: PNG slides render and download

Once the plan is confirmed, Claude runs the render script. For a 7-slide carousel, this takes a few seconds. Each slide is saved at 1080×1080px — the standard Instagram square format — and you download them all directly from the conversation.

## What's happening with the mascots

One detail worth highlighting: the mascot images were originally on white backgrounds (standard for cartoon illustrations). Before compositing them onto slides, Claude strips the white background by converting near-white pixels to transparent. This means the robots sit cleanly on any slide background — the blue accent block on the cover, the white body slides, the CTA layout — without a white box around them.

The two placement modes — watermark and character — are rendered differently:

**Watermark (body slides):** The mascot is resized to 130px, composited in the bottom-right corner at ~70% opacity. It reads as a brand stamp, not a character. It doesn't compete with the slide content.

**Character (cover + CTA):** The mascot is resized to 270px, fully opaque, and positioned as a visual element in the layout. On the cover it sits in the bottom-right, large enough to be clearly visible. On the CTA slide it's centred at the bottom, part of the composition.

## The typography and palette

Since GitHub was blocked during this session (the environment restricts external downloads), Claude fell back to system fonts: DejaVu Serif Bold for headlines and Liberation Mono for labels and body text. In a full setup, the skill downloads DM Serif Display and DM Mono — the blog's brand fonts — automatically.

The palette is locked to the blog's style guide:

- White background (#ffffff)
- Accent blue (#2563eb) — used for the cover block, label badges, divider lines, dots
- Warm yellow — used for the handle highlight on the CTA slide
- Soft green — used for the "Step 4" success label on slide 6
- Near-black (#1a1a1a) — headlines

No gradients. No shadows. Bold outlines on structural elements. Exactly the flat cartoon aesthetic from the style guide.

## The carousel skill

This workflow is powered by a Claude skill — a set of instructions that Claude reads before starting any carousel session. The skill covers:

- Asset detection logic (how to find mascot files in uploads)
- The mascot assignment system (rotation, character vs watermark treatment, override parsing)
- Four layout variants (cover, body, stat, CTA) with Python/Pillow rendering code
- The narrative arc framework for writing slide copy
- Caption and hashtag strategy
- A full quality checklist

The skill is installed in this Claude project, which means any future carousel request automatically inherits all of this logic — the brand palette, the mascot rotation, the layout system — without you having to re-explain it.

## What this looks like in practice

The carousel in the mockup above this post was built in a single conversation, in one session, without touching a design tool. The total prompt from the user was:

> "generate on the topic of: this process, how to do this, simple steps"

That's it. Claude handled everything else — the arc, the copy, the mascot plan, the rendering, the files.

For a marketer who publishes regularly, this changes the economics of carousel content significantly. The bottleneck is no longer the production; it's having something worth saying.

## Try it yourself

If you want to replicate this:

1. Make sure you're working in a Claude project with the instagram-carousel skill installed
2. Upload 1–3 mascot or brand PNG files
3. Tell Claude your topic and audience in one sentence
4. Review the mascot plan, override anything that looks wrong
5. Download your 7 PNG slides

The whole thing runs inside a single Claude conversation. No Canva, no Figma, no Python environment to set up yourself — Claude handles the execution.

---

*This blog is built with Claude — posts, code, and images included. The carousel above was generated in the same session as this post.*
