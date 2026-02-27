# Plan: Portfolio Site Variants — Performance Simplification

**Created:** 2026-02-27
**Status:** approved
**Priority:** P2
**Intent:** REFACTOR / OPTIMIZE
**Kim Validation:** APPROVED (revision 2)

## Summary

Create 3 alternative versions of the portfolio site for performance comparison. Each variant progressively removes canvas overhead while preserving core identity (pixel avatar, hat-swapping, typewriter, easter eggs).

## Background

Current site has ~2200 lines with heavy canvas work causing laggy interactions:
- **Constellation lines:** O(n²) = 4005 distance checks per frame (240K/sec)
- **Mouse trail gradient:** `createLinearGradient()` every frame + double stroke
- **110+ particles:** 90 ambient + 20 orbital always active
- **Custom cursor:** DOM style updates every frame with JS lerp

## Deliverables

| File | Description | Est. Lines |
|------|-------------|------------|
| `index_v1.html` | Optimized canvas — surgical cuts | ~2150 |
| `index_v2.html` | No trails canvas — CSS background, avatar preserved | ~1750 |
| `index_v3.html` | Zero canvas — Static SVG avatar | ~1300 |

## Must Preserve (All Variants)

- [x] Pixel avatar with 7 hat overlays
- [x] Category auto-cycling with hat swap animation
- [x] Typewriter code window with syntax highlighting
- [x] Console easter egg
- [x] Konami code → Matrix mode
- [x] Avatar 5-click secret (V1/V2: particles, V3: message only)
- [x] Easter egg comments in code snippets
- [x] Tech tags clickable to switch categories
- [x] Status indicator (currently closed)

---

## Step 1: Create V1 — Optimized Canvas

**Goal:** Surgical removal of the two biggest performance killers.

### 1.1 Copy Base File
```bash
cp index.html index_v1.html
```

### 1.2 Remove Constellation Lines (Lines 2109-2125)

**DELETE this block:**
```javascript
// Constellation lines between nearby ambient particles
for (var i = 0; i < ambientParticles.length; i++) {
  for (var j = i + 1; j < ambientParticles.length; j++) {
    var dx = ambientParticles[i].x - ambientParticles[j].x;
    var dy = ambientParticles[i].y - ambientParticles[j].y;
    var distSq = dx * dx + dy * dy;
    if (distSq < CONSTELLATION_DIST * CONSTELLATION_DIST) {
      var dist = Math.sqrt(distSq);
      var alpha = (1 - dist / CONSTELLATION_DIST) * 0.06;
      ctx.beginPath();
      ctx.moveTo(ambientParticles[i].x, ambientParticles[i].y);
      ctx.lineTo(ambientParticles[j].x, ambientParticles[j].y);
      ctx.strokeStyle = 'rgba(100, 255, 218, ' + alpha + ')';
      ctx.lineWidth = 0.5;
      ctx.stroke();
    }
  }
}
```

Also remove the unused constant:
```javascript
var CONSTELLATION_DIST = 120;  // DELETE this line
```

### 1.3 Replace Mouse Trail Gradient with Solid Color (Lines 2143-2158)

**REPLACE this block:**
```javascript
var gradient = ctx.createLinearGradient(
  trailPoints[0].x, trailPoints[0].y,
  trailPoints[trailPoints.length - 1].x, trailPoints[trailPoints.length - 1].y
);
gradient.addColorStop(0, 'rgba(100, 255, 218, 0)');
gradient.addColorStop(0.5, 'rgba(100, 255, 218, 0.15)');
gradient.addColorStop(1, 'rgba(124, 92, 252, 0.2)');

ctx.strokeStyle = gradient;
ctx.lineWidth = 2;
ctx.lineCap = 'round';
ctx.stroke();

ctx.strokeStyle = 'rgba(100, 255, 218, 0.04)';
ctx.lineWidth = 12;
ctx.stroke();
```

**WITH:**
```javascript
ctx.strokeStyle = 'rgba(100, 255, 218, 0.2)';
ctx.lineWidth = 2;
ctx.lineCap = 'round';
ctx.stroke();
```

### 1.4 Reduce Ambient Particles (Line 848)

**CHANGE:**
```javascript
for (var i = 0; i < 90; i++) {
```

**TO:**
```javascript
for (var i = 0; i < 40; i++) {
```

### 1.5 Reduce Orbital Particles (Line 902)

**CHANGE:**
```javascript
for (var i = 0; i < 20; i++) {
```

