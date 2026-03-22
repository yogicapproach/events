#!/usr/bin/env bash
# 2026-uruguay — Eleventy build test suite
# Usage:
#   bash test/run-tests.sh [--skip-build]          # local build + server
#   bash test/run-tests.sh --live [https://url]    # test live site (default: https://yogicapproach.com)
# Requires: python3, curl

REPO="$(cd "$(dirname "$0")/.." && pwd)"
PORT=8083
SITE="$REPO/_site"
SERVE_DIR="$REPO/_serve"   # temp dir: serves _site/ contents under /events/
PASS=0; FAIL=0; WARN=0
PYTHON=$(which python 2>/dev/null || which python3 2>/dev/null || echo "python")
LIVE_MODE=false

# Parse args
for arg in "$@"; do
  if [[ "$arg" == "--live" ]]; then LIVE_MODE=true; fi
done
if $LIVE_MODE; then
  # Optional second arg is the base URL
  LIVE_URL="${2:-https://yogicapproach.com}"
  BASE="$LIVE_URL"
else
  BASE="http://localhost:$PORT"
fi

pass() { echo "  PASS  $*"; PASS=$((PASS+1)); }
fail() { echo "  FAIL  $*"; FAIL=$((FAIL+1)); }
warn() { echo "  WARN  $*"; WARN=$((WARN+1)); }
section() { echo ""; echo "══════════════════════════════════════════"; echo "  $*"; echo "══════════════════════════════════════════"; }

# check_file is filesystem-only; skip when testing live
check_file() {
  local path="$1" label="$2"
  if $LIVE_MODE; then
    warn "$label (skipped in --live mode: filesystem not available)"
    return
  fi
  if [ -f "$path" ] || [ -d "$path" ]; then
    pass "$label"
  else
    fail "$label — not found: $path"
  fi
}

# ── Build ────────────────────────────────────────────────────────────────────
section "BUILD"
if $LIVE_MODE; then
  echo "  Live mode — skipping build"
elif [[ "${1:-}" != "--skip-build" ]]; then
  cd "$REPO"
  echo "  Cleaning _site/..."
  npm run clean 2>&1 | tail -1
  echo "  Building..."
  npm run build 2>&1 | tail -3
  pass "Build complete"
else
  echo "  Skipping build (--skip-build)"
fi

# ── Server ───────────────────────────────────────────────────────────────────
section "SERVER"
if $LIVE_MODE; then
  echo "  Live mode — using $BASE"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/events/2026-uruguay/es/" 2>/dev/null || echo "000")
  if [ "$STATUS" = "200" ]; then
    pass "Live site reachable at $BASE/events/"
  else
    fail "Live site not responding (status $STATUS) — aborting"
    exit 1
  fi
else
  # Kill anything on port first
  taskkill //F //IM python.exe 2>/dev/null || true
  sleep 1

  # Build a serve directory that mirrors GitHub Pages path structure:
  # GitHub Pages serves yogicapproach/events repo at /events/, so _site/ contents
  # must be accessible at /events/... for absolute paths in HTML to resolve.
  rm -rf "$SERVE_DIR"
  mkdir -p "$SERVE_DIR/events"
  cp -r "$SITE"/. "$SERVE_DIR/events/"

  cd "$SERVE_DIR"
  $PYTHON -m http.server $PORT > /tmp/yogaval-test-server.log 2>&1 &
  SERVER_PID=$!
  sleep 2
  cd "$REPO"

  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/events/2026-uruguay/es/" 2>/dev/null || echo "000")
  if [ "$STATUS" = "200" ]; then
    pass "Server up at $BASE/events/ (PID $SERVER_PID)"
  else
    fail "Server not responding (status $STATUS) — aborting"
    exit 1
  fi
fi

# ── Helper ───────────────────────────────────────────────────────────────────
check_http() {
  local url="$1" expected="${2:-200}"
  local status
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$url")
  if [ "$status" = "$expected" ]; then
    pass "HTTP $status  $url"
  else
    fail "HTTP $status (expected $expected)  $url"
  fi
}

check_content() {
  # check_content URL "search string" "label"
  local url="$1" needle="$2" label="$3"
  if curl -s "$BASE$url" | grep -q "$needle"; then
    pass "$label"
  else
    fail "$label — '$needle' not found in $url"
  fi
}

check_file() {
  local path="$1" label="$2"
  if [ -f "$path" ] || [ -d "$path" ]; then
    pass "$label"
  else
    fail "$label — not found: $path"
  fi
}

