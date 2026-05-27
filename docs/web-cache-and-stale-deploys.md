# Web cache: old site in normal browser, new site in incognito

## Why it happens

| Cause | Normal browser | Incognito |
|-------|----------------|-----------|
| **Browser HTTP cache** (especially `main.dart.js`) | Keeps old files | Empty cache → latest |
| **Old Flutter service worker** (PWA) | Serves cached app | No SW registered |
| **Google Search snippet** | May show old title/description for days | N/A (opens live URL) |

Production on **Docker/Caddy** previously set `Cache-Control: immutable` on **all `*.js`**, including `main.dart.js`. That forced a 1-year cache. **Fixed in `Caddyfile`** — only `/assets/*` and `/canvaskit/*` are long-cached now.

**GitHub Pages** does not read `web/_headers`. Mitigations: `--pwa-strategy=none`, `index.html` cache meta tags, build-id reload script, CI cache-bust on `flutter_bootstrap.js`.

## What we changed in the repo

1. **`Caddyfile`** — no long-cache on `main.dart.js`, `flutter_bootstrap.js`, `flutter.js`.
2. **`Dockerfile`** — `--pwa-strategy=none` (matches CI).
3. **`web/index.html`** — no-cache meta tags, unregister all SWs, clear all caches, reload once when `recrip-build-id` changes.
4. **`.github/workflows/deploy.yml`** — inject git SHA build id + `?v=` on bootstrap script; refresh `sitemap.xml` lastmod.

## After deploying

1. Run **Deploy to GitHub Pages** (or redeploy Docker) from `main`.
2. On your machine (once): open `https://recrip.com/` → DevTools → Application → **Clear site data**, or hard refresh **Ctrl+Shift+R** (Mac: **Cmd+Shift+R**).
3. For **Google Search** still showing old text: [Google Search Console](https://search.google.com/search-console) → URL inspection → `https://recrip.com/` → **Request indexing**.

## Verify headers (optional)

```bash
curl -sI https://recrip.com/main.dart.js | grep -i cache-control
curl -sI https://recrip.com/index.html | grep -i cache-control
```

Expect `main.dart.js` → `no-cache` or `must-revalidate` (not `max-age=31536000`).
