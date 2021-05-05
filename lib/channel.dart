import 'package:aqueduct/managed_auth.dart';
import 'package:test_project/controllers/register_controller.dart';
import 'package:test_project/controllers/drawings_controller.dart';
import 'package:test_project/models/user.dart';
import 'test_project.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class TestProjectChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    // connecting to PostgreSQL
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        'test_project_user', 'password', 'localhost', 5432, 'test_project');

    context = ManagedContext(dataModel, persistentStore);
    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/auth/token').link(() => AuthController(authServer));

    router
        .route('/register')
        .link(() => RegisterController(context, authServer));

    router
        .route('/drawings/:userId/[:drawingId]')
        .link(() => DrawingsController(context));
    return router;
  }
}
