# Architecture Decision Record (REVISED)

**Workflow**: publishing-section-2026-04-16  
**Date**: 2026-04-16T17:00:00Z  
**Status**: Approved (with constraint revision)

## Constraint Revision Notice

**Original Constraint:** "Single-file architecture, MUST NOT split into multiple files"

**Revised Constraint:** "Homepage remains single-file; bounded exception for `/writing/` directory with documented rationale"

**Rationale:** Articles require unique URLs for OG/social sharing, which necessitates separate HTML files. This is a pragmatic exception that maintains the spirit (zero build tools, vanilla stack) while acknowledging publishing reality.

---

## Context

Add a publishing/writing section to the existing single-page portfolio site (brolio.dev) while maintaining zero build tools, GitHub Pages hosting, OG cards for sharing, and consistent visual identity with the homepage.

Key constraints:
- ~1 article per week, 4-20 articles over 6 months
- Article lengths: 950-1,400 words
- Need rich OG/social preview cards (with images)
- Two-column layout on desktop, single-column on mobile
- Shared stylesheet approach
- Source Serif 4 font for body text
- Reading progress indicator
- Reading time calculation
- NO particle background on articles (clean reading experience)

## Selected Approach

**Option B — Canonical Index + Shared Writing Runtime (REVISED)**

Keep articles static for OG/SEO. Use one shared `writing.js` for reading progress, reading time, and mobile navigation. Article index is static HTML in `writing/index.html` — **no fetch/parse sidebar hydration**. Sidebars are static markup with manual updates.

## Key Design Decisions

### Responsive Breakpoints (REVISED)
- **1040px+**: Two-column grid (680px main + 280px sidebar + 80px gap)
- **640px–1039px**: Single-column layout
- **<=640px**: Reduced typography scale
- **<=480px**: Minimal padding

*Rationale: Previous 901px breakpoint was mathematically insufficient for declared widths.*

### Reading Progress UI
**Fixed top progress bar** — Works on both desktop and mobile, 3px height, accent color fill

### Article Index Structure
**Static HTML in `writing/index.html`** — Canonical article list. Sidebars use static markup (manually copy or use template snippet). No fetch/parse dependency.

### Particle Background
**REMOVED from articles** — Clean reading experience. Articles maintain visual consistency through:
- Shared color tokens from homepage
- Noise texture background (optional)
- Vignette overlay
- Typography harmony

### CSS Architecture
- Reuse homepage custom properties (`:root` tokens)
- Namespace all writing selectors with `writing-` prefix
- Source Serif 4 for body text (400 regular, 600 semibold for headings)
- Inter or system sans-serif for UI/meta text

### OG Image Strategy
**Shared default image** for all writing pages:
- Single `og-image.jpg` (or PNG) in `/writing/` directory
- 1200×630px dimensions
- Site branding + "brolio.dev" + abstract visual element
- `twitter:card=summary_large_image` for rich preview

*Per-article images: Optional future enhancement, not required for MVP.*

## Files to Create

| File | Purpose |
|------|---------|
| `writing/template.html` | Article template with OG tags, static sidebar snippet |
| `writing/index.html` | Article listing page, canonical archive |
| `writing/styles.css` | Shared writing styles, responsive rules |
| `writing/writing.js` | Shared runtime: progress, reading time, mobile nav |
| `writing/og-image.jpg` | Default OG image for social sharing |

## Files to Modify

| File | Changes |
|------|---------|
| `index.html` | Add subtle "Articles" link below status block |
| `AGENTS.md` | Document constraint revision (done) |

## Simplified Sidebar Approach

**Static markup with template snippet:**

Each article includes sidebar HTML directly (not hydrated via JS):

```html
<aside class="writing-sidebar">
  <nav class="writing-sidebar__nav">
    <h3>All Articles</h3>
    <ul class="writing-sidebar__list">
      <li class="writing-sidebar__item writing-sidebar__item--current">
        <a href="/writing/current-slug.html">Current Article Title</a>
        <time>Apr 16, 2026</time>
      </li>
      <!-- Copy from index.html when adding new article -->
    </ul>
  </nav>
</aside>
```

**Maintenance:** When adding a new article, copy the sidebar snippet from `writing/index.html` and update the `writing-sidebar__item--current` class. 30 seconds per article, zero runtime dependencies.

## OG Tags Structure (Per Article)

```html
<meta property="og:title" content="{Article Title}">
<meta property="og:description" content="{Excerpt ~150 chars}">
<meta property="og:type" content="article">
<meta property="og:url" content="https://brolio.dev/writing/{slug}.html">
<meta property="og:site_name" content="brolio.dev">
<meta property="og:image" content="https://brolio.dev/writing/og-image.jpg">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="{Article Title}">
<meta name="twitter:description" content="{Excerpt ~150 chars}">
<meta name="twitter:image" content="https://brolio.dev/writing/og-image.jpg">
```

## Consequences

### Positive
- **OG cards actually work** — Unique URLs, proper images, rich social previews
- **Clean reading experience** — No particle distraction on long-form content
- **Zero runtime dependencies** — Static sidebars, no fetch/parse fragility
- **Breakpoint math works** — 1040px+ is mathematically sound for declared widths
- **Maintainable with volume** — Shared runtime for behavior, static markup for structure

### Negative
- **Manual sidebar sync** — 30 seconds per article to copy/update sidebar snippet
- **Single OG image** — All articles share same social preview image (acceptable for MVP)
- **One exception opens door** — Future features may request similar exceptions

## Migration Path (Future)

If volume exceeds 20+ posts or friction becomes annoying:
1. Create `_articles/` folder for Markdown source
2. Add GitHub Actions workflow for Markdown → HTML conversion
3. Maintain same output URLs (`/writing/{slug}.html`)
4. Sidebar snippet becomes template variable, auto-generated
5. No breaking changes for existing links

## Rollback Strategy

If issues arise:
1. Remove `/writing/` directory entirely
2. Remove "Articles" link from `index.html`
3. Revert `AGENTS.md` constraint revision
4. No routing, data, or deployment migration required
5. GitHub Pages returns to pre-publishing state immediately
