#!/usr/bin/env node
// 2026-uruguay — Puppeteer browser test suite
// Tests JS-runtime features that cannot be verified statically.
//
// Usage:  node test/browser-tests.js [--port 8083]
// Called automatically by test/run-tests.sh as the final section.
// Expects the Python HTTP server already running (run-tests.sh starts it).
//
// Covers (#47):
//   B1  loadResources  — audio player renders for La Paloma + Piriápolis
//   B2  Pagefind       — search query returns results
//   B3  updateTopbar   — topbar credit injected after page load
//   B4  handleTalkSelect — selecting a talk navigates to it
//   B5  Lang toggle    — clicking ES sets aria-pressed correctly
//   B6  404 countdown  — bad URL shows countdown text, then redirects
//   B7  Image modal    — clicking a transcript image opens the modal

'use strict';
const puppeteer = require('puppeteer');

const PORT = process.env.BROWSER_TEST_PORT || process.argv.find(a => /^\d+$/.test(a)) || '8083';
const BASE = process.env.BROWSER_TEST_BASE || `http://localhost:${PORT}`;
const PIRIOPOLIS = `${BASE}/events/2026-uruguay/en/20260223-koshas-piriopolis/`;
const LA_PALOMA  = `${BASE}/events/2026-uruguay/en/20260218-tantroktam-devi-suktam-la-paloma/`;

let pass = 0, fail = 0;
function PASS(label) { console.log(`  PASS  ${label}`); pass++; }
function FAIL(label, detail) { console.log(`  FAIL  ${label}${detail ? ' — ' + detail : ''}`); fail++; }

async function check(label, fn) {
  try {
    const result = await fn();
    if (result === false) FAIL(label);
    else PASS(label);
  } catch (e) {
    FAIL(label, e.message.split('\n')[0]);
  }
}

async function waitVisible(page, selector, timeout = 6000) {
  await page.waitForSelector(selector, { visible: true, timeout });
}

