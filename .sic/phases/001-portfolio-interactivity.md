# Plan: Portfolio Interactivity & Easter Eggs

**Phase:** 001
**Status:** complete
**Created:** 2026-02-26
**Intake:** 2026-02-26-portfolio-interactivity

---

## Summary

Add 6 interactive features to brolio.dev that enhance the cyberpunk aesthetic without breaking the minimalist vibe:
1. **Console Easter Egg** — Hidden message for curious devs
2. **Konami Code** — Classic ↑↑↓↓←→←→BA triggers matrix mode
3. **Hover Spotlight Glow** — Radial gradient follows cursor on code window
4. **Triple-Click Avatar Secret** — 5 clicks reveals special hat
5. **Code Comment Humor** — Witty comments in typewriter snippets
6. **Natural Typewriter** — Random timing + occasional typos for human feel

**Total Lines:** ~90 new lines
**Risk Level:** Low
**Mobile Support:** Full (with touch alternatives)

---

## Option A: Minimal
**Description:** Quick win with minimal code. Console easter egg + code humor only.

**Files:**

| File | Changes | Lines |
|------|---------|-------|
| index.html | Console.log messages | ~5 |
| index.html | Update CATEGORIES snippets | ~0 |

**Trade-offs:**

| Pros | Cons |
|------|------|
| Zero risk | Feels incomplete |
| Instant gratification | Missing the "wow" factor |
| No new dependencies | Limited interactivity |

**Complexity:** Trivial

---

## Option B: Balanced (SELECTED)
**Description:** All 5 research-recommended features. Polished, proportional investment.

**Files:**

| File | Changes | Lines |
|------|---------|-------|
| index.html | Console easter egg (script start) | ~8 |
| index.html | Konami code listener | ~30 |
| index.html | Spotlight CSS + JS | ~20 |
| index.html | Avatar click counter | ~12 |
| index.html | Code snippet humor | ~0 (content only) |

**Trade-offs:**

| Pros | Cons |
|------|------|
| Addresses all 3 goals (easter eggs, reactive, humor) | More testing needed |
| Memorable user experience | Mobile touch alternative for Konami |
| Cohesive with existing aesthetic | |
| Under 100 lines total | |

**Complexity:** Medium

---

## Option C: Full Experience
**Description:** All 5 features + extra reactive UI (3D tilt, magnetic buttons).

**Files:**

| File | Changes | Lines |
|------|---------|-------|
| index.html | All Option B features | ~65 |
| index.html | 3D card tilt on avatar | ~20 |
| index.html | Magnetic button effect on links | ~20 |
| index.html | Additional CSS for new effects | ~15 |

**Trade-offs:**

| Pros | Cons |
|------|------|
| Maximum "wow" factor | Approaching 120 lines |
| Most memorable experience | More complexity = more bugs |
| Showcases full creative potential | May feel "busy" |

**Complexity:** High

---

## Recommendation

**Option B (Balanced)** selected because:
- Covers all 3 user goals: hidden easter eggs, reactive elements, humor
- Stays well under the 100-200 line constraint
- Each feature is polished and purposeful
- Mobile-friendly with touch alternatives
- Research-backed implementation patterns

---

## Implementation Steps

### Step 1: Console Easter Egg
**File:** `index.html`
**Location:** Line ~489 (start of `<script>`)
**Changes:** Add console.log messages immediately after script tag opens

```javascript
// ──── Console Easter Egg ────
console.log('%c🚀 brolio.dev', 'font-size: 24px; font-weight: bold; color: #64ffda;');
console.log('%cBuilt with caffeine and questionable life choices', 'font-size: 12px; color: #7c5cfc;');
console.log('%c━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', 'color: #6b6979;');
console.log('%c→ Looking for the source? Check the Network tab', 'font-size: 11px; color: #6b6979;');
console.log('%c→ Open to opportunities? You bet.', 'font-size: 11px; color: #6b6979;');
console.log('%c→ Try the Konami code if you\'re feeling adventurous ↑↑↓↓←→←→BA', 'font-size: 11px; color: #64ffda;');
```

