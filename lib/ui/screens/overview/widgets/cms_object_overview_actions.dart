import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';
import 'package:go_router/go_router.dart';

class CmsObjectOverviewActions extends StatelessWidget {
  final CmsObjectStructure cmsObjectStructure;
  final String? searchQuery;
  final int page;
  final CmsObjectSortOptions? sortOptions;

  const CmsObjectOverviewActions({
    Key? key,
    required this.cmsObjectStructure,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CmsButton(
          text: "Neues Objekt",
          onPressed: () => context.go(
            Routes.createObject(
              cmsObjectId: cmsObjectStructure.id,
              page: page,
              searchQuery: searchQuery,
              sortOptions: sortOptions,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: _SearchBar(
            cmsObject: cmsObjectStructure,
            searchQuery: searchQuery,
            sortOptions: sortOptions,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final CmsObjectSortOptions? sortOptions;

  const _SearchBar({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
    required this.sortOptions,
  }) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final _textEditingController = TextEditingController(text: widget.searchQuery);

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 40,
              maxWidth: 400,
            ),
            child: TextField(
              controller: _textEditingController,
              onSubmitted: (value) => context.go(
                Routes.overview(
                  cmsObjectId: widget.cmsObject.id,
                  page: 1,
                  searchQuery: _textEditingController.text.trim().isEmpty ? null : _textEditingController.text.trim(),
                  sortOptions: widget.sortOptions,
                ),
              ),
              decoration: InputDecoration(
                hintText: "Suche",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(
                  onPressed: _textEditingController.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CmsButton(
          text: "Suchen",
          onPressed: () => context.go(
            Routes.overview(
              cmsObjectId: widget.cmsObject.id,
              page: 1,
              searchQuery: _textEditingController.text.trim().isEmpty ? null : _textEditingController.text.trim(),
              sortOptions: widget.sortOptions,
            ),
          ),
        ),
      ],
    );
  }
}
