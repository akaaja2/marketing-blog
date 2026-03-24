---
title: "I Asked Claude to Build an Economics Tool. It Took One Prompt."
description: "How a quick conversation with Claude turned a textbook concept into a fully interactive Cobb-Douglas isoquant explorer you can use right now."
date: 2026-03-24
tags: [post, claude, learning, economics, tools]
layout: layouts/post.njk
image: "/images/cobb.png"
imageAlt: "Flat vector illustration of a Cobb-Douglas isoquant and isocost diagram"
takeaways:
  - Claude can turn a textbook concept into a live, slider-driven tool in a single prompt.
  - Embedding the output directly in a post keeps the learning in context.
  - The fastest way to understand an economic model is to break it in real time.
---

A few days ago I was reviewing some microeconomics and hit the classic wall: isoquants and isocost lines are easy to read in a textbook diagram, but hard to *feel* until you can actually move the variables around and watch the optimum shift.

So I asked Claude to build me a tool.

The prompt was roughly: *"Build a self-contained HTML interactive for Cobb-Douglas cost minimisation — sliders for w, r, α and β, a canvas graph showing the isoquant and isocost, and a live readout of L*, K*, and minimum cost."*

That was it. One message. The result is embedded below.

## Try it

<div class="interactive-embed">
  <iframe
    src="/images/cobb_douglas_isoquant_isocost.html"
    title="Cobb-Douglas Isoquant / Isocost Explorer"
    loading="lazy"
    style="width:100%;height:580px;border:none;border-radius:8px;"
  ></iframe>
</div>

Drag the sliders. Watch the green dot — that's the cost-minimising bundle of labour and capital. Switch to **Slutsky decomposition** to split a wage change into substitution and scale effects.

## What this shows about Claude as a learning tool builder

The obvious thing is speed. A static diagram from a textbook takes seconds to read and minutes to forget. An interactive version, where you can push α + β above 1.0 and immediately see increasing returns to scale, actually teaches the concept.

But the more interesting thing is *what you don't have to do*. I didn't specify a charting library. I didn't write the Lagrangian derivation. I didn't worry about canvas sizing or dark mode. Claude handled all of it in a single output — a clean, self-contained HTML file with no dependencies.

## The pattern

This works because the learning objective was clear. When you describe the *concept* you want someone to understand — not just "make a chart" but "show cost minimisation where the isocost is tangent to the isoquant" — Claude can translate that into the right interactive shape.

The prompt structure that works well:

1. Name the concept precisely
2. Say what the learner should be able to manipulate
3. Ask for a live readout of the key outputs
4. Specify self-contained HTML so you can drop it anywhere

That's it. No framework, no build step, no deployment. A working learning tool in the time it takes to write a paragraph.

## What's next

The Slutsky decomposition view in this tool is already more than most students get in a standard course. The next step is pairing it with a short written explanation that updates alongside the sliders — so the graph and the intuition stay in sync. That's a second prompt.

The broader point: Claude is faster at turning a textbook concept into an interactive experience than it takes to find a good YouTube explanation of the same thing. That's a new kind of resource for anyone who learns by tinkering.
