'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "48bfed7e7fad049c992c6e24876415e6",
"version.json": "fa987cde32965dd876d478794ac2747b",
"index.html": "4928f7d784c7de13d7d124a0e13975cc",
"/": "4928f7d784c7de13d7d124a0e13975cc",
"main.dart.js": "c77d044bba0434f06aec912c3ad314ad",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "ab1d7eba7bba91a1f13e79f0a19914a8",
"assets/NOTICES": "3a73d0ab60ffa3ac308e0e911c776c69",
"assets/FontManifest.json": "f9657f223ddf7008bf8b5e7decfd61e2",
"assets/AssetManifest.bin.json": "0e20c8483d90dc44c30e79bfe90467c5",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "d49c62bd50a33b01a0ff96d1630fb512",
"assets/fonts/MaterialIcons-Regular.otf": "d876f5cee054afe375e3bc4e676571e0",
"assets/assets/jsons/countries_list.json": "82c54bfeba5508956244f3373cbdaefd",
"assets/assets/images/login-background.png": "20d6251ff5e38735aa2d30f77c0bee55",
"assets/assets/images/logo.png": "175e7674c9a86771a9eef8a17642cee6",
"assets/assets/images/saas-logo.svg": "369d84679aba363e5bd1aa05785934c5",
"assets/assets/images/profile-icon.png": "d57dbb558b3da3924f48e08fc99612e5",
"assets/assets/images/saas-name.svg": "5bce61207ea6e57530b2c7392fc5d958",
"assets/assets/images/saas-logo.png": "50f5e03a16435f49d6c0c04e1c1592de",
"assets/assets/icons/eye-open.svg": "1b53ad695dbe985a276c088065c4456c",
"assets/assets/icons/shield-x.png": "d462946f3ba39d14bf85f6d841e04159",
"assets/assets/icons/dashboard.png": "9f29293f58ef266d52ef5097d0829c0d",
"assets/assets/icons/alarm-clock.png": "c67877c870d3ae82fbe39f157ce5c3c3",
"assets/assets/icons/renew.svg": "aa984bb00984311671a6161db602fda0",
"assets/assets/icons/chart-column-big.svg": "eaed734e58b6cbdf91c624d469259418",
"assets/assets/icons/settings.png": "d3c8569410f4c25ea1ecf8966e2c0421",
"assets/assets/icons/headset.svg": "147f3ec313519493c2a22337565e5b82",
"assets/assets/icons/log-out.png": "573fb29ae386e1a787f113a710e15187",
"assets/assets/icons/headset.png": "7f85a42f18e529273346b1c35c90bc8f",
"assets/assets/icons/log-out.svg": "3ef5a3260559022efed836f480d439c0",
"assets/assets/icons/book-check.png": "dd8a5f65fb667a06fcc148e9f7250f1b",
"assets/assets/icons/chart-column-big.png": "2d35f6ef37bea8854c9615463ce8a46e",
"assets/assets/icons/settings.svg": "e066dedd983211814667ebb5368dbe5d",
"assets/assets/icons/renew.png": "c6e4b056b60120f1c2b9b27e4a8b2630",
"assets/assets/icons/dashboard.svg": "569647ff817679944611362933ba82d9",
"assets/assets/icons/eye-close.svg": "d47a5bc08d75afb4dfcfe50f2bce3821",
"assets/assets/icons/calendar-sync.png": "51b86848215dea85427fec8137774b81",
"assets/assets/icons/calendar-days.png": "35066118066d517b2d14f59d76261d74",
"assets/assets/icons/users.png": "913139a99da18989cd816476b94941f6",
"assets/assets/icons/users-round.png": "5b11674c70bf62010c507d6c3c8034d2",
"assets/assets/icons/bell-ring.png": "5fbac47908f59b2387296f82cadeaba6",
"assets/assets/icons/bell-ring.svg": "7aca07416835bb15f78a4fd47cc0dc67",
"assets/assets/icons/users-round.svg": "434b6c6efd805f9d4ed0d1d78160b74a",
"assets/assets/icons/close-button.svg": "c6569d503245c3f057cb622b2d9a92b8",
"assets/assets/icons/calendar-sync.svg": "c6cd669f4bc0df610fbeefe74fbf874a",
"assets/assets/icons/calendar-days.svg": "ed4c894d1df4790061a721e9b7a2312b",
"assets/assets/fonts/Inter-Bold.otf": "d759e235e88e47f838062c7ab97308b1",
"assets/assets/fonts/Inter-Regular.otf": "76e872bc911c3d908aeaf31b2c16bc63",
"assets/assets/fonts/Inter-SemiBoldItalic.otf": "cc0173dae3b39bd7bbb34674b8d576e1",
"assets/assets/fonts/Inter-Thin.otf": "72869267880104b27bed47fdf7e5c75d",
"assets/assets/fonts/Inter-Light.otf": "d7019947105844db1899d246172f06b4",
"assets/assets/fonts/Inter-ExtraLightItalic.otf": "c76c911e77ac5bb473f419cad8376b6d",
"assets/assets/fonts/Inter-Medium.otf": "ef3d193e6a6ad033724c7872aec1cff7",
"assets/assets/fonts/Inter-SemiBold.otf": "ef2dede4404ddb4cb3ed69d196ef2722",
"assets/assets/fonts/Inter-BlackItalic.otf": "6b9a465122dcdddf666caa17a1447e67",
"assets/assets/fonts/Inter-MediumItalic.otf": "3d33faa33190d4a4c271dbaf7a6dfb86",
"assets/assets/fonts/Inter-Black.otf": "e6fef702b507237e0033f4244cc4389c",
"assets/assets/fonts/Inter-Italic.otf": "0f9f3b37376a39136b2f0c63e287ad0f",
"assets/assets/fonts/Inter-ExtraBold.otf": "b799b6950c238082c8e314d127842845",
"assets/assets/fonts/Inter-ThinItalic.otf": "efd29db88022972e4835288ca2c43d32",
"assets/assets/fonts/Inter-ExtraLight.otf": "97592cd01de5f8e5db834265c3e2a0d4",
"assets/assets/fonts/Inter-ExtraBoldItalic.otf": "83ba0d6212dc1fb6107c7749729798f9",
"assets/assets/fonts/Inter-BoldItalic.otf": "b186ce584f0824196eb2ef3a38e0da38",
"assets/assets/fonts/Inter-LightItalic.otf": "4268ddecb3b091fc039efae1719cf1d6",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
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
