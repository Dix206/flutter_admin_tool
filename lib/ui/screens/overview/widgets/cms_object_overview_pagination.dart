import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/ui/routes.dart';
import 'package:go_router/go_router.dart';

class CmsObjectOverviewPagination extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final int page;
  final int overallPages;
  final String? searchQuery;
  final CmsObjectSortOptions? sortOptions;

  const CmsObjectOverviewPagination({
    Key? key,
    required this.cmsObject,
    required this.page,
    required this.overallPages,
    required this.searchQuery,
    required this.sortOptions,
  }) : super(key: key);

  @override
  State<CmsObjectOverviewPagination> createState() => _PaginationState();
}

class _PaginationState extends State<CmsObjectOverviewPagination> {
  late final TextEditingController _pageController = TextEditingController(
    text: widget.page.toString(),
  );

  DateTime _lastPageUpdate = DateTime.now();

  @override
  void initState() {
    _pageController.addListener(() => _setNewPage(_pageController.text));
    super.initState();
  }

  Future<void> _setNewPage(String pageText) async {
    final newPage = int.tryParse(pageText);
    if (newPage == null) return;

    if (newPage < 1 || newPage > widget.overallPages || newPage == widget.page) return;

    DateTime thisPageUpdate = DateTime.now();
    _lastPageUpdate = thisPageUpdate;

    await Future.delayed(const Duration(milliseconds: 1000));
    if (thisPageUpdate != _lastPageUpdate || !mounted) return;

    context.go(
      Routes.overview(
        cmsObjectId: widget.cmsObject.id,
        page: newPage,
        searchQuery: widget.searchQuery,
        sortOptions: widget.sortOptions,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.page == 1
              ? null
              : () {
                  context.go(
                    Routes.overview(
                      cmsObjectId: widget.cmsObject.id,
                      page: widget.page - 1,
                      searchQuery: widget.searchQuery,
                      sortOptions: widget.sortOptions,
                    ),
                  );
                  _pageController.text = (widget.page - 1).toString();
                },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: widget.page == 1 ? Colors.grey : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "Page",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 4),
        SizedBox(
          height: 28,
          width: 40,
          child: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            maxLength: widget.overallPages.toString().length,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp('[1-${widget.overallPages}]'),
              ),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              contentPadding: EdgeInsets.zero,
              counterText: "",
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "of ${widget.overallPages}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: widget.page == widget.overallPages
              ? null
              : () {
                  context.go(
                    Routes.overview(
                      cmsObjectId: widget.cmsObject.id,
                      page: widget.page + 1,
                      searchQuery: widget.searchQuery,
                      sortOptions: widget.sortOptions,
                    ),
                  );
                  _pageController.text = (widget.page + 1).toString();
                },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color: widget.page == widget.overallPages ? Colors.grey : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
