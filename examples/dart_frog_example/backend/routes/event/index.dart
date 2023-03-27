import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../event/event.dart';
import '../../event/event_store.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<EventStore>();
  final events = dataSource.getAllEvents();
  return Response.json(
    body: events,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "*",
    },
  );
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<EventStore>();
  final event = Event.fromJson(
    (await context.request.json()) as Map<String, dynamic>,
  );

  dataSource.insertEvent(event);

  return Response.json(
    statusCode: HttpStatus.created,
    body: event,
  );
}
