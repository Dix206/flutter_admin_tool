import 'package:flutter/material.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final String selectedCmsObjectName;
  final Widget child;

  const MainScreen({
    Key? key,
    required this.selectedCmsObjectName,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmsObjects = FlutterCms.getAllObjects(context);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0.75, 0.0),
                  ),
                ],
                color: Theme.of(context).colorScheme.surface,
              ),
              child: ListView.builder(
                itemCount: cmsObjects.length,
                itemBuilder: (context, index) {
                  return Material(
                    child: ListTile(
                      title: Text(cmsObjects[index].name),
                      onTap: () => context.go(Routes.overview(cmsObjects[index].name)),
                      tileColor: Theme.of(context).colorScheme.surface,
                      selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                      selected: cmsObjects[index].name == selectedCmsObjectName,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRect(child: child),
          ),
        ],
      ),
    );
  }
}
