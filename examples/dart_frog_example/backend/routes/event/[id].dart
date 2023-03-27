import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../event/event.dart';
import '../../event/event_store.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final eventStore = context.read<EventStore>();
  final event = eventStore.getEvent(id);

  if (event == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Not found');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, event);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.put:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, Event event) async {
  return Response.json(body: event);
}

Future<Response> _delete(RequestContext context, String id) async {
  context.read<EventStore>().deleteEvent(id);
  return Response(statusCode: HttpStatus.noContent);
}