**TO:**
```javascript
for (var i = 0; i < 5; i++) {
```

### 1.6 Update Title Tag
```html
<title>brolio.dev — V1 Optimized</title>
```

### Acceptance Criteria V1
- [ ] Constellation lines removed
- [ ] Mouse trail uses solid color (no gradient allocation)
- [ ] Ambient particles reduced to 40
- [ ] Orbital particles reduced to 5
- [ ] All easter eggs work (Konami, console, 5-click secret with particles)
- [ ] Avatar hat swaps work with particle animation
- [ ] Typewriter works
- [ ] Cursor feels snappy

---

## Step 2: Create V2 — No Trails Canvas

**Goal:** Remove the entire `#trails` canvas. Keep avatar canvas. Replace background with CSS.

### 2.1 Copy V1 as Base
```bash
cp index_v1.html index_v2.html
```

### 2.2 Remove Trails Canvas HTML

**DELETE:**
```html
<canvas id="trails"></canvas>
```

### 2.3 Remove Custom Cursor HTML

**DELETE:**
```html
<div class="custom-cursor" id="cursor"></div>
<div class="cursor-dot" id="cursorDot"></div>
```

### 2.4 Remove Custom Cursor CSS

**DELETE:**
- `.custom-cursor` block (lines 97-108)
- `.custom-cursor.clicking` block (lines 110-114)
- `.cursor-dot` block (lines 116-125)

**CHANGE in html, body rule:**
```css
cursor: none;  /* REMOVE this line */
```

### 2.5 Add CSS Background Animation

**ADD to CSS (after .noise styles, around line 470):**
```css
/* Ambient floating dots (CSS-only, no canvas) */
.ambient-dots {
  position: fixed;
  inset: 0;
  z-index: 1;
  pointer-events: none;
  overflow: hidden;
}

.ambient-dots::before,
.ambient-dots::after {
  content: '';
  position: absolute;
  width: 200%;
  height: 200%;
  background-image: 
    radial-gradient(1px 1px at 20% 30%, rgba(100, 255, 218, 0.15) 0%, transparent 100%),
    radial-gradient(1px 1px at 40% 70%, rgba(100, 255, 218, 0.1) 0%, transparent 100%),
    radial-gradient(1px 1px at 60% 20%, rgba(100, 255, 218, 0.12) 0%, transparent 100%),
    radial-gradient(1px 1px at 80% 50%, rgba(124, 92, 252, 0.1) 0%, transparent 100%),
    radial-gradient(1.5px 1.5px at 10% 60%, rgba(100, 255, 218, 0.08) 0%, transparent 100%),
    radial-gradient(1.5px 1.5px at 50% 90%, rgba(124, 92, 252, 0.08) 0%, transparent 100%),
    radial-gradient(1px 1px at 70% 80%, rgba(100, 255, 218, 0.1) 0%, transparent 100%),
    radial-gradient(1px 1px at 90% 10%, rgba(100, 255, 218, 0.12) 0%, transparent 100%);
  animation: floatDots 60s linear infinite;
}

.ambient-dots::after {
  animation-delay: -30s;
  opacity: 0.5;
}

@keyframes floatDots {
  0% { transform: translate(0, 0); }
  100% { transform: translate(-25%, -25%); }
}

/* Matrix Mode CSS (Konami code easter egg) */
body.matrix-mode {
  --accent: #00ff41;
  --glow: rgba(0, 255, 65, 0.08);
}

body.matrix-mode .tech-tag.active {
  border-color: rgba(0, 255, 65, 0.4);
  background: rgba(0, 255, 65, 0.08);
  box-shadow: 0 0 15px rgba(0, 255, 65, 0.15);
}

body.matrix-mode .category-label {
  color: #00ff41 !important;
}
```

### 2.6 Add Ambient Dots HTML

**ADD after `<div class="noise"></div>`:**
```html
<div class="ambient-dots"></div>
```

### 2.7 Remove All Trails Canvas JavaScript

**DELETE the following sections entirely:**

1. **Canvas Setup** (around line 588)
2. **State variables** (mouseX, mouseY, isTouch, particles, burstParticles, trailPoints, MAX_TRAIL)
3. **Custom Cursor variables** (cursor, cursorDot, cursorX, cursorY)
4. **TrailPoint class** (entire function)
5. **Particle class** (entire function)
6. **BurstParticle class** (entire function)
7. **Ring class** (entire function)
8. **Event listeners** (mousemove, touchmove, mousedown, mouseup, touchstart)
9. **AmbientParticle class** (entire function + initialization loop)
10. **OrbitParticle class** (entire function + initialization loop)
11. **Main animate() function** (entire function)
12. **The `animate();` call at the end**

