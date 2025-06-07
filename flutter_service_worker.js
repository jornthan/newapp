'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "715fc83775c57aafc1992fb1b10edaae",
".git/config": "79e7da57203287745fbbb4c51a4a5ed3",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "a81a97efeb6c466648860608447676ce",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "a4a7a61e39d738b30cac2030c99d9c98",
".git/logs/refs/heads/gh-pages": "e5f2142a8beba5ae9313a28b1d320219",
".git/logs/refs/remotes/origin/gh-pages": "320c9498d9e1e18f7bc6e6fec6146626",
".git/objects/03/2fe904174b32b7135766696dd37e9a95c1b4fd": "80ba3eb567ab1b2327a13096a62dd17e",
".git/objects/06/b0fac6d7f4ac385be9837e038a6d5e87b4f2cd": "a5f1113c283676ed1bd8b6c868598c7b",
".git/objects/1f/b496c0c8eab2819fedce922bf333a5db5de78f": "6816ccc2193b3017d7c87bb4660347c5",
".git/objects/2b/c25a786c9e808e8c9a922f57000af20d3cfc3d": "1a75fbd5d3b02ca1731c74e8a7200a7c",
".git/objects/31/d91a33153de25e7d35d34ccb3967adca65554f": "953c9c5e09c6b7eddf3f91850de92b68",
".git/objects/33/31d9290f04df89cea3fb794306a371fcca1cd9": "e54527b2478950463abbc6b22442144e",
".git/objects/33/d3f8ad4701c0000826dd35fd03f93c921f3feb": "cba74632732423dc4ab09750f0514760",
".git/objects/35/1643944952ee05c877193a381da96dc96d9361": "faf747cf1c9e9b7a08178040c89c1871",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/44/9f33c21bd7b840757f154d500642f4b29e2b08": "4fbc400a054431bfc25315ef74d1ef20",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4c/05805ec52e57844d3fe9aa7c1283d18a9facef": "aab3f969bf3db53d822673ee99b11e41",
".git/objects/4f/02e9875cb698379e68a23ba5d25625e0e2e4bc": "254bc336602c9480c293f5f1c64bb4c7",
".git/objects/55/bae51cc6d33677b5d4acff6e22f29dcaa50cd2": "29a3565d0d4dd6c7dcb11744e01c9acd",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/61/4f8f6b8319f1e37c762ca62d19f382a3ab399d": "ddaad099d434834d9663986379d85f65",
".git/objects/64/5116c20530a7bd227658a3c51e004a3f0aefab": "f10b5403684ce7848d8165b3d1d5bbbe",
".git/objects/66/3521a17c19d66e26dc367d92dcd6948bfc393c": "9ce35b28e831cd53aff1e0d6863cb63b",
".git/objects/6a/735294d9a6f71dbf1e407370a118641054e882": "fc5d5ca7fc42d90a3ae5e2d91a86198a",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/5212a4d9aabf52b324aff6aed434c07add4ffe": "084c0768d23ad9676d04c7d0eb5df17e",
".git/objects/6e/8d2cdad9a16f6edcf452a30ec101d5bf9f8a5d": "ccc7a2a263400e38bd611ef489b18a86",
".git/objects/78/fdd06140e562fc425f71ce61099e4467135d56": "fefd2aabbfd3deb3a016540bdcbf423b",
".git/objects/84/1729ca46fb72ec7ac25986cd9429d7ece45811": "04b6aeb3ab967fc59fbeb817d35dc7d9",
".git/objects/86/e8c5d99a24f4a0c51d36a6b3f18cede63aa005": "985bd5bfcde2c3dc47d4c41c8ebb1b72",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/16dc2bb35294d25edd7fc2ef226a2431f0bc7b": "8c03a9a59492c2b206d76fccc5bb636e",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/93/be7fd9b9dcdd8564dafd7040a0c8c8f68d4080": "b27ff257c793a735fc818ff37f392ff9",
".git/objects/a1/884f005e97c55f2be5a4b480f7a657c0ee6384": "628b65cf083e4bc41988c3a6a201a9e3",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/ad/4a79394f79acf24d8caadc8f27b81a9cd2947e": "ab81a1664819c82a73c3df4b8b7ea9fc",
".git/objects/b5/a253d6eb7c377b21a25233ad27ceee2e4e6ba5": "02f1532f8350aaad611c39e2027186cc",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c2/8025593e4f2bec1bf90979d58e27b790ad4d47": "b8b104b2e41d5f83560034914741ea81",
".git/objects/c7/aebbf56c312d8b03437b37935a2021139b8ac6": "4aa0c3229f6fd8c49139c8399c60814b",
".git/objects/c8/2ceaa0992eff8d463e592357c0f7f5ee3ba9fa": "650db0f528de4a6f14f208c39b163722",
".git/objects/cb/2c643b037189427f3d1293e45f9ce8491a7d40": "e5231471c35c68865ad605d8057f4d06",
".git/objects/cb/aef3a85a5d740f615bffdd9ba74a922e4ac97f": "2c793d1864154dcdb080c8d461906160",
".git/objects/ce/2460e1eb3b861b86c9f4aab023bc25c61b9cff": "fe6c7b3b404f8ddcd8bea44118ac2e77",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/eb93defa263ca22103ac54227cd631f33b9ad0": "e2c50b955d62537c8d499acbb63f3451",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f1/05dc1278441bb5a28befbe978edd31bb514ccc": "d0772dccbe1432594c51354aae3de9fb",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/7017c6eaa36bfe9f7227e806d6f00a97d00530": "b1a349f983b10deb8c377c9f1c196c74",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f5/8114c5a7242f9acc6e410f205ba58b8535e943": "85809b06633a421a9b6867b772fdb41f",
".git/objects/fb/909507cfa9d3f5c43a1b6884735316af5d9297": "a7a02ae4ecbbf7d3f2b8bb83fe0dec18",
".git/refs/heads/gh-pages": "5a47ca6a5794b153a4d1ea6b0d3e161e",
".git/refs/remotes/origin/gh-pages": "5a47ca6a5794b153a4d1ea6b0d3e161e",
"assets/AssetManifest.bin": "95c68ea057060ecc3f30c7db604265df",
"assets/AssetManifest.bin.json": "f5becdc4adfa8f2a9647b2791d9c401f",
"assets/AssetManifest.json": "f77bc329a978b98b92e5841f35d7e16f",
"assets/assets/character.png": "94026e76b1682dc34095216c33ede17e",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "98bb991951ea6001107af90efb3d9833",
"assets/NOTICES": "17a8be035f7318902916a7643dd7e1fe",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "e39fcc76b097e9eeae71ba6ef9dfd2ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "e85c60054538f7a4bbd8dffac9703e71",
"/": "e85c60054538f7a4bbd8dffac9703e71",
"main.dart.js": "e495abd0822026339b7cabf4f15933ee",
"manifest.json": "ce897e34670819ab34747833389c6e3b",
"version.json": "1db4d93683e1eb150fd6f3778202d541"};
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