**Acceptance Criteria:**
- [ ] Console shows styled message when DevTools opens
- [ ] Konami code hint is visible
- [ ] Uses site color palette (#64ffda, #7c5cfc, #6b6979)

**Estimated diff:** +7 lines

---

### Step 2: Konami Code Easter Egg
**File:** `index.html`
**Location:** After existing event listeners (~line 660)
**Changes:** Add keydown listener for Konami sequence

```javascript
// ──── Konami Code Easter Egg ────
var konamiCode = ['ArrowUp','ArrowUp','ArrowDown','ArrowDown','ArrowLeft','ArrowRight','ArrowLeft','ArrowRight','KeyB','KeyA'];
var konamiIndex = 0;
var matrixMode = false;

document.addEventListener('keydown', function(e) {
  konamiIndex = e.code === konamiCode[konamiIndex] ? konamiIndex + 1 : 0;
  if (konamiIndex === konamiCode.length) {
    konamiIndex = 0;
    toggleMatrixMode();
  }
});

function toggleMatrixMode() {
  matrixMode = !matrixMode;
  document.body.classList.toggle('matrix-mode', matrixMode);
  
  if (matrixMode) {
    // Create matrix rain particles
    for (var i = 0; i < 50; i++) {
      particles.push(new Particle(
        Math.random() * W,
        -10,
        { vx: 0, vy: 2 + Math.random() * 3, decay: 0.003, size: 2, color: 'rgba(0, 255, 65, ' }
      ));
    }
  }
}
```

**CSS Addition (in `<style>` section):**
```css
/* Matrix Mode */
body.matrix-mode {
  --accent: #00ff41;
  --glow: rgba(0, 255, 65, 0.08);
}
body.matrix-mode .custom-cursor {
  border-color: #00ff41;
}
body.matrix-mode .cursor-dot {
  background: #00ff41;
}
```

**Mobile Alternative:**
- 5 rapid taps in top-left corner triggers same effect
- Add invisible touch zone for touch devices

**Acceptance Criteria:**
- [ ] ↑↑↓↓←→←→BA triggers matrix mode
- [ ] Matrix mode changes accent color to green (#00ff41)
- [ ] Matrix rain particles fall from top
- [ ] Second Konami code exits matrix mode
- [ ] Mobile: 5-tap corner triggers effect

**Estimated diff:** +30 lines (JS) + ~10 lines (CSS)

---

### Step 3: Hover Spotlight Glow
**File:** `index.html`
**Location:** CSS section + after event listeners
**Changes:** Add spotlight effect to code window

**CSS Addition:**
```css
/* Spotlight Glow Effect */
.spotlight-glow {
  --spotlight-x: 50%;
  --spotlight-y: 50%;
  position: relative;
  overflow: hidden;
}
.spotlight-glow::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(
    400px circle at var(--spotlight-x) var(--spotlight-y),
    rgba(100, 255, 218, 0.08),
    transparent 50%
  );
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.4s ease;
  z-index: 0;
}
.spotlight-glow:hover::before {
  opacity: 1;
}
.spotlight-glow > * {
  position: relative;
  z-index: 1;
}

/* Mobile fallback */
@media (hover: none) {
  .spotlight-glow:active::before {
    opacity: 1;
  }
}
```

**JS Addition:**
```javascript
// ──── Spotlight Glow Effect ────
var spotlightElements = document.querySelectorAll('.spotlight-glow');
spotlightElements.forEach(function(el) {
  el.addEventListener('mousemove', function(e) {
    var rect = el.getBoundingClientRect();
    el.style.setProperty('--spotlight-x', (e.clientX - rect.left) + 'px');
    el.style.setProperty('--spotlight-y', (e.clientY - rect.top) + 'px');
  });
});
```

**HTML Change:** Add `spotlight-glow` class to `.code-window` element (line ~472)

**Acceptance Criteria:**
- [ ] Code window shows radial glow following cursor
- [ ] Glow uses accent color (#64ffda)
- [ ] Smooth fade in/out on hover
- [ ] Mobile: tap activates glow briefly

**Estimated diff:** +25 lines (CSS) + ~8 lines (JS)

---

### Step 4: Triple-Click Avatar Secret
**File:** `index.html`
**Location:** After avatar rendering code
**Changes:** Add click counter to avatar that reveals secret hat

```javascript
// ──── Avatar Click Secret ────
var avatarClickCount = 0;
var avatarClickTimer = null;
var secretHatRevealed = false;

// Add this to existing avatar canvas click handler or create new one
avatarCanvas.addEventListener('click', function() {
  avatarClickCount++;
  clearTimeout(avatarClickTimer);
  avatarClickTimer = setTimeout(function() {
    avatarClickCount = 0;
  }, 600);
  
  if (avatarClickCount >= 5 && !secretHatRevealed) {
    avatarClickCount = 0;
    secretHatRevealed = true;
    revealSecretHat();
  }
});

function revealSecretHat() {
  // Add a special "party" hat to HATS array temporarily
  // Or trigger confetti burst from avatar
  for (var i = 0; i < 30; i++) {
    burstParticles.push(new Particle(
      avatarCanvas.offsetLeft + 64,
      avatarCanvas.offsetTop + 40,
      { 
        vx: (Math.random() - 0.5) * 8, 
        vy: -Math.random() * 6 - 2, 
        decay: 0.015, 
        gravity: 0.15,
        size: 3 + Math.random() * 3,
        color: ['rgba(100, 255, 218, ', 'rgba(124, 92, 252, ', 'rgba(255, 107, 107, '][Math.floor(Math.random() * 3)]
      }
    ));
  }
  
  // Show brief message
  var msg = document.createElement('div');
  msg.textContent = '🎉 You found a secret!';
  msg.style.cssText = 'position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);font-size:1.5rem;color:var(--accent);z-index:9999;animation:fadeUp 1s ease forwards;pointer-events:none;';
  document.body.appendChild(msg);
  setTimeout(function() { msg.remove(); }, 1500);
}
```

**Acceptance Criteria:**
- [ ] 5 rapid clicks on avatar triggers secret
- [ ] Confetti burst emanates from avatar
- [ ] "You found a secret!" message appears briefly
- [ ] Works on mobile (touch)
- [ ] Only triggers once per session

**Estimated diff:** +30 lines

---

### Step 5: Code Comment Humor
**File:** `index.html`
**Location:** CATEGORIES array (line ~763)
**Changes:** Update code snippets with witty comments

**Changes per category:**

**Languages (brolio.ts):**
```javascript
// Change line 769-790
snippet: [
  { text: '// who dis? 🤔\n', cls: 'cm' },
  { text: 'const ', cls: 'kw' },
  { text: 'dev', cls: 'fn' },
  { text: ' = {\n', cls: 'punc' },
  { text: '  name', cls: 'prop' },
  { text: ': ', cls: 'punc' },
  { text: '"Mariano"', cls: 'str' },
  { text: ',\n', cls: 'punc' },
  { text: '  role', cls: 'prop' },
  { text: ': ', cls: 'punc' },
  { text: '"full-stack engineer"', cls: 'str' },
  { text: ',\n', cls: 'punc' },
  { text: '  coffee', cls: 'prop' },
  { text: ': ', cls: 'punc' },
  { text: 'Infinity', cls: 'kw' },
  { text: ',  // the real fuel\n', cls: 'cm' },
  { text: '  available', cls: 'prop' },
  { text: ': ', cls: 'punc' },
  { text: 'false', cls: 'kw' },
  { text: '\n};', cls: 'punc' }
]
```

**Frontend (App.tsx):** Add comment `// pixel perfect, they said`
**Database (schema.sql):** Add comment `-- no SQL injection here, I promise`
**Cloud (infra.yml):** Add comment `# TODO: world domination`
**DevOps (Dockerfile):** Add comment `# it works on my machine`

**Acceptance Criteria:**
- [ ] Each category has at least one witty comment
- [ ] Comments feel natural, not forced
- [ ] Humor is appropriate for developer audience
- [ ] Doesn't break typewriter animation

**Estimated diff:** ~0 new lines (content replacement only)

---

## Dependencies

- Step 2 (Konami) is independent
- Step 3 (Spotlight) is independent
- Step 4 (Avatar Secret) is independent
- Step 5 (Code Humor) is independent
- Step 1 (Console) should be first (sets tone)

**All steps can be parallelized.**

---

## Risks

| Risk | Mitigation |
|------|------------|
| Matrix mode conflicts with particle system | Use existing particle array, just change color |
| Spotlight glow impacts performance | CSS-only with GPU-accelerated transforms |
| Konami code doesn't work on mobile | Add 5-tap corner alternative |
| Code humor feels dated | Keep references timeless (coffee, bugs, etc.) |

---

## Testing Checklist

After implementation, verify:

- [ ] Console messages appear in DevTools
- [ ] Konami code triggers matrix mode (desktop)
- [ ] 5-tap corner triggers matrix mode (mobile)
- [ ] Spotlight glow follows cursor on code window
- [ ] Spotlight works on mobile tap
- [ ] 5-click avatar triggers confetti
- [ ] Secret message appears and fades
- [ ] Code snippets display with humor
- [ ] No console errors
- [ ] No performance degradation
- [ ] All existing features still work

---

## Rollback Plan

If issues arise:
1. Remove new code block (lines marked with `// ──── Console Easter Egg ────` comments)
2. Remove `spotlight-glow` class from HTML
3. Remove CSS block for `.spotlight-glow`
4. Revert CATEGORIES snippet changes

All changes are additive and isolated — removal is straightforward.

---

### Step 6: Typewriter Natural Effect
**File:** `index.html`
**Location:** `typeCode()` function (~line 1300)
**Changes:** Replace fixed `setInterval` with random timing + occasional typos

**Current Implementation (line 1315):**
```javascript
codeTypeTimer = setInterval(function() {
  // ... fixed 18ms interval
}, 18);
```

**New Implementation:**
```javascript
// ──── Typewriter with Natural Timing ────
function typeCode(snippetParts) {
  if (codeTypeTimer) {
    clearInterval(codeTypeTimer);
    codeTypeTimer = null;
  }

  var segments = [];
  for (var p = 0; p < snippetParts.length; p++) {
    var part = snippetParts[p];
    for (var c = 0; c < part.text.length; c++) {
      segments.push({ char: part.text[c], cls: part.cls });
    }
  }

  var built = '';
  var segIndex = 0;
  var currentSpanCls = null;
  var typoMode = false;
  var typoChar = '';

  codeContentEl.innerHTML = '<span class="cursor-blink"></span>';

  function typeNext() {
    if (segIndex >= segments.length) {
      codeTypeTimer = null;
      codeContentEl.innerHTML = built + '<span class="cursor-blink"></span>';
      return;
    }

    var seg = segments[segIndex];
    var ch = seg.char;
    var delay = 12 + Math.random() * 33; // 12-45ms random delay

    // Escape HTML chars
    var chDisplay = ch;
    if (ch === '<') chDisplay = '&lt;';
    else if (ch === '>') chDisplay = '&gt;';
    else if (ch === '&') chDisplay = '&amp;';

    // Handle typo mode (backspacing)
    if (typoMode) {
      // Remove last char, then continue
      built = built.slice(0, -1);
      typoMode = false;
      codeContentEl.innerHTML = built + (currentSpanCls !== null ? '</span>' : '') + '<span class="cursor-blink"></span>';
      codeTypeTimer = setTimeout(typeNext, 80 + Math.random() * 60); // Pause before correcting
      return;
    }

    // Random chance of typo (5% chance, not on whitespace or syntax chars)
    var isTypableChar = /[a-zA-Z0-9]/.test(ch);
    if (isTypableChar && Math.random() < 0.05) {
      // Insert wrong character
      var typoPool = 'abcdefghijklmnopqrstuvwxyz';
      typoChar = typoPool[Math.floor(Math.random() * typoPool.length)];
      if (seg.cls !== currentSpanCls) {
        if (currentSpanCls !== null) built += '</span>';
        built += '<span class="' + seg.cls + '">';
        currentSpanCls = seg.cls;
      }
      built += typoChar;
      codeContentEl.innerHTML = built + (currentSpanCls !== null ? '</span>' : '') + '<span class="cursor-blink"></span>';
      typoMode = true;
      codeTypeTimer = setTimeout(typeNext, 150 + Math.random() * 100); // Longer pause to "notice" typo
      return;
    }

    // Normal typing
    if (seg.cls !== currentSpanCls) {
      if (currentSpanCls !== null) built += '</span>';
      built += '<span class="' + seg.cls + '">';
      currentSpanCls = seg.cls;
    }
    built += chDisplay;

    segIndex++;
    codeContentEl.innerHTML = built + (currentSpanCls !== null ? '</span>' : '') + '<span class="cursor-blink"></span>';
    
    var codeBody = codeContentEl.closest('.code-body');
    codeBody.scrollTop = codeBody.scrollHeight;

    // Schedule next character with random delay
    codeTypeTimer = setTimeout(typeNext, delay);
  }

  typeNext();
}
```

**Key Changes:**
1. Replace `setInterval(18)` with `setTimeout` + random delay (12-45ms)
2. 5% chance of typo on alphanumeric characters
3. Typo sequence: wrong char → 150-250ms pause → backspace → 80-140ms pause → correct char
4. Whitespace and syntax chars (`{`, `}`, `<`, etc.) never typo

**Acceptance Criteria:**
- [ ] Typing speed varies naturally (12-45ms between chars)
- [ ] Occasional typos appear on letters/numbers (~5% chance)
- [ ] Typos are corrected with realistic pause + backspace
- [ ] No typos on whitespace, brackets, or syntax
- [ ] Code still displays correctly after completion
- [ ] No performance impact

**Estimated diff:** ~25 lines (replaces existing typeCode function)

