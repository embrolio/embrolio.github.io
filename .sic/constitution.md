# Project Constitution

## Overview
Personal developer portfolio site (`brolio.dev`) — single-file static HTML with heavy canvas-based interactivity. No build step, no frameworks, just pure vanilla everything.

## Patterns

### Single-File Architecture
- All HTML, CSS, and JavaScript inline in `index.html`
- No external assets beyond Google Fonts CDN
- Zero dependencies, zero build tools
- Self-contained deployable unit

### Canvas-First Interactivity
- Primary canvas (`#trails`) handles particle systems, trails, effects
- Secondary canvas (`#avatar-canvas`) for pixel-art avatar rendering
- All animation via `requestAnimationFrame`
- Particle classes: TrailPoint, Particle, BurstParticle, Ring, AmbientParticle, OrbitParticle, HatPixelParticle

### CSS Custom Properties (Variables)
```css
--bg: #0a0a0f
--surface: #12121a
--text-primary: #e8e6e3
--text-dim: #6b6979
--accent: #64ffda
--accent-secondary: #7c5cfc
--accent-warm: #ff6b6b
```

### Component-Like CSS Classes
- `.content` — Main wrapper with flex centering
- `.tech-tag` — Interactive skill badges with hover states
- `.code-window` — Mac-style terminal mockup
- Status indicators (`.status.open`, `.status.closed`)

### Category State Machine
- 7 categories: languages, frontend, database, cloud, devops, ai, api
- Each category has: label, filename, hat colors, code snippet
- Auto-cycles every 5 seconds
- User can override by clicking tags

## Conventions

### Naming
- IDs use kebab-case: `avatar-canvas`, `categoryLabel`
- CSS classes use kebab-case: `tech-tag`, `code-window`
- JavaScript variables use camelCase
- Constants use UPPER_SNAKE_CASE

### CSS Organization
1. CSS Reset (`* { margin: 0; padding: 0; box-sizing: border-box }`)
2. CSS Variables (`:root`)
3. Global styles (`html`, `body`)
4. Canvas layers (`#trails`, `.noise`, `.vignette`)
5. Components (ordered by DOM appearance)
6. Animations (`@keyframes`)
7. Media queries (mobile overrides last)

### JavaScript Patterns
- Constructor functions (not ES6 classes) for browser compatibility
- Prototype methods for update/draw cycles
- Global state variables at top of script
- Animation loops separated by concern (main canvas vs avatar)
- Event delegation for dynamic elements

### Color Coding System
Category colors mapped to hat accessories:
- Languages: Red beanie (#d94040)
- Frontend: React blue (#2a9fd6)
- Database: Yellow hard hat (#d4a017)
- Cloud: Purple wizard hat (#7c5cfc)
- DevOps: Orange backwards cap (#e67e22)
- AI: Green robot antenna (#22c55e)
- API: Silver top hat (#c0c0c0)

## Testing

### Manual Testing Checklist
- [ ] Custom cursor follows mouse smoothly
- [ ] Click anywhere creates burst particles
- [ ] Hover over title triggers glitch effect
- [ ] Tech tags highlight on hover
- [ ] Clicking tag switches category
- [ ] Avatar hat changes with animation
- [ ] Code window typewriter effect
- [ ] Auto-cycle resumes after 5s of inactivity
- [ ] Mobile: default cursor shown, no custom cursor

### Browser Support
- Chrome/Edge (primary)
- Firefox
- Safari (watch for canvas performance)
- Mobile Safari (touch events)

## Security

### Content Security Policy Considerations
- Only external resource: Google Fonts (fonts.googleapis.com, fonts.gstatic.com)
- No user input handling
- No cookies, no localStorage
- No sensitive data

### Deployment
- GitHub Pages with `.nojekyll` (disable Jekyll processing)
- CNAME file points to `brolio.dev`
- HTTPS enforced by GitHub Pages

## Forbidden

- ❌ No build tools (webpack, vite, etc.)
- ❌ No JavaScript frameworks (React, Vue, etc.)
- ❌ No CSS preprocessors (Sass, Less)
- ❌ No external JavaScript libraries
- ❌ No npm packages
- ❌ No TypeScript (keep it vanilla)
- ❌ No splitting into multiple files (keep it single-file)
- ❌ No server-side logic (static only)

## Gotchas

1. **Avatar canvas size**: 16x16 base grid + 4 extra rows for tall hats = 128x192 effective
2. **Particle limits**: 90 ambient, 20 orbital, 50 trail points — watch performance on low-end devices
3. **Mobile detection**: Uses `matchMedia('(hover: none) and (pointer: coarse)')` to disable custom cursor
4. **Constellation lines**: O(n²) check — if adding more ambient particles, consider optimization
5. **Typewriter timing**: 35ms for label, 18ms for code — adjust for feel, not too fast

## Intake System

### Intake Folder Structure
```
.sic/intake/
├── index.yaml           ← Status tracking
└── {date-slug}/         ← e.g., 2026-02-26-new-feature
    ├── intake.md        ← Howard spec (mandatory)
    └── research.md      ← Hank findings (optional)
```

### Intake Statuses

| Status | Who Sets | Meaning |
|--------|----------|---------|
| `draft` | Howard | Intake in progress |
| `needs_research` | Howard | Ready for Hank |
| `ready` | Howard OR Hank | Ready for Saul |
| `promoted` | Saul | Plan created |
| `discarded` | User/Howard | Not proceeding |
