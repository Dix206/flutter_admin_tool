import 'package:appwrite/appwrite.dart';

final client = Client().setEndpoint("http://localhost:776/v1").setProject("63e0f6dd73200066c8eb").setSelfSigned();
final account = Account(client);
final databases = Databases(client);
final teams = Teams(client);
final storage = Storage(client);
