'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "4cba33272ef0564f0b571f6f4018d3bd",
"assets/AssetManifest.bin.json": "14903d0d08d0ff5a83e8ebdef6856a75",
"assets/assets/fonts/Inter-Black.otf": "e6fef702b507237e0033f4244cc4389c",
"assets/assets/fonts/Inter-BlackItalic.otf": "6b9a465122dcdddf666caa17a1447e67",
"assets/assets/fonts/Inter-Bold.otf": "d759e235e88e47f838062c7ab97308b1",
"assets/assets/fonts/Inter-BoldItalic.otf": "b186ce584f0824196eb2ef3a38e0da38",
"assets/assets/fonts/Inter-ExtraBold.otf": "b799b6950c238082c8e314d127842845",
"assets/assets/fonts/Inter-ExtraBoldItalic.otf": "83ba0d6212dc1fb6107c7749729798f9",
"assets/assets/fonts/Inter-ExtraLight.otf": "97592cd01de5f8e5db834265c3e2a0d4",
"assets/assets/fonts/Inter-ExtraLightItalic.otf": "c76c911e77ac5bb473f419cad8376b6d",
"assets/assets/fonts/Inter-Italic.otf": "0f9f3b37376a39136b2f0c63e287ad0f",
"assets/assets/fonts/Inter-Light.otf": "d7019947105844db1899d246172f06b4",
"assets/assets/fonts/Inter-LightItalic.otf": "4268ddecb3b091fc039efae1719cf1d6",
"assets/assets/fonts/Inter-Medium.otf": "ef3d193e6a6ad033724c7872aec1cff7",
"assets/assets/fonts/Inter-MediumItalic.otf": "3d33faa33190d4a4c271dbaf7a6dfb86",
"assets/assets/fonts/Inter-Regular.otf": "76e872bc911c3d908aeaf31b2c16bc63",
"assets/assets/fonts/Inter-SemiBold.otf": "ef2dede4404ddb4cb3ed69d196ef2722",
"assets/assets/fonts/Inter-SemiBoldItalic.otf": "cc0173dae3b39bd7bbb34674b8d576e1",
"assets/assets/fonts/Inter-Thin.otf": "72869267880104b27bed47fdf7e5c75d",
"assets/assets/fonts/Inter-ThinItalic.otf": "efd29db88022972e4835288ca2c43d32",
"assets/assets/fonts/Inter-V.ttf": "8d63a82f5fc6d6eba21050dd9111520d",
"assets/assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/assets/fonts/Poppins-Light.ttf": "fcc40ae9a542d001971e53eaed948410",
"assets/assets/fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/assets/fonts/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/assets/icons/add-customer.svg": "1d5c10ea0ca60ccede4185336964b15a",
"assets/assets/icons/alarm-clock_tab.svg": "549bc870d0a2f23d9763dba89591a25c",
"assets/assets/icons/back-button.svg": "58819ce29263477797ad5f18fcb5cb0f",
"assets/assets/icons/bell-ring.svg": "cd926c392134b0ee671af428dc5749ed",
"assets/assets/icons/bell.svg": "fe741898c74e55dcaf5c0e8f68ccec58",
"assets/assets/icons/book-check_tab.svg": "72398e4b332c392d918871932f5973fb",
"assets/assets/icons/calendar-days.svg": "3ad959524faa551a7bb600bb4bb2297d",
"assets/assets/icons/calendar-sync.svg": "dd34244943518994b23216c8473a5b44",
"assets/assets/icons/chart-column-big.svg": "365aeeed02762261c4ebdf73c89e987e",
"assets/assets/icons/chart-pie.svg": "7f2dac1e87e2c8dd6edf9946aed49e66",
"assets/assets/icons/circle-check.svg": "4f9cf49858543979bb90279ea51917eb",
"assets/assets/icons/clock.svg": "2f52707a1e2f99b28cb41751776e7972",
"assets/assets/icons/close-button.svg": "442ee249d1a46ff399bc9b967f569110",
"assets/assets/icons/credit-card.svg": "f924be8e83e31ac91008bbc2f1718676",
"assets/assets/icons/dashboard.svg": "838730844a0a4353fd02297c876678f5",
"assets/assets/icons/download.svg": "30c82ae44f3f107e05afbc5f3c5c00ee",
"assets/assets/icons/dropdown_down.svg": "3227191232ded75357e902b5e2f765ca",
"assets/assets/icons/edit.svg": "de47189d72ac6b8102dca0864baad737",
"assets/assets/icons/email.svg": "ab41c84a814ba9f3be2422a59b3014df",
"assets/assets/icons/eye-close.svg": "2d53d998a14a9a36a9fd37185a0713cf",
"assets/assets/icons/eye-open.svg": "2e29e297fcc20d9c0191f9529ed1c531",
"assets/assets/icons/globe.svg": "0a0b60394ba052ee74427d6cf38178a6",
"assets/assets/icons/headset.svg": "4e6fb0f3dcb46334b252d037c0f016ec",
"assets/assets/icons/log-out.svg": "1c88751307df0bec9c7a8da5ae522ec6",
"assets/assets/icons/renew.svg": "3bd539d66b39cda6438ac55077b0b36b",
"assets/assets/icons/search.svg": "6401a882ee413c388469ed587e8c53b1",
"assets/assets/icons/settings.svg": "b13b51a360e62f75a50430462cd329bb",
"assets/assets/icons/shield-x_tab.svg": "6bfa8a9019c7b2972df39723a3389e61",
"assets/assets/icons/trash.svg": "803288593ba1d4e8a1ef2129233551ee",
"assets/assets/icons/trending-up.svg": "33ff4521482b758bcd0ecbfdfca2e087",
"assets/assets/icons/upload.svg": "bce2a11f40b8611251d219b1ffa060e8",
"assets/assets/icons/users-round.png": "5b11674c70bf62010c507d6c3c8034d2",
"assets/assets/icons/users-round.svg": "a8b69267866e49aa18e9c2a7486242b6",
"assets/assets/icons/users_tab.svg": "ebcd60235f37cbad6ae1dafab4af0e0c",
"assets/assets/icons/WhatsappLogo.svg": "e69715fe1f75a53c4f3c07014584dacf",
"assets/assets/images/Dashboard.png": "5c8226af73aadc2f2115c14ed8fdc6b2",
"assets/assets/images/login-background.png": "20d6251ff5e38735aa2d30f77c0bee55",
"assets/assets/images/logo.png": "175e7674c9a86771a9eef8a17642cee6",
"assets/assets/images/Members.png": "f28424b430532e9eecfcc58525a21904",
"assets/assets/images/profile-icon.png": "d57dbb558b3da3924f48e08fc99612e5",
"assets/assets/images/recrip.png": "0f5b28e7ed5cf892ffcfcbe38ae4d88c",
"assets/assets/images/Renewals.png": "168336476b86c1b94bd1e36e6c808de9",
"assets/assets/images/saas-logo.png": "50f5e03a16435f49d6c0c04e1c1592de",
"assets/assets/images/saas-logo.svg": "217e5481165a709550eabbb03bf63a8f",
"assets/assets/images/saas-name.svg": "3408fb0f75ae7013e520414f1952dedc",
"assets/assets/jsons/countries_list.json": "0d702ab334ff2337d4f41bf67edfa991",
"assets/FontManifest.json": "f9657f223ddf7008bf8b5e7decfd61e2",
"assets/fonts/MaterialIcons-Regular.otf": "6b77192777899bee864a3a3258bd0377",
"assets/NOTICES": "cfc33d83a857711193408ee3dda2b0ee",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "7e39ea33372106738750f6f7a8e45cd9",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7d5cfd664d21ee63ddc5c6e4fac233de",
"/": "7d5cfd664d21ee63ddc5c6e4fac233de",
"main.dart.js": "77644e77cac21e93ad20e5bb3dff372e",
"manifest.json": "0a1bd23cf1e9ab3a776f475be58adcc1",
"version.json": "fa987cde32965dd876d478794ac2747b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
