import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import '../models/drawing.dart';

class DrawingsController extends ResourceController {
  DrawingsController(this.context);

  final ManagedContext context;

  @Operation.post()
  Future<Response> addDrawing(@Bind.body() Drawing body) async {
    final userId = request.authorization.ownerID;

    final drawingQuery = Query<Drawing>(context)
      ..values.points = body.points
      ..values.userId = userId;

    final insertedDrawing = await drawingQuery.insert();
    return Response.ok(insertedDrawing);
  }

  @Operation.get()
  Future<Response> getAllDrawingsForUser() async {
    final userId = request.authorization.ownerID;

    final drawingQuery = Query<Drawing>(context)
      ..where((drawing) => drawing.userId).identifiedBy(userId);

    return Response.ok(await drawingQuery.fetch());
  }

  @Operation.delete('drawingId')
  Future<Response> deleteDrawing(@Bind.path('drawingId') int drawingId) async {
    final userId = request.authorization.ownerID;

    final drawingQuery = Query<Drawing>(context)
      ..where((drawing) => drawing.userId).identifiedBy(userId)
      ..where((drawing) => drawing.id).equalTo(drawingId);
    final deletedCount = await drawingQuery.delete();

    if (deletedCount == 0) {
      return Response.notFound(body: 'Item not found.');
    }

    return Response.ok('Deleted $deletedCount items.');
  }
}
