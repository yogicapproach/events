# Pending Task — yogicapproach/events

Written: 2026-03-23 — always updated on main only
Last commit on main: 432d932

---

## Completed This Session ✓

- [x] **Google Search Console** — Domain property verified 2026-03-23
  - `https://yogicapproach.com/events/sitemap.xml` → Success, 27 URLs
  - `https://yogicapproach.com/sitemap.xml` → Success (sitemap index, 0 pages — expected)
  - Root sitemap namespace bug fixed (`https://` → `http://` in sitemapindex xmlns)
- [x] **PR Merge Wave** — All PRs merged; #66 deferred (UX redesign)
- [x] **Private dev repo** — `yogicapproach/yogicapproach-dev` created (private)
  - Issue #1: Domain portfolio / Cloudflare registrar migration research

---

## No Active Work

No branch in progress. Ready to start next task.

---

## Next Major Tasks (in rough priority order)

| # | Title | Notes |
|---|-------|-------|
| **#63** | URL architecture: lang at root `/en/events/...` | Prerequisites satisfied — ready to start |
| **#70** | CI via GitHub Actions | Run test suite on every push to main |
| **#75** | PageSpeed Insights audit | API-scriptable; feeds into #54/#55 |
| **#68** | Translation QA — NE/ES AI peer review | Content quality |
| **#69** | Dark mode | prefers-color-scheme + manual toggle |
| **#66** | A/B theme flag (deferred) | Needs UX redesign first (#64) |

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
| #64 | A/B theme flag redesign (live toggle) |
| #66 | A/B theme flag PR (deferred) |
| #68 | Translation QA — NE/ES AI peer review + native speaker |
| #69 | Dark mode support |
| #70 | CI via GitHub Actions |
| #73 | Cloudflare DNS/CDN migration for yogicapproach.com |
| #74 | Domain registration migration to Cloudflare Registrar |
| #75 | PageSpeed Insights audit |

---

## Resume Instructions

1. `cd c:\Users\kaanchan\Projects\Yoga\yogicapproach\events`
2. `gh pr list --state open` — see remaining open PRs
3. PENDING-TASK.md is always on main — never edit it on a feature branch
