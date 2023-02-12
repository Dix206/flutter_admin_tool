import 'package:flutter/material.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:flutter_cms/ui/screens/main_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStateService = FlutterCms.getAuthStateService(context);
    final cmsAuthInfos = FlutterCms.getCmsAuthInfos(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () async {
              await cmsAuthInfos.onLogout();
              authStateService.onUserLoggedOut();
            },
            child: Text("Logout"),
          ),
        ),
      ],
    );
  }
}