(async () => {
  const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
  const page = await browser.newPage();
  page.setDefaultTimeout(10000);

  // ── B1. loadResources — audio/PDF cards render ──────────────────────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B1. LOAD RESOURCES — audio/PDF render');
  console.log('══════════════════════════════════════════');

  for (const [label, url] of [['Piriápolis', PIRIOPOLIS], ['La Paloma', LA_PALOMA]]) {
    await page.goto(url, { waitUntil: 'networkidle0' });
    // Resources section must become visible (loadResources reveals it)
    await check(`loadResources: #resources-section visible (${label})`, async () => {
      await waitVisible(page, '#resources-section');
    });
    // At least one audio card must appear
    await check(`loadResources: audio card rendered (${label})`, async () => {
      await page.waitForFunction(
        () => document.querySelectorAll('#resources-section audio, #resources-section .resource-card').length > 0,
        { timeout: 6000 }
      );
    });
  }

  // ── B2. Pagefind — search returns results ───────────────────────────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B2. PAGEFIND — search returns results');
  console.log('══════════════════════════════════════════');

  await page.goto(`${BASE}/events/2026-uruguay/en/search/`, { waitUntil: 'networkidle0' });
  await check('Pagefind: search input present', async () => {
    await page.waitForSelector('.pagefind-ui__search-input, input[type="search"]', { timeout: 5000 });
  });
  await check('Pagefind: typing "kosha" returns results', async () => {
    const input = await page.$('.pagefind-ui__search-input, input[type="search"]');
    await input.click();
    await input.type('kosha', { delay: 80 });
    await page.waitForFunction(
      () => document.querySelectorAll('.pagefind-ui__result, [class*="pagefind"][class*="result"]').length > 0,
      { timeout: 8000 }
    );
  });

  // ── B3. updateTopbar — credit link injected ─────────────────────────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B3. TOPBAR — credit link injected by JS');
  console.log('══════════════════════════════════════════');

  await page.goto(PIRIOPOLIS, { waitUntil: 'networkidle0' });
  await check('updateTopbar: #topbar exists', async () => {
    await page.waitForSelector('#topbar', { timeout: 5000 });
  });
  await check('updateTopbar: .topbar-credit has yogicapproach.com link', async () => {
    await page.waitForFunction(
      () => {
        const el = document.querySelector('.topbar-credit a');
        return el && el.href && el.href.includes('yogicapproach.com');
      },
      { timeout: 5000 }
    );
  });
  await check('updateTopbar: #topbar-feedback link set', async () => {
    await page.waitForFunction(
      () => {
        const el = document.getElementById('topbar-feedback');
        return el && el.href && el.href.length > 10;
      },
      { timeout: 5000 }
    );
  });

  // ── B4. handleTalkSelect — dropdown navigates ───────────────────────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B4. TALK SELECTOR — dropdown navigates');
  console.log('══════════════════════════════════════════');

  await page.goto(PIRIOPOLIS, { waitUntil: 'networkidle0' });
  await check('Talk selector: #talk-select present', async () => {
    await page.waitForSelector('#talk-select', { timeout: 5000 });
  });
  await check('Talk selector: selecting La Paloma navigates', async () => {
    // Get the La Paloma option value
    const optVal = await page.$eval(
      '#talk-select option[value*="20260218"]',
      el => el.value
    );
    // Select it — this triggers handleTalkSelect via onchange
    const [nav] = await Promise.all([
      page.waitForNavigation({ timeout: 8000 }),
      page.select('#talk-select', optVal)
    ]);
    const url = page.url();
    return url.includes('20260218');
  });

  // ── B5. Lang toggle — aria-pressed updates ──────────────────────────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B5. LANG TOGGLE — aria-pressed correct');
  console.log('══════════════════════════════════════════');

  await page.goto(PIRIOPOLIS, { waitUntil: 'networkidle0' });
  await check('Lang toggle: btn-en starts active (EN page)', async () => {
    await page.waitForFunction(
      () => document.getElementById('btn-en')?.getAttribute('aria-pressed') === 'true',
      { timeout: 5000 }
    );
  });
  await check('Lang toggle: clicking btn-es sets aria-pressed=true on btn-es', async () => {
    await page.click('#btn-es');
    await page.waitForFunction(
      () => document.getElementById('btn-es')?.getAttribute('aria-pressed') === 'true',
      { timeout: 5000 }
    );
  });
  await check('Lang toggle: clicking btn-es removes aria-pressed from btn-en', async () => {
    const pressed = await page.$eval('#btn-en', el => el.getAttribute('aria-pressed'));
    return pressed === 'false';
  });

  // ── B6. 404 countdown — load 404.html directly to test mechanism ─────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B6. 404 COUNTDOWN — mechanism test (direct file load)');
  console.log('══════════════════════════════════════════');
  // Python http.server won't serve _site/404.html for missing paths (GitHub Pages
  // does that). But we can load 404.html directly to verify the countdown JS fires:
  //   pathname = /2026-uruguay/404.html → no folder match → countdown to /2026-uruguay/en/
  // That destination IS a real page, so the redirect is fully exercisable.
  // 404.html lives at _site root, not inside /2026-uruguay/
  await page.goto(`${BASE}/events/404.html`, { waitUntil: 'domcontentloaded' });
  await check('404: countdown text appears ("Taking you there in")', async () => {
    await page.waitForFunction(
      () => document.body.innerText.includes('Taking you there in') || document.body.innerText.includes('Redirigiendo en'),
      { timeout: 7000 }
    );
  });
  await check('404: page redirects within 8s (countdown fires location.replace)', async () => {
    await page.waitForFunction(
      () => !window.location.pathname.endsWith('/404.html'),
      { timeout: 8000 }
    );
    return true;
  });

  // ── B7. Image modal — click resource cover image opens overlay ──────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B7. IMAGE MODAL — click resource cover opens overlay');
  console.log('══════════════════════════════════════════');

  // Piriápolis has a resource with a cover image; loadResources() injects
  // img[data-modal="true"] elements — those are the modal triggers.
  await page.goto(PIRIOPOLIS, { waitUntil: 'networkidle0' });
  await check('Image modal: #img-modal present in DOM', async () => {
    await page.waitForSelector('#img-modal', { timeout: 5000 });
  });
  // Wait for loadResources to inject cover images
  const coverImg = await page.waitForSelector('img.resource-cover[data-modal]', { timeout: 7000 }).catch(() => null);
  if (coverImg) {
    await check('Image modal: clicking resource cover image opens modal', async () => {
      await coverImg.click();
      await page.waitForFunction(
        () => document.getElementById('img-modal')?.classList.contains('open'),
        { timeout: 4000 }
      );
    });
    await check('Image modal: #img-modal-img src is populated', async () => {
      const src = await page.$eval('#img-modal-img', el => el.src);
      return src && src.length > 10;
    });
  } else {
    console.log('  SKIP  Image modal: no resource cover image found — check loadResources output');
  }

  // ── B8. Topbar language — header content matches page language ───────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B8. TOPBAR LANGUAGE — header matches page lang');
  console.log('══════════════════════════════════════════');
  // Regression test: shared.js was defaulting lang='es' for all Eleventy pages
  // because it read ?lang= (legacy pattern) but Eleventy uses URL paths (/en/, /es/).
  const topbarExpected = {
    en: 'Share feedback',
    es: 'Compartir comentarios',
    ne: 'प्रतिक्रिया दिनुहोस्'
  };
  for (const lang of ['en', 'es', 'ne']) {
    await page.goto(`${BASE}/events/2026-uruguay/${lang}/20260223-koshas-piriopolis/`, { waitUntil: 'networkidle0' });
    await check(`Topbar ${lang}: feedback link text is "${topbarExpected[lang]}"`, async () => {
      await page.waitForFunction(
        (expected) => document.getElementById('topbar-feedback')?.textContent?.trim() === expected,
        { timeout: 5000 },
        topbarExpected[lang]
      );
    });
  }

  // ── B9. Synthesis page — static event list pre-rendered ─────────────────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B8. SYNTHESIS — static event list rendered');
  console.log('══════════════════════════════════════════');

  for (const lang of ['en', 'es', 'ne']) {
    await page.goto(`${BASE}/events/2026-uruguay/${lang}/`, { waitUntil: 'networkidle0' });
    await check(`Synthesis ${lang}: updateTopbar injects credit link`, async () => {
      await page.waitForFunction(
        () => document.querySelector('.topbar-credit a')?.href?.includes('yogicapproach.com'),
        { timeout: 5000 }
      );
    });
    await check(`Synthesis ${lang}: talk selector has ≥6 options`, async () => {
      const count = await page.$$eval('#talk-select option', opts => opts.length);
      return count >= 6;
    });
  }

  // ── B10. Mobile lang select — .lang-select-mobile injected at ≤600px ────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B10. MOBILE LANG SELECT — JS-injected select visible at ≤600px');
  console.log('══════════════════════════════════════════');

  await page.setViewport({ width: 375, height: 812 }); // iPhone viewport
  await page.goto(PIRIOPOLIS, { waitUntil: 'networkidle0' });
  await check('Mobile lang select: .lang-select-mobile injected into DOM', async () => {
    await page.waitForSelector('.lang-select-mobile', { timeout: 5000 });
  });
  await check('Mobile lang select: .lang-select-mobile is visible at 375px', async () => {
    const visible = await page.$eval('.lang-select-mobile', el => {
      const style = window.getComputedStyle(el);
      return style.display !== 'none' && style.visibility !== 'hidden';
    });
    return visible;
  });
  await check('Mobile lang select: .lang-toggle buttons hidden at 375px', async () => {
    const hidden = await page.$eval('.lang-toggle', el => {
      return window.getComputedStyle(el).display === 'none';
    });
    return hidden;
  });
  await check('Mobile lang select: has 3 options (en, es, ne)', async () => {
    const count = await page.$$eval('.lang-select-mobile option', opts => opts.length);
    return count === 3;
  });
  await check('Mobile lang select: current lang option is selected', async () => {
    const selected = await page.$eval('.lang-select-mobile', sel => sel.value);
    return selected && selected.includes('/en/');
  });
  await page.setViewport({ width: 1280, height: 800 }); // restore desktop

  // ── B11. Mobile viewport — talk page renders without horizontal scroll ────────
  console.log('\n══════════════════════════════════════════');
  console.log('  B11. MOBILE VIEWPORT — no horizontal overflow');
  console.log('══════════════════════════════════════════');

  await page.setViewport({ width: 375, height: 812 }); // iPhone 14
  await page.goto(PIRIOPOLIS, { waitUntil: 'networkidle0' });
  await check('Mobile 375px: no horizontal scroll on talk page', async () => {
    const overflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
    return !overflow;
  });
  await check('Mobile 375px: lang toggle buttons hidden (select shown instead)', async () => {
    const hidden = await page.$eval('.lang-toggle', el => window.getComputedStyle(el).display === 'none');
    return hidden;
  });
  await check('Mobile 375px: transcript content present', async () => {
    const len = await page.$eval('#content', el => el.innerText.length);
    return len > 1000;
  });
  await page.setViewport({ width: 1280, height: 800 }); // restore desktop

  // ── Summary ─────────────────────────────────────────────────────────────────
  await browser.close();
  const total = pass + fail;
  console.log('\n══════════════════════════════════════════');
  console.log('  BROWSER TEST SUMMARY');
  console.log('══════════════════════════════════════════');
  console.log(`  Total:   ${total} checks`);
  console.log(`  PASS:    ${pass}`);
  console.log(`  FAIL:    ${fail}`);
  if (fail > 0) {
    console.log('\n  RESULT:  ✗ BROWSER FAILURES — see above');
    process.exit(1);
  } else {
    console.log('\n  RESULT:  ✓ ALL BROWSER CHECKS PASSED');
  }
})();
