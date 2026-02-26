# AGENTS.md

> OpenCode context file for brolio.dev

## Project Summary

Personal developer portfolio site (`brolio.dev`). Single-file static HTML with heavy canvas interactivity — particle systems, custom cursor, pixel-art avatar with animated hat-swapping, and typewriter effects.

**Key principle:** Everything inline, zero dependencies, zero build step.

## Quick Reference

| Aspect | Value |
|--------|-------|
| **Stack** | Vanilla HTML5, CSS3, JavaScript |
| **Architecture** | Single-file static site |
| **Hosting** | GitHub Pages |
| **Domain** | brolio.dev |
| **Dependencies** | Google Fonts only |
| **Build tools** | None |

## File Layout

```
index.html          ← The entire application
CNAME               ← Domain config (brolio.dev)
.nojekyll           ← Disable GitHub Pages Jekyll
.sic/               ← SIC workspace (session data)
```

## Architecture Notes

### Visual Stack (bottom to top)
1. Noise texture (SVG filter background)
2. Particle canvas (`#trails`) — trails, bursts, ambient particles
3. Content layer — centered flexbox with all UI
4. Vignette overlay — edge darkening
5. Custom cursor — follows mouse with mix-blend-mode

### Key Systems
- **Particle Engine**: 7 particle types, trail rendering, constellation lines
- **Avatar Renderer**: 16×16 pixel grid, 7 hat overlays with swap animations
- **Category State**: Auto-cycling (5s), user override, typewriter sync
- **Typewriter**: Two instances (label + code), HTML escaping, syntax highlighting

### Category System
Categories auto-cycle through skills. Each has:
- Visual hat for avatar (beanie, hard hat, wizard hat, etc.)
- Code snippet in window (TypeScript, SQL, YAML, etc.)
- Tech tags that highlight when active

Categories: `languages` → `frontend` → `api` → `database` → `cloud` → `devops` → `ai`

## Patterns

### CSS
- Custom properties in `:root` for theming
- Mobile-first media queries at end
- Component classes loosely BEM-inspired

### JavaScript
- Constructor functions (not ES6 classes)
- Prototype methods for update/draw
- Global state at top of script
- Separate animation loops for canvas vs avatar

### Colors
```css
--bg: #0a0a0f           /* Deep space black */
--surface: #12121a      /* Elevated surfaces */
--text-primary: #e8e6e3 /* Warm white */
--text-dim: #6b6979     /* Muted purple-gray */
--accent: #64ffda       /* Cyan/aqua */
--accent-secondary: #7c5cfc /* Purple */
--accent-warm: #ff6b6b  /* Coral red */
```

## Constraints

**MUST NOT:**
- Add build tools (webpack, vite, etc.)
- Add JS frameworks (React, Vue, etc.)
- Add CSS preprocessors
- Split into multiple files
- Add npm packages

**MUST:**
- Keep single-file architecture
- Maintain vanilla JS/CSS
- Support GitHub Pages deployment
- Work without server-side logic

## Testing

Manual QA checklist in `.sic/constitution.md`.

Test on:
- Chrome/Edge (primary)
- Firefox
- Safari
- Mobile Safari (touch)

## Common Tasks

### Add new tech tag
Add to `.tech-grid` in HTML:
```html
<span class="tech-tag" data-category="devops">NewTool</span>
```

### Add new category
1. Add to `CATEGORIES` array in JS
2. Create hat pixel overlay array
3. Add to `HATS` array

### Change colors
Edit CSS variables in `:root`, JS will pick up accent colors automatically.

### Update availability status
Change `.status` class and text in HTML:
```html
<div class="status open">  <!-- or "closed" -->
  <span class="status-dot"></span>
  <span class="status-label">open for opportunities</span>
</div>
```

## Deployment

Push to GitHub → auto-deploys via Pages in ~30 seconds.

DNS: `brolio.dev` → GitHub Pages

## SIC Integration

This project uses Ship It Clean (SIC) for coordinated development:

- `.sic/constitution.md` — Project rules and conventions
- `.sic/project.md` — Detailed context and architecture
- `.sic/phases/` — Work phases
- `.sic/intake/` — Feature requests
- `.sic/knowledge/` — Learnings and patterns

Run `/sic-recon` to update project context.
Run `/sic-plan` to create a development plan.
Run `/sic-cook` to execute a plan.