### 2.8 Keep These JS Sections

- Console easter egg
- Konami code handler
- Matrix mode toggle function (simplified - see 2.9)
- Spotlight glow effect
- Avatar system (all of it - canvas, hats, particles)
- Category system
- Typewriter

### 2.9 Simplify Matrix Mode Toggle

**REPLACE the matrix mode particle burst (inside toggleMatrixMode function):**
```javascript
if (matrixMode) {
  for (var i = 0; i < 100; i++) {
    particles.push(new Particle(
      Math.random() * W,
      -10,
      { vx: 0, vy: 2 + Math.random() * 3, decay: 0.001, size: 2, color: 'rgba(0, 255, 65, ' }
    ));
  }
}
```

**WITH:**
```javascript
// Particle burst removed - V2 has no main canvas
// CSS handles the visual change via body.matrix-mode class
```

### 2.10 Update Title Tag
```html
<title>brolio.dev — V2 No Canvas Trails</title>
```

### Acceptance Criteria V2
- [ ] No `#trails` canvas element
- [ ] No custom cursor elements
- [ ] CSS ambient dots animate smoothly
- [ ] Avatar canvas still works with hat swap particles
- [ ] Typewriter works
- [ ] Konami code triggers Matrix mode (CSS color change only, no particles)
- [ ] Native cursor (instant response)
- [ ] Console easter egg works
- [ ] 5-click avatar secret works with particles (avatar canvas preserved)

---

## Step 3: Create V3 — Zero Canvas (Static SVG Avatar)

**Goal:** No canvas at all. Static SVG avatar with CSS hat transitions. Maximum minimalism.

**Kim's Note:** V3 uses static SVG (not CSS pixel grid) for simplicity. Easter egg particle bursts are deliberately removed - acceptable for minimalist variant.

### 3.1 Copy V2 as Base
```bash
cp index_v2.html index_v3.html
```

### 3.2 Remove Avatar Canvas HTML

**DELETE:**
```html
<canvas id="avatar-canvas" width="128" height="160"></canvas>
```

### 3.3 Generate Static SVG Avatar

**Crew Instruction:** Run this in browser console on the ORIGINAL index.html, then paste output into V3:

```javascript
// Run in console on original site to generate SVG
(function() {
  const BASE_CHAR = [
    [0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0],
    [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
    [0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
    [0,0,0,1,2,2,2,2,2,2,2,2,1,0,0,0],
    [0,0,1,2,2,2,2,2,2,2,2,2,2,1,0,0],
    [0,0,1,2,2,5,2,2,2,5,2,2,2,1,0,0],
    [0,0,0,2,2,2,2,2,2,2,2,2,2,0,0,0],
    [0,0,0,2,7,7,2,6,2,7,7,2,2,0,0,0],
    [0,0,0,3,3,3,3,3,3,3,3,3,3,0,0,0],
    [0,0,0,0,3,3,3,3,3,3,3,3,0,0,0,0],
    [0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0],
    [0,0,0,4,4,4,4,4,4,4,4,4,4,0,0,0],
    [0,0,4,4,4,4,4,4,4,4,4,4,4,4,0,0],
    [0,0,4,4,2,4,4,4,4,4,4,2,4,4,0,0],
    [0,0,0,0,2,4,4,4,4,4,4,2,0,0,0,0],
    [0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0]
  ];
  const BASE_COLORS = {
    1: '#2a2035', 2: '#d4a574', 3: '#3d2010', 4: '#1a1a2e',
    5: '#e8e6e3', 6: '#c0392b', 7: '#2a1508'
  };
  const PIXEL = 8;
  const OFFSET_Y = 32; // Hat space
  
  let svg = '<svg viewBox="0 0 128 160" class="avatar-svg" style="image-rendering:pixelated;width:128px;height:160px">';
  for (let y = 0; y < 16; y++) {
    for (let x = 0; x < 16; x++) {
      const val = BASE_CHAR[y][x];
      if (val === 0) continue;
      svg += `<rect x="${x * PIXEL}" y="${(y * PIXEL) + OFFSET_Y}" width="${PIXEL}" height="${PIXEL}" fill="${BASE_COLORS[val]}"/>`;
    }
  }
  svg += '</svg>';
  console.log(svg);
  return svg;
})();
```

