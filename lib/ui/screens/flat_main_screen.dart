import 'package:flutter/material.dart';
import 'package:flat/constants.dart';
import 'package:go_router/go_router.dart';

import 'package:flat/ui/routes.dart';
import 'package:flat/flat_app.dart';

enum FlatMainScreenTab {
  overview,
  custom,
  settings,
}

class FlatMainScreen extends StatelessWidget {
  final FlatMainScreenTab selectedTab;
  final String? selectedFlatObjectId;
  final String? selectedCustomMenuEntryId;
  final Widget child;

  const FlatMainScreen({
    Key? key,
    required this.selectedTab,
    required this.selectedFlatObjectId,
    required this.selectedCustomMenuEntryId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < mobileViewMaxWidth;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              child: _Menu(
                selectedTab: selectedTab,
                selectedFlatObjectId: selectedFlatObjectId,
                selectedCustomMenuEntryId: selectedCustomMenuEntryId,
                isDrawer: true,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            Expanded(
              child: _Menu(
                selectedTab: FlatMainScreenTab.overview,
                selectedFlatObjectId: selectedFlatObjectId,
                selectedCustomMenuEntryId: selectedCustomMenuEntryId,
                isDrawer: false,
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

class _Menu extends StatelessWidget {
  final FlatMainScreenTab selectedTab;
  final String? selectedFlatObjectId;
  final String? selectedCustomMenuEntryId;
  final bool isDrawer;

  const _Menu({
    Key? key,
    required this.selectedTab,
    required this.selectedFlatObjectId,
    required this.selectedCustomMenuEntryId,
    required this.isDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flatObjectStructures = FlatApp.getAllFlatObjectStructures(context);
    final customMenuEntries = FlatApp.getFlatCustomMenuEntries(context);
    final flatUserInfos = FlatApp.getUserInfos(context);

    return DecoratedBox(
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
          if (flatUserInfos?.hasAnyValue() ?? false) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                const Icon(
                  Icons.person,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (flatUserInfos?.name != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          flatUserInfos!.name!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    if (flatUserInfos?.email != null)
                      Text(
                        flatUserInfos!.email!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (flatUserInfos?.role != null)
                      Text(
                        flatUserInfos!.role!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
          ],
          ...flatObjectStructures.map(
            (flatObject) => Material(
              child: ListTile(
                title: Text(flatObject.displayName),
                onTap: () {
                  if (isDrawer) Navigator.of(context).pop();
                  context.go(
                    Routes.overview(
                      flatObjectId: flatObject.id,
                      page: 1,
                      searchQuery: null,
                      sortOptions: null,
                    ),
                  );
                },
                tileColor: Theme.of(context).colorScheme.surface,
                selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                selected: selectedTab == FlatMainScreenTab.overview && flatObject.id == selectedFlatObjectId,
              ),
            ),
          ),
          if (customMenuEntries.isNotEmpty) const Divider(),
          ...customMenuEntries.map(
            (customMenuEntry) => Material(
              child: ListTile(
                title: Text(customMenuEntry.displayName),
                onTap: () {
                  if (isDrawer) Navigator.of(context).pop();
                  context.go(
                    Routes.customMenuEntry(customMenuEntry.id),
                  );
                },
                tileColor: Theme.of(context).colorScheme.surface,
                selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                selected: selectedTab == FlatMainScreenTab.custom && customMenuEntry.id == selectedCustomMenuEntryId,
              ),
            ),
          ),
          const Divider(),
          Material(
            child: ListTile(
              title: Text(FlatApp.getFlatTexts(context).settings),
              onTap: () {
                if (isDrawer) Navigator.of(context).pop();
                context.go(Routes.settings);
              },
              tileColor: Theme.of(context).colorScheme.surface,
              selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
              selected: selectedTab == FlatMainScreenTab.settings,
            ),
          ),
        ],
      ),
    );
  }
}
