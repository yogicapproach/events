# Session Progress — yogicapproach/events

Site: https://yogicapproach.com/events/2026-uruguay/
Repo: https://github.com/yogicapproach/events

---

## Session: 2026-03-22 — PR Merge Wave: Standards + Lang Toggle

**Focus:** Test and merge PRs in order (#60 → #56 → #59 → #65 → #62); supplement test suite per PR.

**Completed:**
- **#60 standards/sitemap-robots** — MERGED: sitemap.xml moved to events root (`/sitemap.xml`); robots.txt + sitemap index created in yogicapproach/yogicapproach.github.io root repo; CI issue filed there (#2)
- **#56 standards/og-meta-fixes** — MERGED: og:type `article` on all talk + synthesis pages; all "Yogaval 2026" hardcoded strings replaced with `{{ site.title }}`; dead `cdn.jsdelivr.net` preconnect and `marked.js` CDN script removed from base.njk
- **#59 standards/hreflang-canonical** — MERGED: canonical + hreflang EN/ES/NE/x-default on all lang pages
- **#65 standards/json-ld** — MERGED: Article JSON-LD with `description_en` + `abstract_en` drafted from transcripts for all 5 talks; `folderToIsoDate` Eleventy filter added; `publisher`, `isPartOf`, `datePublished` fields; synthesis pages also get Article JSON-LD
- **#62 design/lang-select-mobile** — MERGED: 4-stage progressive lang toggle (full → compact → abbreviated → select); abbreviated labels Eng./Esp./नेप. + Orig./IA Trad./AI अनु. with period; localized "Select language:" label in select; dead `marked.use()` block removed from shared.js; `docs.google.com` preconnect removed
- Test suite updated for each PR: §33 (dead preconnects absent), §37 (compression spans), browser-tests B10 (420px abbreviated / 350px select)
- PENDING-TASK.md protocol formalized in global CLAUDE.md memory

**PRs merged:** #60, #56, #59, #65, #62
**Issues closed:** (inline with PRs above)
**Bugs caught during testing:**
- Squash merge captured old remote branch (not local fix) — fix: always push before merge
- `{{ item.isoDate }}` inaccessible from Nunjucks block scope in paginated templates — fixed via `folderToIsoDate` filter
- `og_type` frontmatter override not working in content-injected layouts — fixed by reading variable in base.njk block
- Branch regressions on merge (missing earlier fixes) — fixed by `git merge main` before each PR merge

**Remaining PRs:** #66, #57, #58, #61, #67 (last)

---

## Session: 2026-03-22 — Design/Standards PR Wave + URL Architecture

**Focus:** Create 9 feature branches (PRs #56–#62) from issues #54/#55; establish URL architecture direction.

**Completed:**
- Deleted `TODO.txt`; rewrote `README.md` (correct URL, 5 talks, trilingual, Eleventy); rewrote `TODO.md` (new issue numbers)
- `site.json`: updated `baseUrl` → `https://yogicapproach.com/events`, `ogImage` → favicon, `title` → "Uruguay 2026 — Exploring the Koshas"
- Site title updated across `base.njk` and all 3 synthesis page frontmatter (`en/index.njk`, `es/index.njk`, `ne/index.njk`)
- Fixed `&mdash;` → `—` (em dash) in all 15 subtitle fields in `events.json` to prevent `&amp;mdash;` appearing in meta tags
- Bajomana Ma resource label fixed to "Intermission Kirtan" / "Kirtan del intermedio" / "मध्यान्तर कीर्तन"
- Design analysis written up as issues #54 (design review) and #55 (deep-dive: mobile, accessibility, standards, A/B)
- 5 PRs created from agents (rescued from worktree Bash permission failure): #56 og-meta-fixes, #57 devanagari-font, #58 touch-targets, #59 hreflang-canonical, #60 sitemap-robots
- PR #61: `design/font-size-tokens` — `:root` 18px, CSS custom properties, warm background `#faf8f5`
- PR #62: `design/lang-select-mobile` — JS-injected `<select>` via `shared.js`; works across all pages without template changes
- Issue #63: URL architecture analysis — lang at root (`/en/...`) confirmed as direction; full migration plan written up
- `PENDING-TASK.md` updated with full state for context recovery

**Issues opened:** #54, #55, #63
**PRs opened:** #56, #57, #58, #59, #60, #61, #62
**Branches created:** standards/og-meta-fixes, design/devanagari-font, design/touch-targets, standards/hreflang-canonical, standards/sitemap-robots, design/font-size-tokens, design/lang-select-mobile

**Still open (not yet built):**
- `standards/json-ld` — Article + WebSite JSON-LD structured data
- `design/ab-theme-flag` — `?theme=v2` CSS scoping mechanism

**Next session:** Test PRs #56–#62 locally → merge one at a time → then build json-ld + ab-theme-flag → then tackle #63 (lang-at-root migration)

---

## Session: 2026-03-19 — Audit, Analytics, Form Polish, Bug Fixes

**Focus:** Google Form pre-fill finalization, comprehensive site audit, analytics, content fixes, architecture planning.

**Completed:**
- Form pre-fill: em-dash format fixed to match talk selector labels exactly; Summary and Glossary added as program options with correct labels; all 7 options verified against live form
- GoatCounter analytics added via shared.js (#36) — all 8 pages tracked, dashboard at https://yogicapproach.goatcounter.com
- Shakti/She/Her capitalized as divine throughout Tantroktam EN transcript
- Om Shanti visarga (ः) added to final Shanti in all NE transcripts (Feb 9, Feb 10); trailing "Hi" removed from Feb 10 EN + ES
- Resource descriptions translated (ES/NE) in resources.json; shared.js renderer updated to use localized descriptions
- Events listing page (events/index.html): migrated from inline styles to shared.css; sticky footer added; site credit added to footer
- Separator dot color updated to link blue (#2a6496) in shared.css and events/index.html
- Resources language bug fixed: loadResources() now called inside loadTranscript() so resources re-render on language switch
- Comprehensive site audit run (8 pages, shared.css, shared.js) — report posted to #28
- Issues created: #26 (form/topbar work), #27 (floating toolbar + Web Share API), #28–#34 (audit sub-issues), #35 (framework research), #36 (GoatCounter ✅), #37 (regression checklist)
- Framework research completed (#35): Eleventy + Pagefind recommended; Option B (directory-based language routes) chosen; GitHub Actions from day one; report posted as issue comment
- Stable tag created: `v1.0-stable`
- Branch created: `audit-fixes` for upcoming #29–#34 work

**Issues opened:** #27, #28, #29, #30, #31, #32, #33, #34, #35, #37
**Issues closed:** #36 (GoatCounter)
**Tag:** v1.0-stable

---

## Session: 2026-03-18 (cont.) — UI Polish: Selector, Footer, Sub-labels, Resources (#20–#25)

**Focus:** Parallel agent work on four UI issues; synthesis La Paloma section; site-wide localization.

**Completed:**
- **#20** — Synthesis and Glossary moved to top of talk selector dropdown; Glossary confirmed at bottom (already correct in shared.js)
- **#22** — Language sub-labels added to all buttons: "Original" / "AI Traducido" / "AI अनुवादित"
- **#23** — Resources section text localized (EN/ES/NE): headings, Download, Listen On
- **#25** — Footer navigation localized and standardized across all 8 pages (EN/ES/NE)
- **#24** — La Paloma "Beyond the Map: Shakti, Bhakti" section added to synthesis-en.md
- Synthesis date label updated: "Last updated: March 18, 2026" (all 3 languages)
- Site credit "Made with" localized: ES "Hecho con", NE "YogicApproach बाट ... सँग बनाएको"
- Worktree agent workflow established: 4 agents ran in parallel on isolated branches, auto-merged
- Closed 17 completed issues in bulk

**Issues opened:** #25 (footer localization)
**Issues closed:** #2, #3, #5–#9, #11, #13–#23, #24, #25

**Workflow note:** Agents without Bash permission commit to worktrees but can't self-commit; edits fall back to main working directory if worktree is cleaned before manual commit. Grant git-only Bash allowlist via .claude/settings.json to fix.

---

## Session: 2026-03-18 — Add Nepali Language (नेपाली) + Devanagari Conversion (#21)

**Focus:** Add Nepali as third language across all event pages, synthesis, and glossary; convert all Sanskrit/Nepali-origin terms in NE transcripts from Roman to Devanagari.

**Completed:**
- Updated `events.json` with `title_ne`, `date_ne`, `subtitle_ne` for all 5 events
- Refactored `shared.js`: loadTalkSelector supports `ne`; page metadata from events.json cache
- Updated all 5 event `index.html` pages: added btn-ne, removed data-attrs
- Updated `docs/index.html` (synthesis) and `docs/glossary.html`: added btn-ne
- Created `transcript-ne.md` for all 5 talks
- Created `synthesis-ne.md` and `glossary-ne.md`
- Applied 4-round Python Devanagari conversion across 7 NE files
- Fixed: OM/Om/Aum → ॐ; `ॐ Shanti Shanti Shanti Hi` → `ॐ शान्तिः शान्तिः शान्तिः` (visarga)
- Identified: "Bajomana Ma" = "Bhaja Mana Ma" (भज मन माँ); applied in EN + NE Feb 18 transcript
- Identified: "Rikyapit" = Rikhiapeeth (ऋखिया पीठ); added to all 3 glossaries
- Bihar School of Yoga → बिहार योग विद्यालय in NE files
- SitaRam Darshan → सीताराम दर्शन; Sw. → स्वामी in Piriápolis NE
- Anatomy/body terms: Nepali-first (e.g., *स्थूल* (gross)); uncertain terms: English-first with ? (e.g., pubic bone (जघन हाड्?))
- Fixed `*प्राण and प्राणायाम*` → `*प्राण र प्राणायाम*` in glossary-ne.md
- Flipped `*gross* (स्थूल)` → `*स्थूल* (gross)` pattern; `*blissful*` → `*आनन्दमय*`
- Created GH issues #22 (language sub-labels) and #23 (resources text localization)

**Lessons learned — Devanagari conversion:**
- Protect reference-style link definitions (`[label]: url`) before any substitution, not just inline `[text](url)` links — missed this in round 2 and corrupted folder paths
- Compound phrases must be substituted BEFORE individual words (e.g., `Hari OM Tat Sat` → full Devanagari before `\bHari\b`)
- One comprehensive pass with full file audit is better than iterative rounds
- "Sw." abbreviation not caught by `\bSwami\b` pattern — check for abbreviated forms separately
- English anatomy/instructional terms: use Nepali-first when confident; English-first with ? only when uncertain

**Issues opened:** #22 (language sub-labels), #23 (resources text localization)
**Issues closed:** #21 (pending final test + commit)

---

## Session: 2026-03-08 — La Paloma Resources Section + Bilingual UI (#15, #16, #17)

**Focus:** Build resources section on La Paloma event page; inline audio playback; bilingual page header fixes; talk title rename.

**Completed:**
- **#16** — `resources.json` schema + dynamic resources section in index.html; audio cards (cover art thumbnail, HTML5 inline player, meta line with license/download); PDF section (full sheets visible, compact in collapsible `<details>`); ES before EN ordering; 3-letter lang badges
- **#17** — Exclusive audio playback (starting one track auto-pauses others); cover art modal overlay (click or Esc to dismiss)
- **#15** — Talk title renamed to "Tantric Tools: Tantroktam Devi Suktam for Self-Reflection" (EN) / "Herramientas Tántricas: Tantroktam Devi Suktam para la Autorreflexión" (ES) across events.json, transcripts, source-meta.md
- Bilingual page `<h1>` — switches correctly with language toggle using `data-title-en` / `data-title-es` attributes
- Bilingual "Select another talk" / "Ver otra charla" label
- Language toggle moved above resources section
- Section headings: "Audio Resources" + "Translation Reference" at same visual level
- Sannyasa Peeth reference recording listed as ashram recording (no download; "Listen on Satyam Yoga Prasad →" link); cover art extracted from embedded MP3 tag
- Removed 2 PDFs (ultra-compact Google Docs ES, Transliterated Key Terms EN)
- Committed c72248b (#15) and 7029a80 (#16, #17); pushed to origin/main

**Issues opened:** #17
**Issues closed:** #16, #17 (La Paloma resources section complete)

---

## Session: 2026-03-06 — La Paloma Kirtan Audio: Metadata, Cover Art + Glossary Expansion

**Focus:** Embed metadata and cover art into La Paloma kirtan extracts; expand glossary with La Paloma terms.

**Completed:**
- **#15** — Glossary expanded: 17 new terms from La Paloma talk; La Paloma added as reference [5]; headers updated to "five talks" (EN + ES)
- **#14** — Kirtan audio metadata embedded (title, artist, album, genre, date, track, composer, copyright, comment) via `embed-metadata.ps1`; Piriápolis yoga nidra metadata embedded
- **#14** — Cover art (1000×1000 JPEG, resized from 2048×2048 PNG) embedded into both kirtan m4a files via `embed-cover-art.ps1`
- `audio-metadata.yaml` — master metadata sidecar created at Events/ level (human-editable source of truth)
- `verify-metadata.ps1` — ffprobe read-back verification script
- `original-audio-identified-segments.yaml` — renamed from segments.yaml; header comment added documenting purpose
- `embed-cover-art.ps1`, `embed-metadata.ps1` — PowerShell scripts for re-embedding if metadata changes

**Issues opened:** #16
**Issues closed:** #15 (glossary portion)

---

## Session: 2026-03-05 — La Paloma Event Transcripts + Whisper File Organization

**Focus:** Complete La Paloma event (#15); yoga nidra audio extraction; raw/ file naming standardization.

**Completed:**
- **#13** — Whisper files renamed to `whisper-eng.txt/srt` (3-letter ISO lang codes) across all 5 events; La Paloma event set up (raw/, docs/events/, resources/, index.html, events.json)
- **#14** — Yoga nidra audio extracted from Piriápolis recording (00:28:53–01:06:40) via ffmpeg; segments.yaml created in working folder
- **#15** — La Paloma transcript-en.md and transcript-es.md generated and committed; audience responses restored; grandmother/grandfather phrasing preserved; "Anandamayi" corrected from whisper "Ananda Mahi"
- Renamed all raw/*/source.md → source-meta.md (architecture: no intermediate transcripts in raw/)
- Added .gitignore to exclude .claude/

**Issues opened:** #12, #13, #14, #15
**Issues closed:** #13, #15

---

## Session: 2026-03-05 — Setup, Glossary, Prompts, Raw Structure

**Focus:** Bring transcript workflow into VSCode/Claude Code; expand glossary; set up raw/ source structure.

**Completed:**
- **#5** — Bilingual glossary (glossary-en.md, glossary-es.md, glossary.html); multi-citation fix `[1, 2]` → `[1], [2]`; synthesis table consolidation; talk dropdown synthesis link
- **#6** — Glossary added to talk dropdown (opens in new window via handleTalkSelect())
- **#7** — Glossary link added to Note section of all 8 event transcripts (EN + ES)
- **#8** — prompts/glossary.md — template for generating/updating glossary
- **#9** — prompts/transcript-en.md (Phase 1: raw Whisper → master EN transcript); prompts/transcript-es.md (Phase 2: master EN → ES translation); raw/README.md
- **#10** — raw/FOLDER/source.md placeholders for all 4 events; Satchidananda entry added to glossary (EN + ES); Swami lineage entries added (Niranjanananda, Satyananda, Satyasangananda, Sivananda, Swamiji); spelling corrected to Niranjanananda

**Issues opened:** #5–#10
**Issues closed:** #5, #6, #7, #8, #9, #10

---

## Session: Prior (Claude Desktop workflow)

**Focus:** Initial site build, transcript processing, synthesis.

**Completed:**
- Site scaffold: GitHub Pages from docs/, events.json, shared.js, event index.html template
- 4 event transcript pairs processed (EN + ES): Satyam, Yoga Carrasco, MACA, Piriápolis
- Transcript header standardization across all talks
- synthesis-en.md and synthesis-es.md
- prompts/synthesis.md and prompts/event-index-html.md
- **#1** — Initial repo setup
- **#2** — Synthesis commit
- **#3** — Prompts folder
- **#4** — Transcript header fixes, YouTube TBC placeholder

---
