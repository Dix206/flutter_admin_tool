import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../event/event_store.dart';
import '../../models/filter.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<EventStore>();
  final filter = Filter.fromJson(
    (await context.request.json()) as Map<String, dynamic>,
  );
  final todos = dataSource.getFilteredEvents(filter);
  return Response.json(body: todos);
}
