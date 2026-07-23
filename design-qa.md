# Lighter Design QA

## Scope

- Reference source: `onboarding.html` and `today.html`
- Flutter target: iPhone, portrait, light theme
- Comparison viewport: 390 x 844 points
- Device verification: iPhone 17 Pro simulator, iOS 26.0 runtime

## Captured comparisons

| State | Reference | Flutter implementation | Combined comparison |
| --- | --- | --- | --- |
| Launch | `design_qa/reference-splash.png` | `design_qa/implementation-splash-final-normalized.png` | `design_qa/compare-splash-final.png` |
| Today / idle | `design_qa/reference-today-idle.png` | `design_qa/implementation-today-idle-final-normalized.png` | `design_qa/compare-today-idle-final.png` |
| Today / active | `design_qa/reference-today-active.png` | `design_qa/implementation-today-active.png` | inspected side by side during QA |

## Findings and fixes

1. The first Flutter launch screen placed the continue control at the bottom. It was regrouped with the logo, aligned to the full 390 x 844 canvas, and matched to the HTML button color, border, and spacing.
2. The first Today idle implementation used an oversized play control and shortened guidance. It now uses the HTML clock motif, reference copy, timeline labels, and a more compact vertical rhythm.
3. The HTML Today page contains a three-state segmented control used to preview prototype states. Flutter intentionally omits this developer control: idle, active, and completed states are selected from persisted session data.
4. The active timer was verified after terminating the app and inserting an already-running session. Flutter restored the state from UTC timestamps and displayed the remaining time without accumulated tick storage.

## Result

PASS for the implemented iPhone MVP states. No P1 or P2 visual defects remain in the captured launch and Today flows. The system status bar and live clock naturally differ from the static HTML device frame.
