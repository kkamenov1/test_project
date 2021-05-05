import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import '../models/drawing.dart';

class DrawingsController extends ResourceController {
  DrawingsController(this.context);

  final ManagedContext context;

  @Operation.post()
  Future<Response> saveDrawing(@Bind.body() Drawing body) async {
    final drawingQuery = Query<Drawing>(context)..values.points = body.points;
    final insertedDrawing = await drawingQuery.insert();
    return Response.ok(insertedDrawing);
  }

  @Operation.get()
  Future<Response> getAllDrawings() async {
    final drawingQuery = Query<Drawing>(context);
    return Response.ok(await drawingQuery.fetch());
  }

  @Operation.delete('id')
  Future<Response> deleteDrawing(@Bind.path('id') int id) async {
    final drawingQuery = Query<Drawing>(context)
      ..where((drawing) => drawing.id).equalTo(id);
    final deletedCount = await drawingQuery.delete();

    if (deletedCount == 0) {
      return Response.notFound(body: 'Item not found.');
    }

    return Response.ok('Deleted $deletedCount items.');
  }
}
