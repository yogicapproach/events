# Pending Task — yogicapproach/events

Written: 2026-03-22 — always updated on main only
Last commit on main: b1541ae

---

## Active Work: Testing + Merging PRs One by One

**Order (easiest → hardest to verify):**
- [x] #60 standards/sitemap-robots — MERGED ✓ (sitemap at events root; root repo gets robots.txt + sitemap index)
- [x] #56 standards/og-meta-fixes — MERGED ✓ (og:type article on talk+synthesis; Yogaval → site.title)
- [x] #59 standards/hreflang-canonical — MERGED ✓ (canonical + hreflang EN/ES/NE/x-default on all pages)
- [x] #65 standards/json-ld — MERGED ✓ (Article JSON-LD with description, abstract, publisher, isPartOf)
- [ ] #62 design/lang-select-mobile — JS source + mobile viewport ← **CURRENTLY TESTING**
- [ ] #66 design/ab-theme-flag — ?theme=v2 URL behavior
- [ ] #57 design/devanagari-font — visual NE page check
- [ ] #58 design/touch-targets — visual audio player + PDF check
- [ ] #61 design/font-size-tokens — visual font/background check
- [ ] #67 test/regression-wave-1 — merge last after all others pass

**Protocol per PR:**
1. `git checkout <branch> && npm run build`
2. Claude verifies via curl/filesystem + flags any issues
3. User checks `http://localhost:8080/events/2026-uruguay/...`
4. Both confirm → `gh pr merge <n> --squash` → update checklist above on main

---

## Flags Noted During Testing

- **#60**: `robots.txt` domain root handled by `yogicapproach/yogicapproach.github.io`. Section sitemap correctly at `yogicapproach.com/events/sitemap.xml`. CI issue filed at root repo (#2). Root repo issue #1 closed.

---

## After All PRs Merged — Next Major Task

**Issue #63: URL Architecture — Move lang to root path**
- Current: `yogicapproach.com/events/2026-uruguay/en/...`
- Target: `yogicapproach.com/en/events/2026-uruguay/...` (lang always segment 1)
- Branch: `arch/lang-at-root` (to be created)
- Prerequisites: all current PRs merged and green on main

---

## Agent Permission Issue — To Resolve

Agents with `isolation: "worktree"` don't inherit Bash permissions.
Fix: add git/gh to `allowedTools` in `.claude/settings.json` — create GH issue before next agent wave.

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

---

## Resume Instructions

1. `cd c:\Users\kaanchan\Projects\Yoga\yogicapproach\events`
2. `gh pr list --state open` — see remaining open PRs
3. Check testing order above — tick off what's merged
4. `git checkout <branch> && npm run build` to test each
5. Do NOT merge #67 until all others are done
6. PENDING-TASK.md is always on main — never edit it on a feature branch
