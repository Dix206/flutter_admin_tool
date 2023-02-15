import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_cms/ui/routes.dart';
import 'package:flutter_cms/flutter_cms.dart';

enum MainScreenTab {
  overview,
  custom,
  settings,
}

class MainScreen extends StatelessWidget {
  final MainScreenTab selectedTab;
  final String? selectedCmsObjectId;
  final String? selectedCustomMenuEntryId;
  final Widget child;

  const MainScreen({
    Key? key,
    required this.selectedTab,
    required this.selectedCmsObjectId,
    required this.selectedCustomMenuEntryId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmsObjectStructures = FlutterCms.getAllCmsObjectStructures(context);
    final customMenuEntries = FlutterCms.getCustomMenuEntries(context);

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
              child: ListView(
                children: [
                  ...cmsObjectStructures.map(
                    (cmsObject) => Material(
                      child: ListTile(
                        title: Text(cmsObject.displayName),
                        onTap: () => context.go(
                          Routes.overview(
                            cmsObjectId: cmsObject.id,
                            page: 1,
                            searchQuery: null,
                            sortOptions: null,
                          ),
                        ),
                        tileColor: Theme.of(context).colorScheme.surface,
                        selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                        selected: selectedTab == MainScreenTab.overview && cmsObject.id == selectedCmsObjectId,
                      ),
                    ),
                  ),
                  if (customMenuEntries.isNotEmpty) const Divider(),
                  ...customMenuEntries.map(
                    (customMenuEntry) => Material(
                      child: ListTile(
                        title: Text(customMenuEntry.displayName),
                        onTap: () => context.go(
                          Routes.customMenuEntry(customMenuEntry.id),
                        ),
                        tileColor: Theme.of(context).colorScheme.surface,
                        selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                        selected:
                            selectedTab == MainScreenTab.custom && customMenuEntry.id == selectedCustomMenuEntryId,
                      ),
                    ),
                  ),
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