### 3.4 Add Avatar Container HTML

**REPLACE the deleted canvas with:**
```html
<div id="avatar-container" class="avatar-wrapper">
  <!-- Paste the SVG output from step 3.3 here -->
  <svg viewBox="0 0 128 160" class="avatar-svg" style="image-rendering:pixelated;width:128px;height:160px">
    <!-- SVG rects from console output -->
  </svg>
  <div class="avatar-hat" id="hat-languages"></div>
  <div class="avatar-hat" id="hat-frontend"></div>
  <div class="avatar-hat" id="hat-database"></div>
  <div class="avatar-hat" id="hat-cloud"></div>
  <div class="avatar-hat" id="hat-devops"></div>
  <div class="avatar-hat" id="hat-ai"></div>
  <div class="avatar-hat" id="hat-api"></div>
</div>
```

### 3.5 Add Avatar CSS

**ADD to CSS:**
```css
/* Static Avatar System */
.avatar-wrapper {
  width: 128px;
  height: 160px;
  position: relative;
  animation: avatarBounce 3s ease-in-out infinite, fadeUp 0.8s ease forwards 0s;
  opacity: 0;
}

.avatar-svg {
  position: absolute;
  inset: 0;
}

.avatar-hat {
  position: absolute;
  inset: 0;
  width: 128px;
  height: 160px;
  opacity: 0;
  transition: opacity 0.2s ease;
  pointer-events: none;
}

.avatar-hat.active {
  opacity: 1;
}

/* Hat SVG backgrounds - generate these from original canvas or use inline SVG */
#hat-languages { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
#hat-frontend { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
#hat-database { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
#hat-cloud { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
#hat-devops { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
#hat-ai { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
#hat-api { background: url('data:image/svg+xml,...') center top / 128px 160px no-repeat; }
```

### 3.6 Generate Hat SVGs (Crew Task)

**Crew Instruction:** For each of the 7 hats, render on original canvas and export:

```javascript
// Run in console on original site for each category index 0-6
(function(catIndex) {
  const c = document.createElement('canvas');
  c.width = 128;
  c.height = 160;
  const ctx = c.getContext('2d');
  
  // Draw base character
  const BASE_CHAR = [/* paste array */];
  const BASE_COLORS = {/* paste object */};
  const PIXEL = 8;
  const OFFSET_Y = 32;
  
  for (let y = 0; y < 16; y++) {
    for (let x = 0; x < 16; x++) {
      const val = BASE_CHAR[y][x];
      if (val === 0) continue;
      ctx.fillStyle = BASE_COLORS[val];
      ctx.fillRect(x * PIXEL, (y * PIXEL) + OFFSET_Y, PIXEL, PIXEL);
    }
  }
  
  // Draw hat
  const HATS = [/* paste HATS array */];
  const CATEGORIES = [/* paste CATEGORIES array */];
  const hat = HATS[catIndex];
  const colors = CATEGORIES[catIndex].hatColors;
  for (const p of hat) {
    ctx.fillStyle = colors[p.c];
    ctx.fillRect(p.x * PIXEL, (p.y * PIXEL) + OFFSET_Y, PIXEL, PIXEL);
  }
  
  console.log(c.toDataURL('image/png'));
})(0); // Change 0 to 1-6 for other hats
```

Convert each data URL to CSS background in step 3.5.

### 3.7 Simplify Category Switching

**REPLACE switchCategory function with:**
```javascript
function switchCategory(newIndex) {
  if (newIndex === currentCategory) return;
  currentCategory = newIndex;
  
  // Swap hat via CSS class (no particles in V3)
  document.querySelectorAll('.avatar-hat').forEach(function(hat) {
    hat.classList.remove('active');
  });
  
  var catKey = CATEGORIES[newIndex].key;
  var activeHat = document.getElementById('hat-' + catKey);
  if (activeHat) activeHat.classList.add('active');
  
  // Update UI
  var cat = CATEGORIES[newIndex];
  updateActiveTags(cat.key);
  typeLabel(cat.label);
  
  if (cat.snippets) {
    var randIdx = Math.floor(Math.random() * cat.snippets.length);
    codeFilenameEl.textContent = cat.filenames[randIdx];
    typeCode(cat.snippets[randIdx]);
  }
}
```

### 3.8 Remove Avatar Canvas JS

