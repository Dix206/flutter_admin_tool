import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

enum MainScreenTab {
  overview,
  settings,
}

class MainScreen extends StatelessWidget {
  final MainScreenTab selectedTab;
  final String? selectedCmsObjectId;
  final Widget child;

  const MainScreen({
    Key? key,
    required this.selectedTab,
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
                itemCount: cmsObjects.length + 1,
                itemBuilder: (context, index) {
                  if (index == cmsObjects.length) {
                    return Column(
                      children: [
                        const Divider(),
                        Material(
                          child: ListTile(
                            title: const Text("Settings"),
                            onTap: () => context.go(Routes.settings),
                            tileColor: Theme.of(context).colorScheme.surface,
                            selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                            selected: selectedTab == MainScreenTab.settings,
                          ),
                        ),
                      ],
                    );
                  }

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
                      selected: selectedTab == MainScreenTab.overview && cmsObjects[index].id == selectedCmsObjectId,
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
