# Project Context

## brolio.dev

Personal developer portfolio site — a single-file showcase of canvas-based interactivity and pixel-art charm.

---

## Architecture

### Single-File Static Site
```
index.html          ← Everything lives here (HTML + CSS + JS)
CNAME               ← Custom domain config (brolio.dev)
.nojekyll           ← Disable GitHub Pages Jekyll processing
```

### Visual Layers (z-index stack)
| Layer | Element | z-index | Purpose |
|-------|---------|---------|---------|
| 0 | `.noise` | 0 | Background texture (SVG filter) |
| 1 | `#trails` | 1 | Canvas particle effects |
| 2 | `.content` | 2 | Main UI (flexbox centered) |
| 3 | `.vignette` | 3 | Edge darkening overlay |
| 9999 | Custom cursor | 9999 | Mouse follower |

### Component Hierarchy
```
body
├── .noise (texture overlay)
├── #trails (particle canvas)
├── .vignette (edge vignette)
├── #cursor / #cursorDot (custom cursor)
└── .content
    ├── #avatar-canvas (pixel art avatar)
    ├── #categoryLabel (typewriter text)
    ├── .title-wrap
    │   └── h1.title (glitch effect on hover)
    ├── .subtitle
    ├── .divider
    ├── .tech-grid
    │   └── .tech-tag × 23 (clickable skill badges)
    ├── .code-window
    │   ├── .code-title-bar (macOS dots)
    │   └── .code-body (typewriter code display)
    └── .status (availability indicator)
```

---

## Stack

### Core Technologies
- **HTML5** — Semantic structure, canvas elements
- **CSS3** — Variables, flexbox, grid, animations, media queries
- **Vanilla JavaScript (ES5/ES6)** — No transpilation, browser-native

### External Resources
- Google Fonts: Fira Code, JetBrains Mono, Outfit

### Deployment
- **GitHub Pages** — Static hosting
- Custom domain via CNAME file
- HTTPS enforced

---

## Structure

```
/home/mariano/projects/embrolio/brolio-dev/
├── .sic/                  ← Ship It Clean workspace
│   ├── constitution.md    ← Project rules
│   ├── project.md         ← This file
│   ├── phases/            ← Work phases
│   ├── intake/            ← Feature requests
│   └── knowledge/         ← Learnings, patterns, solutions
├── .claude/
│   └── settings.local.json ← Claude permissions
├── .git/                  ← Version control
├── index.html             ← The entire website
├── CNAME                  ← brolio.dev
└── .nojekyll              ← Disable Jekyll
```

---

## Integration Points

### GitHub Pages
- Repository serves site directly from root
- `.nojekyll` prevents Jekyll from interfering
- Push to main branch = automatic deploy

### Google Fonts
- Preconnect hints for performance
- Three font families loaded:
  - Fira Code (code snippets)
  - JetBrains Mono (labels, status)
  - Outfit (body text)

### DNS (brolio.dev)
- CNAME file contains: `brolio.dev`
- DNS A/AAAA records point to GitHub Pages IPs

---

## Known Complexity

### Hot Files
| File | Lines | Complexity | Notes |
|------|-------|------------|-------|
| `index.html` | 1557 | High | Everything in one file — careful with edits |

### Complex Systems

#### 1. Particle Engine (lines 489-750)
- 7 particle types with different behaviors
- Trail system with quadratic curves
- Burst effects on click
- Orbital Lissajous motion
- Constellation line drawing (O(n²))

#### 2. Avatar Renderer (lines 982-1138)
- 16×16 pixel grid base character
- 7 interchangeable hat overlays
- Hat-specific color palettes
- Particle animation for hat swaps

#### 3. Category State Machine (lines 1240-1444)
- Auto-cycling timer (5s interval)
- User override via tag clicks
- Typewriter effect coordination
- Visual state synchronization (tags, avatar, code)

#### 4. Typewriter System (lines 1265-1342)
- Two instances: category label + code window
- HTML entity escaping
- Syntax highlighting via span injection
- Scroll-to-bottom for code window

### Performance Considerations
- 90 ambient particles + 20 orbitals + trails = GPU usage
- Constellation lines check all particle pairs (watch n)
- requestAnimationFrame for smooth 60fps
- Mobile: custom cursor disabled to save resources

### Browser Quirks
- Safari: Canvas performance may vary
- Firefox: mix-blend-mode on cursor works differently
- Mobile Safari: Touch events need `preventDefault`

---

## Development Notes

### Making Changes
1. Edit `index.html` directly
2. Test locally by opening file in browser
3. Push to GitHub — auto-deploys via Pages
4. Changes live in ~30 seconds

### Testing Checklist
See `constitution.md` Testing section for full manual QA checklist.

### Future Enhancement Ideas
- Add dark/light mode toggle (respects `prefers-color-scheme`)
- Add contact form (Netlify Forms or similar)
- Add project showcase section
- Add blog/notes section
- Add resume/CV download
