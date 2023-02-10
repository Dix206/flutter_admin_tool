import 'package:flutter/material.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final String selectedCmsObjectId;
  final Widget child;

  const MainScreen({
    Key? key,
    required this.selectedCmsObjectId,
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
                      title: Text(cmsObjects[index].displayName),
                      onTap: () => context.go(
                        Routes.overview(
                          cmsObjectId: cmsObjects[index].id,
                          page: 1,
                          searchQuery: null,
                          sortOptions: null,
                        ),
                      ),
                      tileColor: Theme.of(context).colorScheme.surface,
                      selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                      selected: cmsObjects[index].id == selectedCmsObjectId,
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
