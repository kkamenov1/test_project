import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import '../models/drawing.dart';

class DrawingsController extends ResourceController {
  DrawingsController(this.context);

  final ManagedContext context;

  @Operation.post('userId')
  Future<Response> addDrawing(
      @Bind.body() Drawing body, @Bind.path('userId') int userId) async {
    final drawingQuery = Query<Drawing>(context)
      ..values.points = body.points
      ..values.userId = userId;
    final insertedDrawing = await drawingQuery.insert();
    return Response.ok(insertedDrawing);
  }

  @Operation.get('userId')
  Future<Response> getAllDrawingsForUser(
      @Bind.path('userId') int userId) async {
    final drawingQuery = Query<Drawing>(context)
      ..where((drawing) => drawing.userId).equalTo(userId);
    return Response.ok(await drawingQuery.fetch());
  }

  @Operation.delete('userId', 'drawingId')
  Future<Response> deleteDrawing(@Bind.path('userId') int userId,
      @Bind.path('drawingId') int drawingId) async {
    final drawingQuery = Query<Drawing>(context)
      ..where((drawing) => drawing.userId).equalTo(userId)
      ..where((drawing) => drawing.id).equalTo(drawingId);
    final deletedCount = await drawingQuery.delete();

    if (deletedCount == 0) {
      return Response.notFound(body: 'Item not found.');
    }

    return Response.ok('Deleted $deletedCount items.');
  }
}
