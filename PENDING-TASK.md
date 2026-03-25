# Pending Task — yogicapproach/events

Written: 2026-03-25 — always updated on main only
Last commit on main: 59c6a01

---

## Active Work

**#63 — URL architecture: lang at root**
Updating issue with agreed approach + implementation plan.

**Agreed approach:**
- Push built `_site/` from `events` repo → `yogicapproach.github.io` (targeted sync, not full overwrite)
- Eleventy permalinks restructured to `/en/events/...`, `/es/events/...`, `/ne/events/...`
- Deploy gate: GitHub Environments (`production`) + required reviewer (manual only) + `last-deployed` git tag
- Redirects: single Cloudflare Redirect Rule regex covering all old `/events/2026-uruguay/(en|es|ne)/` URLs → true 301
- Disable GitHub Pages on `events` repo after first successful deploy

---

## Next: #75 PageSpeed Insights audit (quota reset — retry today)

---

## Next Major Tasks (in rough priority order)

| # | Title | Notes |
|---|-------|-------|
| **#75** | PageSpeed Insights audit | Retry today — daily API quota exhausted 2026-03-24 |
| **#63** | URL architecture: lang at root | Cloudflare now live (#73 ✓) — URL rewriting can proceed |
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
| #63 | URL architecture: lang at root (Cloudflare live — unblocked) |
| #64 | A/B theme flag redesign |
| #66 | A/B theme flag PR (deferred until #64) |
| #68 | Translation QA |
| #75 | PageSpeed Insights (retry tomorrow) |

**Private repo:** `yogicapproach/yogicapproach-dev` — domain portfolio, cost analysis

---

## Resume Instructions

1. Open VS Code at `c:\Users\kaanchan\Projects\Yoga\yogicapproach\events`
2. Start with #75 PageSpeed Insights audit (quota reset today)
3. PENDING-TASK.md is always on main — never edit on a feature branch
