import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_object_sort_options.dart';
import 'package:flutter_admin_tool/data_types/flat_object_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/routes.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_button.dart';
import 'package:go_router/go_router.dart';

class FlatObjectOverviewActions extends StatelessWidget {
  final FlatObjectStructure flatObjectStructure;
  final String? searchQuery;
  final int page;
  final FlatObjectSortOptions? sortOptions;

  const FlatObjectOverviewActions({
    Key? key,
    required this.flatObjectStructure,
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
        if (flatObjectStructure.onCreateFlatObject != null)
          FlatButton(
            text: FlatApp.getFlatTexts(context).createNewObjectButton,
            onPressed: () => context.go(
              Routes.createObject(
                flatObjectId: flatObjectStructure.id,
                page: page,
                searchQuery: searchQuery,
                sortOptions: sortOptions,
              ),
            ),
          ),
        if (flatObjectStructure.canSearchObjects) ...[
          const SizedBox(width: 16),
          Flexible(
            child: _SearchBar(
              flatObject: flatObjectStructure,
              searchQuery: searchQuery,
              sortOptions: sortOptions,
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  final FlatObjectStructure flatObject;
  final String? searchQuery;
  final FlatObjectSortOptions? sortOptions;

  const _SearchBar({
    Key? key,
    required this.flatObject,
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
                  flatObjectId: widget.flatObject.id,
                  page: 1,
                  searchQuery: _textEditingController.text.trim().isEmpty ? null : _textEditingController.text.trim(),
                  sortOptions: widget.sortOptions,
                ),
              ),
              decoration: InputDecoration(
                hintText: FlatApp.getFlatTexts(context).searchObjectsTextFieldHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(
                  onPressed: () {
                    _textEditingController.clear();
                    context.go(
                      Routes.overview(
                        flatObjectId: widget.flatObject.id,
                        page: 1,
                        searchQuery: null,
                        sortOptions: widget.sortOptions,
                      ),
                    );
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        FlatButton(
          text: FlatApp.getFlatTexts(context).searchObjectsButton,
          onPressed: () => context.go(
            Routes.overview(
              flatObjectId: widget.flatObject.id,
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
