import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_cms/ui/routes.dart';
import 'package:flutter_cms/flutter_cms.dart';

enum CmsMainScreenTab {
  overview,
  custom,
  settings,
}

class CmsMainScreen extends StatelessWidget {
  final CmsMainScreenTab selectedTab;
  final String? selectedCmsObjectId;
  final String? selectedCustomMenuEntryId;
  final Widget child;

  const CmsMainScreen({
    Key? key,
    required this.selectedTab,
    required this.selectedCmsObjectId,
    required this.selectedCustomMenuEntryId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmsObjectStructures = FlutterCms.getAllCmsObjectStructures(context);
    final customMenuEntries = FlutterCms.getCmsCustomMenuEntries(context);
    final cmsUserInfos = FlutterCms.getUserInfos(context);

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
                  if (cmsUserInfos?.hasAnyValue() ?? false) ...[
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
                            if (cmsUserInfos?.name != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  cmsUserInfos!.name!,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            if (cmsUserInfos?.email != null)
                              Text(
                                cmsUserInfos!.email!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if (cmsUserInfos?.role != null)
                              Text(
                                cmsUserInfos!.role!,
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
                        selected: selectedTab == CmsMainScreenTab.overview && cmsObject.id == selectedCmsObjectId,
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
                            selectedTab == CmsMainScreenTab.custom && customMenuEntry.id == selectedCustomMenuEntryId,
                      ),
                    ),
                  ),
                  const Divider(),
                  Material(
                    child: ListTile(
                      title: Text(FlutterCms.getCmsTexts(context).settings),
                      onTap: () => context.go(Routes.settings),
                      tileColor: Theme.of(context).colorScheme.surface,
                      selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
                      selected: selectedTab == CmsMainScreenTab.settings,
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