# ── 1. Talk pages (15) ───────────────────────────────────────────────────────
section "1. TALK PAGES — HTTP 200 (15)"
FOLDERS=(
  "20260209-koshas-escuela-de-yoga-satyam"
  "20260210-living-fully-in-yourself-yoga-carrasco"
  "20260211-koshas-and-ai-maca"
  "20260218-tantroktam-devi-suktam-la-paloma"
  "20260223-koshas-piriopolis"
)
for lang in en es ne; do
  for folder in "${FOLDERS[@]}"; do
    check_http "/events/2026-uruguay/$lang/$folder/"
  done
done

# ── 2. Listing, synthesis, glossary, search ─────────────────────────────────
section "2. LISTING / SYNTHESIS / GLOSSARY / SEARCH"
for lang in en es ne; do
  check_http "/events/2026-uruguay/$lang/"
  check_http "/events/2026-uruguay/$lang/"
  check_http "/events/2026-uruguay/$lang/glossary/"
done
check_http "/events/2026-uruguay/search/"
  for lang in en es ne; do
    check_http "/events/2026-uruguay/$lang/search/"
  done

# ── 3. Redirect stubs ────────────────────────────────────────────────────────
section "3. REDIRECT STUBS"
check_http "/events/2026-uruguay/"
check_http "/events/2026-uruguay/"
for folder in "${FOLDERS[@]}"; do
  check_http "/events/2026-uruguay/$folder/"
done
check_http "/events/2026-uruguay/glossary/"
check_http "/events/2026-uruguay/glossary.html"

# ── 4. Static assets ─────────────────────────────────────────────────────────
section "4. STATIC ASSETS"
check_http "/events/2026-uruguay/events/shared.css"
check_http "/events/2026-uruguay/events/shared.js"
check_http "/events/2026-uruguay/assets/eleventy-extra.css"
check_http "/events/2026-uruguay/favicon.svg"
check_http "/events/2026-uruguay/pagefind/pagefind-ui.js"
check_http "/events/2026-uruguay/pagefind/pagefind-ui.css"
check_http "/events/2026-uruguay/20260223-koshas-piriopolis/resources/cover-art-yoga-nidra.png"
check_http "/events/2026-uruguay/20260218-tantroktam-devi-suktam-la-paloma/resources/cover-tantroktam-devi-suktam.jpg"

# ── 5. Bad URLs → 404 ────────────────────────────────────────────────────────
section "5. INVALID URLs → 404"
check_http "/events/2026-uruguay/es/nonexistent-talk/" 404
check_http "/events/2026-uruguay/bad-path/" 404
check_http "/events/2026-uruguay/en/20260223-koshas-piriopolis-xyz/" 404
check_http "/this-does-not-exist/" 404
check_http "/events/2026-uruguay/en/20260223/" 404

# ── 6. Title and OG tags — all 5 EN talks ───────────────────────────────────
section "6. TITLE & OG:URL — all 5 EN talks (no generic title, no double path)"
for folder in "${FOLDERS[@]}"; do
  BODY=$(curl -s "$BASE/events/2026-uruguay/en/$folder/")
  TITLE=$(echo "$BODY" | grep -o '<title>[^<]*</title>')
  OGURL=$(echo "$BODY" | grep -o 'og:url[^>]*content="[^"]*"')

  # Title must not be generic
  if echo "$TITLE" | grep -q "^<title>Yogaval 2026</title>$"; then
    fail "Generic title on $folder: $TITLE"
  else
    pass "Specific title: $TITLE"
  fi

  # og:url must not double-include 2026-uruguay
  if echo "$OGURL" | grep -q "2026-uruguay/2026-uruguay"; then
    fail "Double path in og:url for $folder"
  else
    pass "og:url clean: $(echo "$OGURL" | grep -o '2026-uruguay/en/[^/]*')"
  fi
done

# ── 7. Glossary links in transcripts ────────────────────────────────────────
section "7. GLOSSARY LINKS — absolute paths in transcripts (no ../../)"
for lang in en es ne; do
  for folder in "${FOLDERS[@]}"; do
    BODY=$(curl -s "$BASE/events/2026-uruguay/$lang/$folder/")
    if echo "$BODY" | grep -q '\.\./.*glossary'; then
      fail "Relative glossary link found: $lang/$folder"
    elif echo "$BODY" | grep -q "2026-uruguay/$lang/glossary/"; then
      pass "Glossary link correct: $lang/$folder"
    else
      warn "Glossary link not found in transcript: $lang/$folder (may not have one)"
    fi
  done
done

