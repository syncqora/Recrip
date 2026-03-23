// ignore_for_file: avoid_print
//
// Local dev helper for Flutter **web**: browsers block cross-origin calls to your API
// (e.g. app on :5xxx, API on :8080). This process listens on another port, forwards
// to the real API, and adds permissive CORS headers + OPTIONS preflight.
//
// 1) Start your real API (e.g. http://localhost:8080).
// 2) From repo root: `dart run tool/web_cors_proxy.dart`
//    Optional: `dart run tool/web_cors_proxy.dart http://127.0.0.1:8080 8081`
// 3) Run the app: `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8081`
//    Or one shot: `./scripts/dev_web_with_cors_proxy.sh` (starts this proxy + Flutter).
//    VS Code: Run Task "web-cors-proxy", then launch "Flutter: Chrome (API via CORS proxy :8081)".
//
// Production: configure CORS on the API instead of using this proxy.

import 'dart:io';

const _cors = <String, String>{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD',
  'Access-Control-Allow-Headers':
      'Authorization, Content-Type, X-Tenant-Id, X-Tracking-Id, X-Client-Id, Accept',
  'Access-Control-Max-Age': '86400',
};

void _addCors(HttpResponse r) {
  for (final e in _cors.entries) {
    r.headers.set(e.key, e.value);
  }
}

Future<void> main(List<String> args) async {
  final upstreamRaw = args.isNotEmpty
      ? args[0]
      : Platform.environment['UPSTREAM'] ?? 'http://127.0.0.1:8080';
  final port = args.length > 1
      ? int.tryParse(args[1]) ?? 8081
      : int.tryParse(Platform.environment['PROXY_PORT'] ?? '') ?? 8081;

  final upstream = Uri.parse(upstreamRaw.replaceAll(RegExp(r'/+$'), ''));
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print(
    'web_cors_proxy → http://localhost:$port  (forwarding to $upstream)',
  );

  await for (final HttpRequest incoming in server) {
    _handle(incoming, upstream).catchError((Object e, StackTrace st) {
      print('proxy error: $e\n$st');
    });
  }
}

Future<void> _handle(HttpRequest incoming, Uri upstreamBase) async {
  if (incoming.method == 'OPTIONS') {
    incoming.response.statusCode = HttpStatus.noContent;
    _addCors(incoming.response);
    await incoming.response.close();
    return;
  }

  final target = upstreamBase.replace(
    path: incoming.uri.path,
    queryParameters: incoming.uri.queryParameters.isEmpty
        ? null
        : incoming.uri.queryParameters,
  );

  final body = <int>[];
  try {
    await for (final chunk in incoming) {
      body.addAll(chunk);
    }
  } catch (e) {
    incoming.response.statusCode = HttpStatus.badRequest;
    _addCors(incoming.response);
    await incoming.response.close();
    print('read body: $e');
    return;
  }

  final client = HttpClient();
  try {
    final out = await client.openUrl(incoming.method, target);
    incoming.headers.forEach((name, values) {
      final l = name.toLowerCase();
      if (l == 'host' || l == 'content-length') return;
      for (final v in values) {
        out.headers.add(name, v);
      }
    });
    if (body.isNotEmpty) {
      out.add(body);
    }

    final ioResp = await out.close();

    incoming.response.statusCode = ioResp.statusCode;
    ioResp.headers.forEach((name, values) {
      final l = name.toLowerCase();
      if (l == 'transfer-encoding' || l == 'connection') return;
      for (final v in values) {
        incoming.response.headers.add(name, v);
      }
    });
    _addCors(incoming.response);

    await incoming.response.addStream(ioResp);
    await incoming.response.close();
  } catch (e, st) {
    print('upstream error: $e\n$st');
    incoming.response.statusCode = HttpStatus.badGateway;
    _addCors(incoming.response);
    incoming.response.write('Bad gateway: $e');
    await incoming.response.close();
  } finally {
    client.close(force: true);
  }
}
