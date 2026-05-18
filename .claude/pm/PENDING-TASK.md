# Pending Task — yogicapproach/events

Written: 2026-04-05 — always updated on main only
Last commit on main: see `git log --oneline -1`

---

## Active Work

### #63 Phase 2 — GitHub Actions deploy workflow

**Branch:** `feat/63-phase2-deploy-workflow`
**Started:** 2026-04-05

**Goal:** Create `.github/workflows/deploy.yml` — `workflow_dispatch` trigger, install → build → targeted sync `_site/` to `yogicapproach/yogicapproach.github.io`, write `last-deployed` git tag.

**Sub-tasks:**
- [x] Create `.github/workflows/deploy.yml` with workflow_dispatch trigger
- [x] Install → build step (npm ci + npm run build)
- [x] Pagefind included in npm run build — no separate step needed
- [x] Additive sync via rsync: push `_site/` contents to `yogicapproach.github.io`
- [x] Write `last-deployed` git tag on success
- [ ] Verify workflow runs manually via GH Actions UI (requires PAT secret set first)

**Key constraints:**
- PENDING-TASK.md stays on main only — never commit this file on the feature branch
- rsync --exclude='.git' ensures CNAME and other root files are never touched
- Phase 3 (GH Environment gate) is a follow-on

**Future decision (partial language coverage):**
- When Romanian is added for retreats but not events, a Cloudflare Worker must handle
  `/ro/events/...` → 301 → `/en/events/...`. The static 404.html JS redirect is
  insufficient (Google won't follow it). Language-detect stubs must never redirect
  Romanian browsers to `/ro/` for sections with no Romanian content.

---

## Next: #63 URL architecture: lang at root

**Agreed approach (2026-04-05):**
- Push built `_site/` from `events` repo → `yogicapproach.github.io` (targeted sync, not full overwrite)
- Eleventy permalinks restructured to `/en/events/...`, `/es/events/...`, `/ne/events/...`
- Deploy gate: GitHub Environments (`production`) + required reviewer (manual only) + `last-deployed` git tag
- Redirects: single Cloudflare Redirect Rule regex — `/events/2026-uruguay/(en|es|ne)/(.*)` → `/{lang}/events/2026-uruguay/{rest}` (true 301)
- Disable GitHub Pages on `events` repo after first successful deploy
- See [issue #63 comment](https://github.com/yogicapproach/events/issues/63#issuecomment-4126655229) for full 5-phase plan

---

## Next Major Tasks (in rough priority order)

| # | Title | Notes |
|---|-------|-------|
| **#63** | URL architecture: lang at root | Approach agreed — ready to implement |
| **#75** | PageSpeed Insights audit | Retry — daily API quota exhausted 2026-03-24 |
| **#68** | Translation QA — NE/ES | Content quality; needs scope decision |
| **#52** | OG image | Blocked on having a photo/asset from Uruguay talks |
| **#64** | A/B theme flag redesign | Needs UX design decision before #66 can proceed |
| **#9**  | npm → Bun | Research + migration |

---

## Open Issues

| # | Title |
|---|-------|
| #3 | Audio diarization research |
| #4 | Floating toolbar + Web Share API |
| #9 | npm → Bun |
| #15 | Voice AI Q&A (Cloudflare Workers) |
| #21 | Search bar in page header |
| #52 | OG image (blocked — needs photo asset) |
| #63 | URL architecture: lang at root (approach agreed — ready to implement) |
| #64 | A/B theme flag redesign |
| #66 | A/B theme flag PR (deferred until #64) |
| #68 | Translation QA |
| #75 | PageSpeed Insights |
| #70 | CI via GitHub Actions |

**Private repo:** `yogicapproach/yogicapproach-dev` — domain portfolio, cost analysis

---

## Resume Instructions

1. Open VS Code at `c:\Users\kaanchan\Projects\Yoga\yogicapproach\events`
2. PM files are now at `.claude/pm/` — not repo root
3. Next task: #63 — implement 5-phase plan (see issue comment link above)
4. PENDING-TASK.md is always on main — never edit on a feature branch