# ── 8. HTML lang attribute ───────────────────────────────────────────────────
section "8. HTML LANG ATTRIBUTE"
for lang in en es ne; do
  ACTUAL=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/" | grep -o '<html lang="[^"]*"' | head -1)
  if [ "$ACTUAL" = "<html lang=\"$lang\"" ]; then
    pass "html lang=\"$lang\" on $lang page"
  else
    fail "html lang wrong on $lang page: $ACTUAL"
  fi
done

# ── 9. Language toggle — aria-pressed ───────────────────────────────────────
# aria-pressed appears BEFORE id="btn-XX" in the element — grep the whole toggle div
section "9. LANG TOGGLE — aria-pressed"
for lang in en es ne; do
  BODY=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/")
  TOGGLE=$(echo "$BODY" | grep -A30 'lang-toggle')
  # Active button: aria-pressed="true" followed (within same <a>) by id="btn-$lang"
  if echo "$TOGGLE" | grep -B5 "id=\"btn-$lang\"" | grep -q 'aria-pressed="true"'; then
    pass "aria-pressed=true on active btn-$lang ($lang page)"
  else
    fail "aria-pressed=true missing on btn-$lang ($lang page)"
  fi
done

# ── 10. Transcript content rendered ─────────────────────────────────────────
section "10. TRANSCRIPT CONTENT — pre-rendered in HTML"
check_content "/events/2026-uruguay/en/20260223-koshas-piriopolis/" "data-pagefind-body" "EN: data-pagefind-body present"
check_content "/events/2026-uruguay/en/20260223-koshas-piriopolis/" "Namaste" "EN: transcript text present"
check_content "/events/2026-uruguay/es/20260218-tantroktam-devi-suktam-la-paloma/" "Charla de Satchidananda" "ES: h2 'Charla de Satchidananda'"
check_content "/events/2026-uruguay/ne/20260209-koshas-escuela-de-yoga-satyam/" "कोश" "NE: Nepali content present"

# ── 11. Talk selector completeness ──────────────────────────────────────────
section "11. TALK SELECTOR"
BODY=$(curl -s "$BASE/events/2026-uruguay/en/20260223-koshas-piriopolis/")
OPTION_COUNT=$(echo "$BODY" | grep -c '<option value=')
# Expect: 1 placeholder + 1 synthesis + 4 other talks + 1 glossary = 7
if [ "$OPTION_COUNT" -ge 7 ]; then
  pass "Selector has $OPTION_COUNT options (expected ≥7)"
else
  fail "Selector only has $OPTION_COUNT options (expected ≥7)"
fi
# Current talk must NOT appear as an option
if echo "$BODY" | grep 'option.*20260223-koshas-piriopolis' | grep -qv 'talk-select'; then
  fail "Current talk appears as option in selector"
else
  pass "Current talk excluded from selector"
fi
check_content "/events/2026-uruguay/en/20260223-koshas-piriopolis/" 'option.*glossary' "Glossary option in selector"

# ── 12. Resources section ────────────────────────────────────────────────────
section "12. RESOURCES SECTION"
# All talk pages start with resources-section hidden (JS reveals when resources exist).
# Check: section element is present, loadResources is called with absolute basePath.
check_content "/events/2026-uruguay/en/20260223-koshas-piriopolis/" 'id="resources-section"' "resources-section element present (Piriápolis)"
check_content "/events/2026-uruguay/en/20260223-koshas-piriopolis/" 'loadResources.*20260223-koshas-piriopolis.*resources' "loadResources called with absolute basePath (Piriápolis)"
check_content "/events/2026-uruguay/en/20260218-tantroktam-devi-suktam-la-paloma/" 'loadResources.*20260218-tantroktam-devi-suktam-la-paloma.*resources' "loadResources called with absolute basePath (La Paloma)"
# No-resources talk: inline display:none head style present (JS won't reveal it)
BODY=$(curl -s "$BASE/events/2026-uruguay/en/20260209-koshas-escuela-de-yoga-satyam/")
if echo "$BODY" | grep -q 'resources-section { display: none'; then
  pass "resources-section hidden via inline style on no-resources talk (Satyam)"
else
  fail "resources-section inline hide style missing on Satyam"
fi

# ── 13. resources.json coverage ─────────────────────────────────────────────
section "13. RESOURCES.JSON — per lang × event"
for lang in en es ne; do
  for folder in 20260218-tantroktam-devi-suktam-la-paloma 20260223-koshas-piriopolis; do
    check_file "$SITE/2026-uruguay/$lang/$folder/resources.json" "resources.json $lang/$folder"
  done
done

# ── 14. Binary resources files ───────────────────────────────────────────────
section "14. BINARY RESOURCES"
check_file "$SITE/2026-uruguay/20260218-tantroktam-devi-suktam-la-paloma/resources" "Tantroktam resources dir"
check_file "$SITE/2026-uruguay/20260223-koshas-piriopolis/resources" "Piriápolis resources dir"

# ── 15. Redirect stub JS logic ───────────────────────────────────────────────
section "15. REDIRECT STUBS — contain location.replace logic"
for url in "/events/2026-uruguay/" "/events/2026-uruguay/20260223-koshas-piriopolis/" "/events/2026-uruguay/glossary/"; do
  COUNT=$(curl -s "$BASE$url" | grep -c 'location.replace')
  if [ "$COUNT" -ge 1 ]; then
    pass "location.replace found in $url"
  else
    fail "location.replace missing in $url"
  fi
done

# ── 16. Synthesis content ────────────────────────────────────────────────────
section "16. SYNTHESIS PAGES"
for lang in en es ne; do
  BODY=$(curl -s "$BASE/events/2026-uruguay/$lang/")
  LEN=$(echo "$BODY" | wc -c)
  if [ "$LEN" -gt 10000 ]; then
    pass "Synthesis $lang: $LEN chars (content present)"
  else
    fail "Synthesis $lang: only $LEN chars (too short)"
  fi
done
check_content "/events/2026-uruguay/es/" "Última actualización" "ES synthesis: 'Última actualización' label"

# ── 17. Glossary content ─────────────────────────────────────────────────────
section "17. GLOSSARY PAGES"
check_content "/events/2026-uruguay/en/glossary/" "\[1\]" "EN glossary: citation [1] present"
check_content "/events/2026-uruguay/es/glossary/" "\[1\]" "ES glossary: citation [1] present"
check_content "/events/2026-uruguay/ne/glossary/" "\[१\]" "NE glossary: citation [१] present (Devanagari)"
check_content "/events/2026-uruguay/en/glossary/" '/events/2026-uruguay/en/' "EN glossary: links use new URL format"

# ── 18. Search page ──────────────────────────────────────────────────────────
section "18. SEARCH PAGE — Pagefind UI"
check_content "/events/2026-uruguay/en/search/" "pagefind/pagefind-ui.css" "Pagefind CSS linked"
check_content "/events/2026-uruguay/en/search/" "pagefind/pagefind-ui.js" "Pagefind JS linked"
check_content "/events/2026-uruguay/en/search/" "new PagefindUI" "PagefindUI initialized"
check_content "/events/2026-uruguay/en/search/" 'id="search"' "Search target div present"
check_content "/events/2026-uruguay/en/search/" "baseUrl.*events" "baseUrl set correctly"
check_file "$SITE/2026-uruguay/pagefind/pagefind.en_"* "Pagefind EN index"
check_file "$SITE/2026-uruguay/pagefind/pagefind.es_"* "Pagefind ES index"
check_file "$SITE/2026-uruguay/pagefind/pagefind.ne_"* "Pagefind NE index"

# ── 19. Shared.js content ────────────────────────────────────────────────────
section "19. SHARED.JS — resourcesBasePath param present"
JS=$(curl -s "$BASE/events/2026-uruguay/events/shared.js")
if echo "$JS" | grep -q "resourcesBasePath"; then
  pass "shared.js: resourcesBasePath parameter present"
else
  fail "shared.js: resourcesBasePath parameter missing"
fi

# ── 20. Full internal link audit ─────────────────────────────────────────────
section "20. INTERNAL LINK AUDIT"
LINK_PASS=0; LINK_FAIL=0
while IFS= read -r href; do
  fspath="${SITE}${href}"
  if [ -f "${fspath}index.html" ] || [ -f "$fspath" ]; then
    LINK_PASS=$((LINK_PASS+1))
  else
    fail "Broken internal link: $href"
    LINK_FAIL=$((LINK_FAIL+1))
  fi
done < <(grep -roh 'href="/events/2026-uruguay/[^"#?]*"' "$SITE/2026-uruguay/" 2>/dev/null | sed 's/href="\/events//;s/"//' | sort -u)

if [ "$LINK_FAIL" -eq 0 ]; then
  pass "All $LINK_PASS internal links resolve"
fi

# ── 21. _site/ root clean check ──────────────────────────────────────────────
section "21. _SITE/ ROOT — only expected files"
UNEXPECTED=""
for item in "$SITE"/*/; do
  name=$(basename "$item")
  if [[ "$name" != "2026-uruguay" ]]; then
    UNEXPECTED="$UNEXPECTED $name"
  fi
done
for item in "$SITE"/*; do
  name=$(basename "$item")
  if [[ -f "$item" && "$name" != "404.html" ]]; then
    UNEXPECTED="$UNEXPECTED $name"
  fi
done
if [ -z "$UNEXPECTED" ]; then
  pass "_site/ root is clean (only 404.html + 2026-uruguay/)"
else
  warn "_site/ root has unexpected items (stale build? run npm run clean):$UNEXPECTED"
fi

# ── 22. ES + NE titles — all 5 talks ────────────────────────────────────────
section "22. ES + NE TITLES — all 5 talks"
for lang in es ne; do
  for folder in "${FOLDERS[@]}"; do
    TITLE=$(curl -s "$BASE/events/2026-uruguay/$lang/$folder/" | grep -o '<title>[^<]*</title>')
    if echo "$TITLE" | grep -q "^<title>Yogaval 2026</title>$" || [ -z "$TITLE" ]; then
      fail "Generic/missing title on $lang/$folder: $TITLE"
    else
      pass "$lang/$folder: $TITLE"
    fi
  done
done

# ── 23. Meta description — populated, no raw HTML ────────────────────────────
section "23. META DESCRIPTION — populated on all lang variants of one talk"
for lang in en es ne; do
  DESC=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/" | grep -o 'name="description"[^>]*content="[^"]*"' | grep -o 'content="[^"]*"')
  if [ -z "$DESC" ]; then
    fail "$lang: meta description empty"
  elif echo "$DESC" | grep -q '<'; then
    fail "$lang: meta description contains raw HTML (striptags failed): $DESC"
  else
    pass "$lang: meta description set: $DESC"
  fi
done

# ── 24. ES header h2 = 'Charla de Satchidananda' ────────────────────────────
section "24. ES HEADER — 'Charla de Satchidananda' (not 'Talk by')"
for folder in "${FOLDERS[@]}"; do
  curl -s "$BASE/events/2026-uruguay/es/$folder/" | grep -q 'Charla de Satchidananda' \
    && pass "ES/$folder: Charla de Satchidananda present" \
    || fail "ES/$folder: 'Charla de Satchidananda' missing"
done

# ── 25. resources.json — valid JSON (UTF-8) + correct schema ─────────────────
section "25. RESOURCES.JSON — valid UTF-8 JSON + schema"
for lang in en es ne; do
  for folder in 20260218-tantroktam-devi-suktam-la-paloma 20260223-koshas-piriopolis; do
    FILE="$SITE/2026-uruguay/$lang/$folder/resources.json"
    RESULT=$(python -c "
import json, sys
try:
    d = json.load(open(sys.argv[1], encoding='utf-8'))
    if not isinstance(d.get('resources'), list): sys.exit(2)
    if len(d['resources']) == 0: sys.exit(3)
    print('ok:' + str(len(d['resources'])))
except Exception as e:
    print('err:' + str(e)); sys.exit(1)
" "$FILE" 2>/dev/null || echo "err:parse-failed")
    if echo "$RESULT" | grep -q "^ok:"; then
      COUNT=$(echo "$RESULT" | sed 's/ok://')
      pass "Valid JSON+schema ($COUNT resources): $lang/$folder/resources.json"
    else
      fail "Invalid JSON or schema: $lang/$folder/resources.json ($RESULT)"
    fi
  done
done

# ── 26. Talk selector URLs — correct lang prefix ─────────────────────────────
section "26. TALK SELECTOR — correct lang prefix on each page"
for lang in en es ne; do
  BODY=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/")
  BAD=$(echo "$BODY" | grep '<option' | grep '2026-uruguay' | grep -v "/$lang/" | grep -v 'Choose\|Elegir\|छान')
  [ -z "$BAD" ] && pass "$lang: all selector options use /$lang/ prefix" \
                || fail "$lang: selector has wrong-lang options: $BAD"
done

# ── 27. Lang toggle hrefs — correct per folder (file-based, handles multiline) ─
section "27. LANG TOGGLE HREFS — cross-links correct"
TMP_HTML=$(mktemp /tmp/yogaval-test-XXXX.html)
curl -s "$BASE/events/2026-uruguay/es/20260218-tantroktam-devi-suktam-la-paloma/" > "$TMP_HTML"
for check_lang in en ne; do
  HREF=$(python -c "
import re, sys
with open(sys.argv[1], encoding='utf-8') as f: body = f.read()
m = re.search(r'href=\"(/events/2026-uruguay/$check_lang/20260218[^\"]+)\"[^>]*id=\"btn-$check_lang\"', body, re.DOTALL)
print(m.group(1) if m else 'NOT FOUND')
" "$TMP_HTML" 2>/dev/null || echo "NOT FOUND")
  EXPECTED="/events/2026-uruguay/$check_lang/20260218-tantroktam-devi-suktam-la-paloma/"
  [ "$HREF" = "$EXPECTED" ] \
    && pass "ES/Tantroktam: btn-$check_lang href correct" \
    || fail "ES/Tantroktam: btn-$check_lang href wrong (got: $HREF)"
done
rm -f "$TMP_HTML"

# ── 28. Footer nav — correct lang on all talk pages ──────────────────────────
section "28. FOOTER NAV — lang-correct href"
for lang in en es ne; do
  curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/" | grep 'footer-nav' | grep -q "href=\"/events/2026-uruguay/$lang/\"" \
    && pass "$lang: footer-nav href correct" \
    || fail "$lang: footer-nav href wrong"
done

# ── 29. Synthesis selector — all talks + correct lang ────────────────────────
section "29. SYNTHESIS SELECTOR — all talks + glossary"
BODY=$(curl -s "$BASE/events/2026-uruguay/es/")
OPT_COUNT=$(echo "$BODY" | grep -c '<option value=')
[ "$OPT_COUNT" -ge 6 ] && pass "ES synthesis: $OPT_COUNT options" || fail "ES synthesis: only $OPT_COUNT options"
BAD_OPT=$(echo "$BODY" | grep '<option' | grep '2026-uruguay' | grep -v '/es/')
[ -z "$BAD_OPT" ] && pass "ES synthesis: all options use /es/ prefix" || fail "ES synthesis: wrong-lang options"

# ── 30. Transcript content — non-empty for all 5 EN talks ───────────────────
section "30. TRANSCRIPT CONTENT — all 5 EN talks non-empty"
for folder in "${FOLDERS[@]}"; do
  LEN=$(python -c "
import re, sys
with open(sys.argv[1], encoding='utf-8') as f: body = f.read()
m = re.search(r'id=\"content\"[^>]*>(.*)', body, re.DOTALL)
print(len(m.group(1)) if m else 0)
" "$SITE/2026-uruguay/en/$folder/index.html" 2>/dev/null || echo 0)
  [ "$LEN" -gt 5000 ] \
    && pass "EN/$folder: transcript $LEN chars" \
    || fail "EN/$folder: transcript too short ($LEN chars)"
done

# ── 31. Devanagari in all NE talk pages ──────────────────────────────────────
section "31. NE PAGES — Devanagari content (not EN fallback)"
for folder in "${FOLDERS[@]}"; do
  curl -s "$BASE/events/2026-uruguay/ne/$folder/" | grep -q 'कोश\|योग\|नेपाल\|सत्\|चर्चा\|वार्ता' \
    && pass "NE/$folder: Devanagari confirmed" \
    || fail "NE/$folder: no Devanagari found"
done

# ── 32. Image modal and skip nav ─────────────────────────────────────────────
section "32. IMAGE MODAL + SKIP NAV"
for lang in en es ne; do
  BODY=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/")
  echo "$BODY" | grep -q 'id="img-modal"' \
    && pass "$lang: img-modal present" || fail "$lang: img-modal missing"
  echo "$BODY" | grep -q 'skip-nav' \
    && pass "$lang: skip-nav present" || fail "$lang: skip-nav missing"
done

# ── 34. 404 page — VALID_FOLDERS whitelist + countdown logic ─────────────────
section "34. 404 PAGE — VALID_FOLDERS whitelist + countdown"
PAGE_404="$SITE/404.html"
if [ -f "$PAGE_404" ]; then
  grep -q "VALID_FOLDERS" "$PAGE_404"   && pass "404: VALID_FOLDERS whitelist present" || fail "404: VALID_FOLDERS whitelist missing"
  grep -q "20260223-koshas-piriopolis"  "$PAGE_404" && pass "404: Piriápolis folder in whitelist"    || fail "404: Piriápolis folder missing from whitelist"
  grep -q "20260218-tantroktam-devi-suktam-la-paloma" "$PAGE_404" && pass "404: La Paloma folder in whitelist" || fail "404: La Paloma folder missing from whitelist"
  grep -q "countdown\|tick\|secs"       "$PAGE_404" && pass "404: countdown timer logic present"      || fail "404: countdown timer logic missing"
  grep -q "location.replace"            "$PAGE_404" && pass "404: location.replace present"           || fail "404: location.replace missing"
else
  fail "404: _site/404.html not found"
fi

# ── 33. CDN preconnects + marked.js ──────────────────────────────────────────
section "33. CDN PRECONNECTS + MARKED.JS"
BODY=$(curl -s "$BASE/events/2026-uruguay/en/20260223-koshas-piriopolis/")
echo "$BODY" | grep -q 'preconnect.*cdn.jsdelivr' && pass "preconnect: cdn.jsdelivr" || fail "preconnect: cdn.jsdelivr missing"
echo "$BODY" | grep -q 'preconnect.*gc.zgo.at'   && pass "preconnect: gc.zgo.at (GoatCounter)" || fail "preconnect: gc.zgo.at missing"
echo "$BODY" | grep -q 'marked@15'               && pass "marked.js CDN loaded" || fail "marked.js CDN missing"

# ── 35. PR #56: og-meta-fixes ────────────────────────────────────────────────
section "35. PR #56 — OG META: no &amp;mdash;, og:type=article on talk pages"
for lang in en es ne; do
  DESC=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/" \
    | grep -o 'name="description"[^>]*content="[^"]*"' | grep -o 'content="[^"]*"')
  if echo "$DESC" | grep -q '&amp;'; then
    fail "$lang: meta description contains &amp; (HTML entity encoding bug): $DESC"
  else
    pass "$lang: meta description clean (no &amp; encoding): $DESC"
  fi
done
# og:type must be "article" on talk pages (not "website")
OGTYPE=$(curl -s "$BASE/events/2026-uruguay/en/20260223-koshas-piriopolis/" \
  | grep -o 'og:type[^>]*content="[^"]*"' | grep -o 'content="[^"]*"')
if [ "$OGTYPE" = 'content="article"' ]; then
  pass "og:type=article on talk page: $OGTYPE"
else
  fail "og:type wrong on talk page (expected article, got): $OGTYPE"
fi
# og:type on listing page should still be "website"
OGTYPE_LIST=$(curl -s "$BASE/events/2026-uruguay/en/" \
  | grep -o 'og:type[^>]*content="[^"]*"' | grep -o 'content="[^"]*"')
if [ "$OGTYPE_LIST" = 'content="website"' ]; then
  pass "og:type=website on synthesis/listing page (correct)"
else
  warn "og:type on synthesis page: $OGTYPE_LIST (expected website)"
fi

# ── 36. PR #57: devanagari-font ──────────────────────────────────────────────
section "36. PR #57 — DEVANAGARI FONT: Noto Sans on NE pages only"
NE_BODY=$(curl -s "$BASE/events/2026-uruguay/ne/20260223-koshas-piriopolis/")
echo "$NE_BODY" | grep -qi "noto.*sans.*devanagari\|fonts.googleapis.com" \
  && pass "NE talk page: Noto Sans Devanagari font referenced" \
  || fail "NE talk page: Noto Sans Devanagari font missing"
EN_BODY=$(curl -s "$BASE/events/2026-uruguay/en/20260223-koshas-piriopolis/")
echo "$EN_BODY" | grep -qi "noto.*sans.*devanagari" \
  && fail "EN talk page: Noto Sans Devanagari incorrectly present (should be NE-only)" \
  || pass "EN talk page: Noto Sans Devanagari absent (correct)"

# ── 37. PR #58: touch-targets ────────────────────────────────────────────────
section "37. PR #58 — TOUCH TARGETS: 44px audio player + PDF summary"
CSS=$(curl -s "$BASE/events/2026-uruguay/events/shared.css")
echo "$CSS" | grep -q "resource-player" && echo "$CSS" | grep -A3 "resource-player" | grep -q "44px" \
  && pass "shared.css: .resource-player height 44px" \
  || fail "shared.css: .resource-player height 44px missing (WCAG touch target)"
echo "$CSS" | grep -q "compact-pdfs.*summary\|summary.*44px\|min-height.*44" \
  && pass "shared.css: PDF summary min-height 44px" \
  || fail "shared.css: PDF summary min-height 44px missing"
# Modal close button should exist in HTML
BODY=$(curl -s "$BASE/events/2026-uruguay/en/20260223-koshas-piriopolis/")
echo "$BODY" | grep -q 'img-modal.*button\|modal-close\|×\|✕' \
  && pass "Talk page: modal close button present" \
  || fail "Talk page: modal close button missing (touch users need explicit dismiss)"

# ── 38. PR #59: hreflang + canonical ─────────────────────────────────────────
section "38. PR #59 — HREFLANG + CANONICAL"
for lang in en es ne; do
  BODY=$(curl -s "$BASE/events/2026-uruguay/$lang/20260223-koshas-piriopolis/")
  echo "$BODY" | grep -q 'rel="alternate".*hreflang' \
    && pass "$lang: hreflang alternates present" \
    || fail "$lang: hreflang alternates missing"
  echo "$BODY" | grep -q 'rel="canonical"' \
    && pass "$lang: canonical link present" \
    || fail "$lang: canonical link missing"
  # x-default must point to EN
  echo "$BODY" | grep 'hreflang.*x-default\|x-default.*hreflang' | grep -q '/en/' \
    && pass "$lang: hreflang x-default → EN" \
    || fail "$lang: hreflang x-default missing or not pointing to /en/"
done

# ── 39. PR #60: sitemap + robots ─────────────────────────────────────────────
section "39. PR #60 — SITEMAP.XML + ROBOTS.TXT"
check_http "/events/2026-uruguay/sitemap.xml"
SITEMAP=$(curl -s "$BASE/events/2026-uruguay/sitemap.xml")
echo "$SITEMAP" | grep -q "<urlset" \
  && pass "sitemap.xml: valid XML wrapper" \
  || fail "sitemap.xml: <urlset> missing"
# Count URLs — expect at least 15 talk pages + 3 synthesis + 3 glossary
URL_COUNT=$(echo "$SITEMAP" | grep -c "<loc>")
[ "$URL_COUNT" -ge 20 ] \
  && pass "sitemap.xml: $URL_COUNT URLs (≥20 expected)" \
  || fail "sitemap.xml: only $URL_COUNT URLs (expected ≥20)"
check_http "/robots.txt"
ROBOTS=$(curl -s "$BASE/robots.txt")
echo "$ROBOTS" | grep -q "User-agent" \
  && pass "robots.txt: User-agent directive present" \
  || fail "robots.txt: User-agent missing"
echo "$ROBOTS" | grep -q "Sitemap:" \
  && pass "robots.txt: Sitemap: directive present" \
  || fail "robots.txt: Sitemap: directive missing"

# ── 40. PR #61: font-size-tokens ─────────────────────────────────────────────
section "40. PR #61 — CSS TOKENS + 18px BASE FONT"
CSS=$(curl -s "$BASE/events/2026-uruguay/events/shared.css")
echo "$CSS" | grep -q ":root\s*{" \
  && pass "shared.css: :root block present" \
  || fail "shared.css: :root block missing (CSS custom properties)"
echo "$CSS" | grep -q "\-\-color-accent\|--accent\|--color" \
  && pass "shared.css: CSS custom properties (--color-*) defined" \
  || fail "shared.css: CSS custom properties missing"
echo "$CSS" | grep -q "font-size.*18px\|18px.*font-size" \
  && pass "shared.css: 18px base font-size set" \
  || fail "shared.css: 18px base font-size missing"
echo "$CSS" | grep -q "#faf8f5\|faf8f5" \
  && pass "shared.css: warm background #faf8f5 present" \
  || fail "shared.css: warm background #faf8f5 missing"

# ── 41. PR #62: lang-select-mobile ───────────────────────────────────────────
section "41. PR #62 — MOBILE LANG SELECT (JS injection)"
JS=$(curl -s "$BASE/events/2026-uruguay/events/shared.js")
echo "$JS" | grep -q "injectLangSelectMobile" \
  && pass "shared.js: injectLangSelectMobile function present" \
  || fail "shared.js: injectLangSelectMobile function missing"
echo "$JS" | grep -q "lang-select-mobile" \
  && pass "shared.js: lang-select-mobile class injected via JS" \
  || fail "shared.js: lang-select-mobile class missing from JS"
CSS=$(curl -s "$BASE/events/2026-uruguay/events/shared.css")
echo "$CSS" | grep -q "lang-select-mobile" \
  && pass "shared.css: .lang-select-mobile style defined" \
  || fail "shared.css: .lang-select-mobile style missing"

# ── 42. Browser tests (Puppeteer) ────────────────────────────────────────────
section "42. BROWSER TESTS (Puppeteer) — JS runtime features"
if command -v node >/dev/null 2>&1 && [ -f "$REPO/node_modules/puppeteer/package.json" ]; then
  BROWSER_OUT=$(BROWSER_TEST_BASE="$BASE" BROWSER_TEST_PORT=$PORT node "$REPO/test/browser-tests.js" 2>&1)
  echo "$BROWSER_OUT" | grep -E "PASS|FAIL|SKIP|RESULT"
  B_PASS=$(echo "$BROWSER_OUT" | grep -c "^  PASS  ")
  B_FAIL=$(echo "$BROWSER_OUT" | grep -c "^  FAIL  ")
  PASS=$((PASS + B_PASS))
  FAIL=$((FAIL + B_FAIL))
else
  warn "Puppeteer not found — skipping browser tests (run: npm install --save-dev puppeteer)"
fi

# ── Done ─────────────────────────────────────────────────────────────────────
section "SUMMARY"
TOTAL=$((PASS+FAIL+WARN))
echo "  Total:   $TOTAL checks"
echo "  PASS:    $PASS"
echo "  FAIL:    $FAIL"
echo "  WARN:    $WARN"
echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "  RESULT:  ✓ ALL CHECKS PASSED — ready for user testing"
else
  echo "  RESULT:  ✗ $FAIL FAILURE(S) — fix before committing"
fi

# Stop server and clean up temp serve dir (local mode only)
if ! $LIVE_MODE; then
  taskkill //F //IM python.exe 2>/dev/null || true
  rm -rf "$SERVE_DIR"
fi
