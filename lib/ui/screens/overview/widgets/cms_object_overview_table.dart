import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:go_router/go_router.dart';

const _tableEntryWidth = 160.0;
const _idTableEntryWidth = 60.0;

class CmsObjectOverviewTable extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final List<CmsObjectValue> cmsObjectValues;
  final int page;
  final int overallPages;
  final String? searchQuery;

  const CmsObjectOverviewTable({
    Key? key,
    required this.cmsObject,
    required this.cmsObjectValues,
    required this.page,
    required this.overallPages,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minWidth = cmsObject.attributes
                .where(
                  (attribut) => attribut.shouldBeDisplayedOnOverviewTable,
                )
                .length *
            _tableEntryWidth +
        _idTableEntryWidth +
        32.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: minWidth > constraints.maxWidth ? minWidth : constraints.maxWidth,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        const _TableEntry(
                          text: "ID",
                          width: _idTableEntryWidth,
                        ),
                        ...cmsObject.attributes
                            .where(
                              (attribut) => attribut.shouldBeDisplayedOnOverviewTable,
                            )
                            .map(
                              (attribute) => _TableEntry(
                                text: attribute.displayName,
                              ),
                            )
                            .toList(),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: cmsObjectValues.length,
                    separatorBuilder: (context, index) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final cmsObjectValue = cmsObjectValues[index];

                      return InkWell(
                        onTap: cmsObject.onUpdateCmsObject == null
                            ? null
                            : () => _updateObject(
                                  context: context,
                                  cmsObjectValue: cmsObjectValue,
                                ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            _TableEntry(
                              text: cmsObjectValue.id ?? "---",
                              width: _idTableEntryWidth,
                            ),
                            ...cmsObjectValue.values
                                .where(
                                  (cmsAttributeValue) =>
                                      cmsObject
                                          .getAttributById(cmsAttributeValue.id)
                                          ?.shouldBeDisplayedOnOverviewTable ??
                                      false,
                                )
                                .map(
                                  (cmsAttributeValue) => _TableEntry(
                                    text: cmsObject
                                            .getAttributById(cmsAttributeValue.id)
                                            ?.valueToString(cmsAttributeValue.value) ??
                                        "---",
                                  ),
                                )
                                .toList(),
                            const SizedBox(width: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateObject({
    required BuildContext context,
    required CmsObjectValue cmsObjectValue,
  }) {
    if (cmsObjectValue.id == null) {
      showErrorMessage(
        context: context,
        errorMessage: "Das Objekt kann nicht bearbeitet werden, da es keine ID hat.",
      );
      return;
    }

    context.go(
      Routes.updateObject(
        cmsObjectId: cmsObject.id,
        existingCmsObjectValueId: cmsObjectValue.id!,
      ),
    );
  }
}

class _TableEntry extends StatelessWidget {
  final String text;
  final double width;

  const _TableEntry({
    Key? key,
    required this.text,
    this.width = _tableEntryWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      waitDuration: const Duration(seconds: 1),
      child: SizedBox(
        height: 56,
        width: width,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
