---
name: anti-ai-detection
description: Make AI-assisted writing sound human. Calibrated for brolio.dev voice.
---

# Anti-AI Detection for brolio.dev

## Quick Reference

- Human writing **varies**. AI writing is **uniform**.
- Your job: introduce controlled imperfection.
- Target voice: first-person, specific, slightly imperfect — like explaining to a friend at a bar.
- The existing brolio.dev articles ARE the calibration target. Don't over-correct.

## DON'Ts — AI Fingerprints to Eliminate

### Formal transitions
❌ "Furthermore, the board provides visibility..."
❌ "Moreover, this approach enables..."
❌ "In conclusion, the pattern is clear."
❌ "Additionally, tickets serve as..."
✅ "And the real win is what happens next: you stop losing context between sessions."

### Hedging language
❌ "It is worth noting that the approach has limitations."
❌ "One could argue that this represents a paradigm shift."
✅ "This isn't a perfect system. I want to be clear about that."

### Uniform paragraph length
❌ Every paragraph is 3-4 sentences, roughly the same size.
✅ Mix 1-sentence punch paragraphs with 5-6 sentence explorations.

### Perfect grammar throughout
❌ No fragments. No run-ons. Every sentence is complete and balanced.
✅ "Worth it." / "Meetings, not momentum." / "I learned this the hard way. Twice."

### Generic examples
❌ "a developer working on multiple projects"
✅ "me, last Tuesday, trying to remember where I'd left off on three different things"

### Over-organization
❌ H2 → H3 → bullet list → paragraph. Every section follows this pattern.
✅ Vary the internal structure. Some sections are all paragraphs. Some have a code block. Some are one bold sentence and a fragment.

### Listicle paragraphs
❌ "There are three key benefits. First, visibility improves. Second, prioritization becomes easier. Third, handoffs are smoother."
✅ "With folders, I had depth but no width. With a board, I open one surface and see everything."

## DOs — Human Markers to Inject

### Vary sentence length aggressively
Aim for a range from 2 words to 35+ words in the same paragraph.

Before: "The implementation uses a three-stage pipeline. Each stage processes the input and produces output. The stages are brainstorm, brief-to-ticket, and start."
After: "The mechanics were straightforward. I built a plugin pipeline with three commands: Brainstorm, Brief-to-Ticket, and Start. That's it."

### Conversational connectors
Starting sentences with "And," "But," "So," "Here's the thing:" is fine. Most people do it in conversation. Don't avoid them in writing.

Before: "However, tickets also provide a handoff surface."
After: "And the real win is what happens next: you stop losing context between sessions."

### Specific numbers, tools, dates
"20 years" not "many years." "Jira" not "a project management tool." "Three things in flight" not "several concurrent projects."

### First-person uncertainty
"I think," "maybe," "honestly," "I'm not sure about this yet," "Which is embarrassing, honestly."

### Parenthetical asides
Use em-dashes or parentheses to inject a secondary thought mid-sentence. Like this one.

### Strategic imperfections
Start sentences with "And" and "But." Use fragments. Allow the occasional run-on when excitement builds. Don't fix every comma splice.

### Admit failure modes
Every brolio.dev article has a "When It Breaks" section or equivalent. If you're presenting a solution, you must also present where it fails.

### Close with invitation, not conclusion
❌ "I'm not going back to folders."
✅ "Your version of this probably looks different. I'd genuinely like to compare notes."

## Tone Calibration: brolio.dev Voice

The published articles on brolio.dev already have a strong, consistent voice. When writing new content:

1. **Read the existing articles first.** They are the style guide.
2. **Match their register.** Technical but not formal. Personal but not diary. Confident but willing to be wrong.
3. **Match their rhythm.** Short declarative sentences mixed with longer explanatory ones. Paragraph breaks for emphasis.
4. **Match their honesty.** Admit limitations. Show real artifacts. Use actual tool names, not placeholders.

**Before finalizing, read your draft aloud and compare rhythm against the existing brolio.dev articles.** If it sounds like a different author wrote it, recalibrate. The voice should feel like the same person wrote everything on the site.

**Reference articles:**
- `writing/solo-dev-cognitive-bridge.html` — Voice gold standard

**Color palette reference** (for OG images and visual elements):
- `#0a0a0f` — Background
- `#12121a` — Surface
- `#e8e6e3` — Text
- `#6b6979` — Dim text
- `#64ffda` — Accent
- `#7c5cfc` — Secondary accent
- `#ff6b6b` — Warm accent (alerts/warnings)

## Self-Check

Before delivering any written content, verify:

- [ ] **Sentence length variety**: Short sentences land harder than long ones. Sprinkle them in. Let some run long when the detail matters.
- [ ] **Conversational connectors**: Starting with "And" or "But" is fine. Most people do it in conversation. Are yours showing up naturally?
- [ ] **Read-aloud test**: Would this sound natural spoken, not read from a script?
- [ ] **Specificity**: Are there real numbers, tool names, and dates — not generics?
- [ ] **Uncertainty signal**: Somewhere in here, is there an honest "I'm not sure" or "this doesn't always work"?
- [ ] **Closing check**: Does the ending feel like a conversation, not a conclusion?
- [ ] **No formal transitions**: Avoid formal transitions — they are the strongest AI fingerprint. Search for "Furthermore," "Moreover," "Additionally," "In conclusion" and eliminate any matches.
- [ ] **Paragraph variety**: Not all paragraphs are 3-4 sentences. Some are 1. Some are 6.
- [ ] **Primary source**: Would a concrete artifact (code block, spec output, real data) make this piece more grounded?
- [ ] **Section titles**: Do they have personality? (Not just descriptive — evocative or surprising.)
