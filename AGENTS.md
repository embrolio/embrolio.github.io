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

## Revised Constraints (2026-04-16)

The publishing section (`/writing/`) introduces a bounded exception to the single-file architecture:

**Permitted:**
- `/writing/` directory with standalone article pages
- Shared stylesheet (`/writing/styles.css`) for writing section only
- Shared runtime (`/writing/writing.js`) for UX enhancements
- `/writing/index.html` as article listing page

**Maintained:**
- Homepage (`index.html`) remains single-file, inline everything
- No build tools, no npm, no bundlers
- GitHub Pages hosting
- Zero dependencies except Google Fonts
- Articles are static HTML with OG tags

**Rationale:**
The publishing section is functionally a separate "app" from the portfolio homepage. Articles need unique URLs for OG cards, which requires separate HTML files. The bounded exception keeps the spirit of the original constraints (simplicity, no build tools) while acknowledging the reality of multi-page publishing requirements.

**Limits:**
- Exception applies ONLY to `/writing/` directory
- No further directory proliferation without revisiting constraints
- Writing section must remain vanilla HTML/CSS/JS
- No server-side logic, no CMS, no database
