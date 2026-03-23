# Pending Task — yogicapproach/events

Written: 2026-03-22 — always updated on main only
Last commit on main: 55a347f

---

## Follow-up Needed

- [ ] **Google Search Console** — TXT record added to NameSilo 2026-03-23. Once verified: submit sitemap `https://yogicapproach.com/events/sitemap.xml`. Tracked in [#73](https://github.com/yogicapproach/events/issues/73).

---

## PR Merge Wave — COMPLETE ✓

- [x] #60 standards/sitemap-robots — MERGED ✓
- [x] #56 standards/og-meta-fixes — MERGED ✓
- [x] #59 standards/hreflang-canonical — MERGED ✓
- [x] #65 standards/json-ld — MERGED ✓
- [x] #62 design/lang-select-mobile — MERGED ✓
- [ ] #66 design/ab-theme-flag — DEFERRED (UX redesign: live A/B toggle; revisit after #71)
- [x] #57 design/devanagari-font — MERGED ✓
- [x] #58 design/touch-targets — MERGED ✓
- [x] #61 design/font-size-tokens — MERGED ✓
- [x] #67 test/regression-wave-1 — MERGED ✓

---

## Active Work

**#71 design/audio-player-layout** — audio player full-width below cover art
- Branch: `design/audio-player-layout` (built, awaiting user visual confirm)
- Files: `docs/events/shared.js` (audio out of `.resource-body`), `docs/events/shared.css` (`flex-wrap`, `flex: 0 0 100%`)

---

## Flags Noted During Testing

- **#60**: `robots.txt` domain root handled by `yogicapproach/yogicapproach.github.io`. Section sitemap correctly at `yogicapproach.com/events/sitemap.xml`. CI issue filed at root repo (#2). Root repo issue #1 closed.

---

## Next Major Tasks

**Issue #63: URL Architecture — Move lang to root path**
- Current: `yogicapproach.com/events/2026-uruguay/en/...`
- Target: `yogicapproach.com/en/events/2026-uruguay/...` (lang always segment 1)
- Branch: `arch/lang-at-root` (to be created)
- Prerequisites: all current PRs merged and green on main ← satisfied

---

## Other Open Issues

| # | Title |
|---|-------|
| #3 | Audio diarization research |
| #4 | Floating toolbar + Web Share API |
| #5 | Site audit (Eleventy-era) |
| #7 | Regression test checklist |
| #9 | npm → Bun |
| #10 | Auto-approve read-only Claude Code ops |
| #15 | Voice AI Q&A (Cloudflare Workers) |
| #21 | Search bar in page header |
| #52 | Choose proper site-wide OG image |
| #54 | Design review (parent) |
| #55 | Deep-dive: mobile UX, accessibility, web standards, A/B |
| #63 | URL architecture: lang at root |
| #64 | A/B theme flag redesign (live toggle) |
| #66 | A/B theme flag PR (deferred) |
| #68 | Translation QA — NE/ES AI peer review + native speaker |
| #69 | Dark mode support |
| #70 | CI via GitHub Actions |
| #71 | Audio player layout: full-width below cover art |

---

## Resume Instructions

1. `cd c:\Users\kaanchan\Projects\Yoga\yogicapproach\events`
2. `gh pr list --state open` — see remaining open PRs
3. PENDING-TASK.md is always on main — never edit it on a feature branch
