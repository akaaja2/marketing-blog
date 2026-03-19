---
# Blog Image Style — claude4marketing.netlify.app

## Core style
Flat vector cartoon illustration, clean motion-graphic style, wide 16:9 format. Friendly, optimistic mood. Similar to Notion or Linear's illustration language.

## Colour palette
- Background: white (#ffffff)
- Arrows and highlights: blue (#2563eb)
- Energy/action: warm yellow
- Success/positive: soft green
- Outlines: bold black

## Rules
- Bold black outlines always
- No gradients, no shadows, no text labels in image
- White background always
- Left-to-right flow for process illustrations
- 2-3 panels connected by thick curved blue arrows

## DALL-E 3 prompt template
Use this wrapper for every blog image prompt:

"A flat vector cartoon illustration in a clean motion-graphic style, wide 16:9 format. [PANELS AND CONTENT] Colour palette: white background, accent blue (#2563eb) for arrows and highlights, warm yellow for energy/action elements, soft green for positive/success elements. Bold black outlines. No gradients, no shadows. Friendly and optimistic mood. No text labels anywhere in the image. Flat design illustration style similar to Notion or Linear's illustration language."

## Filename convention
src/images/[post-slug].png

## Frontmatter
image: "/images/[post-slug].png"
imageAlt: "Brief description of the illustration"

## When writing a post
If asked to suggest an image, describe 2-3 cartoon panels that represent the post's core concept using the characters below.

## Characters
- Round-headed robot with big eyes = Claude/AI
- Glowing laptop = conversation/writing interface
- Branching commit dots = Git/code history
- Rocket launching = deploy/publish
- Small glowing screen = live website
- Speech bubble with dots = chat/AI thinking
- Green round button = action/publish button
- Sparkles = activity/magic/something happening
