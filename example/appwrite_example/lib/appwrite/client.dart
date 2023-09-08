import 'package:appwrite/appwrite.dart';
import 'package:example/constants.dart';

final client = Client()
    .setEndpoint(appwriteHost)
    .setProject(appwriteProjectId)
    .setSelfSigned();
final account = Account(client);
final databases = Databases(client);
final teams = Teams(client);
final storage = Storage(client);