**DELETE:**
- `avatarCanvas` and `avatarCtx` variables
- `PIXEL`, `HAT_EXTRA_ROWS`, `AVATAR_OFFSET_Y` constants
- `drawBaseCharacter()` function
- `drawHat()` function  
- `renderAvatar()` function
- `HatPixelParticle` class
- `hatParticles` array
- `animateAvatar()` function
- `startAvatarAnimation()` function
- `burstAtAvatar()` function
- Avatar click secret particle burst code

### 3.9 Simplify Avatar Click Secret

**REPLACE revealSecretHat with:**
```javascript
function revealSecretHat() {
  // Note: Particle burst removed - V3 has no canvas
  var msg = document.createElement('div');
  msg.textContent = '🎉 You found a secret!';
  msg.style.cssText = 'position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);font-size:1.5rem;color:var(--accent);z-index:9999;animation:fadeUp 1s ease forwards;pointer-events:none;font-family:JetBrains Mono,monospace;';
  document.body.appendChild(msg);
  setTimeout(function() { msg.remove(); }, 1500);
}
```

### 3.10 Update Initialization

**REPLACE initLivingAvatar with:**
```javascript
function initLivingAvatar() {
  // Show initial hat
  var catKey = CATEGORIES[0].key;
  var hat = document.getElementById('hat-' + catKey);
  if (hat) hat.classList.add('active');
  
  updateActiveTags(catKey);
  categoryLabelEl.textContent = CATEGORIES[0].label;
  
  var cat = CATEGORIES[0];
  var randIdx = Math.floor(Math.random() * cat.snippets.length);
  codeFilenameEl.textContent = cat.filenames[randIdx];
  
  var html = '';
  for (var p = 0; p < cat.snippets[randIdx].length; p++) {
    var text = cat.snippets[randIdx][p].text;
    var safe = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    html += '<span class="' + cat.snippets[randIdx][p].cls + '">' + safe + '</span>';
  }
  html += '<span class="cursor-blink"></span>';
  codeContentEl.innerHTML = html;
  
  resetAutoCycle();
}
```

### 3.11 Update Title Tag
```html
<title>brolio.dev — V3 Zero Canvas</title>
```

### Acceptance Criteria V3
- [ ] No canvas elements anywhere
- [ ] Static SVG avatar displays correctly
- [ ] Hat swap via CSS class transition (fade, no particles)
- [ ] Easter eggs work with reduced visual feedback:
  - [ ] Konami code → Matrix mode (CSS color change)
  - [ ] Console easter egg
  - [ ] 5-click secret → message only (no particles - acceptable)
- [ ] Typewriter works
- [ ] Instant interactions (no animation loops)
- [ ] File size significantly reduced (~1300 lines)

---

## Testing Checklist

### Performance Testing
- [ ] Open all three variants in tabs, switch between them
- [ ] Check CPU usage in browser dev tools (Performance tab)
- [ ] Test on mobile device
- [ ] Test in Safari (known canvas variance)

### Functionality Testing (All Variants)
- [ ] Avatar displays correctly
- [ ] Hat changes when category changes
- [ ] Category auto-cycles (10s interval)
- [ ] Clicking tech tag switches category
- [ ] Typewriter animates code
- [ ] Code has syntax highlighting
- [ ] Console shows easter egg
- [ ] Konami code works (↑↑↓↓←→←→BA)
- [ ] 5-click avatar secret works
- [ ] Matrix mode activates
- [ ] Status displays correctly
- [ ] Responsive on mobile

### Visual Comparison
- [ ] V1 feels faster than original
- [ ] V2 cursor is instant
- [ ] V3 is fastest of all
- [ ] All variants look "on brand"

---

## Execution Order

| Step | Agent | Parallel? | Depends On |
|------|-------|-----------|------------|
| V1 | Crew (Badger) | No | Original index.html |
| V2 | Crew (Skinny Pete) | No | V1 complete |
| V3 | Crew | No | V2 complete |

**Note:** Steps are sequential due to file dependencies (V2 builds on V1, V3 builds on V2).

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Hat SVG generation tedious | Console helper scripts provided |
| Safari canvas variance | V2/V3 eliminate canvas entirely |
| Easter eggs break | Explicit test checklist per variant |
| V3 feels "too minimal" | That's the point - user chooses |

---

**Plan Status:** ✅ APPROVED for execution
**Kim Validation:** Revision 2 - All gates PASS
