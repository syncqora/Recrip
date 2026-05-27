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
3. **`web/index.html`** — on every visit, fetches `recrip-build.json` and **automatically reloads once** if the server build is newer than the cached page or last visit (users do not need a special URL).
4. **`.github/workflows/deploy.yml`** — inject git SHA build id, `recrip-build.json`, cache-bust `main.dart.js` in bootstrap scripts.
5. **`Dockerfile`** — same stamping for **Railway** deploys (was missing — live site had literal `$RECRIP_BUILD_ID`).

## Clearing storage in DevTools (local/session is not enough)

**Local storage** and **Session storage** do **not** remove:

- **Cache storage** (Flutter / service worker caches `main.dart.js`)
- **Service workers** (can keep serving the old app)
- **HTTP disk cache** (browser cache for `.js` files)

### Do this instead

1. DevTools → **Application** → left sidebar **Storage** → click **Clear site data** (bottom) → check all boxes → **Clear**.
2. Or manually:
   - **Cache storage** → expand → delete every entry
   - **Service workers** → **Unregister** for `recrip.com`
   - **IndexedDB** → delete if any `flutter` / app DBs exist
3. DevTools → **Network** → enable **Disable cache** → reload.
4. Hard reload: **Cmd+Shift+R** (Mac) or **Ctrl+Shift+R** (Windows).

## After deploying (for you, not every visitor)

1. Run **Deploy to GitHub Pages** (or redeploy Docker on Railway) from `main`.
2. **Returning users** who open `https://recrip.com/` normally get the new UI automatically (one silent reload when `recrip-build.json` reports a new `buildId`).
3. **One-time edge case:** users who still have a very old cached `index.html` from before these fixes may need **one** hard refresh (`Cmd+Shift+R`) or **Clear site data** — after that, future deploys update automatically.
4. For **Google Search** still showing old text: [Google Search Console](https://search.google.com/search-console) → URL inspection → **Request indexing**.

## Verify headers (optional)

```bash
curl -sI https://recrip.com/main.dart.js | grep -i cache-control
curl -sI https://recrip.com/index.html | grep -i cache-control
```

Expect `main.dart.js` → `no-cache` or `must-revalidate` (not `max-age=31536000`).
