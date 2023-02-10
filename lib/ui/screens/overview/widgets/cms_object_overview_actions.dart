import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';
import 'package:go_router/go_router.dart';

class CmsObjectOverviewActions extends StatelessWidget {
  final CmsObjectStructure cmsObjectStructure;
  final String? searchQuery;

  const CmsObjectOverviewActions({
    Key? key,
    required this.cmsObjectStructure,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SearchBar(
          cmsObject: cmsObjectStructure,
          searchQuery: searchQuery,
        ),
        const Spacer(),
        CmsButton(
          text: "Neues Objekt",
          onPressed: () => context.go(Routes.createObject(cmsObjectStructure.id)),
        ),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;

  const _SearchBar({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
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
      children: [
        SizedBox(
          height: 40,
          width: 240,
          child: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "Suche",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(width: 8),
        CmsButton(
          text: "Suchen",
          onPressed: () => context.go(
            Routes.overview(
              cmsObjectId: widget.cmsObject.id,
              page: 1,
              searchQuery: _textEditingController.text.trim().isEmpty ? null : _textEditingController.text.trim(),
            ),
          ),
        ),
      ],
    );
  }
}
