import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';

// Middleware para permitir CORS
Response _cors(Response response) => response.change(headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': '*',
    });

final List<Map<String, dynamic>> posts = [];
final uuid = Uuid();

Response _getPosts(Request request) {
  return Response.ok(jsonEncode(posts),
      headers: {'Content-Type': 'application/json'});
}

Future<Response> _addPost(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    if (data is! Map<String, dynamic> ||
        !data.containsKey('texto') ||
        !data.containsKey('imagem')) {
      return Response(400,
          body: jsonEncode({'erro': 'Campos inválidos'}),
          headers: {'Content-Type': 'application/json'});
    }

    final newPost = {
      'id': uuid.v4(),
      'texto': data['texto'],
      'imagem': data['imagem'],
    };
    posts.add(newPost);
    return Response(201,
        body: jsonEncode(newPost), headers: {'Content-Type': 'application/json'});
  } on FormatException {
    return Response(400,
        body: jsonEncode({'erro': 'JSON inválido'}),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response(500,
        body: jsonEncode({'erro': 'Erro interno do servidor'}),
        headers: {'Content-Type': 'application/json'});
  }
}

void main() async {
  final router = Router()
    ..get('/posts', _getPosts)
    ..post('/posts', _addPost);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) => (request) async {
            if (request.method == 'OPTIONS') {
              return Response.ok('',
                  headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                    'Access-Control-Allow-Headers': '*',
                  });
            }
            final response = await innerHandler(request);
            return _cors(response);
          })
      .addHandler(router);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('API rodando em http://${server.address.host}:${server.port}');
}
