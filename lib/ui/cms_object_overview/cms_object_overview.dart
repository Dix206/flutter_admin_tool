import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/routes.dart';
import 'package:go_router/go_router.dart';

class CmsObjectOverview extends StatelessWidget {
  final CmsObject cmsObject;

  const CmsObjectOverview({
    Key? key,
    required this.cmsObject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: ValueKey(cmsObject.name),
      future: cmsObject.onLoadCmsObjects(
        searchQuery: null,
        lastLoadedCmsObjectId: null,
      ),
      builder: (context, snapshot) {
        final result = snapshot.data;

        if (result == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return result.fold(
          onError: (errorMessage) => Text(errorMessage),
          onSuccess: (cmsObjectValueList) => _CmsObjectContent(
            cmsObjectValueList: cmsObjectValueList,
            cmsObject: cmsObject,
          ),
        );
      },
    );
  }
}

class _CmsObjectContent extends StatelessWidget {
  final CmsObject cmsObject;
  final CmsObjectValueList cmsObjectValueList;

  const _CmsObjectContent({
    Key? key,
    required this.cmsObjectValueList,
    required this.cmsObject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.go(Routes.createObject(cmsObject.name)),
          child: const Text("Neues Object"),
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final cmsObjectValue = cmsObjectValueList.cmsObjectValues[index];

              return ListTile(
                onTap: () => context.go(
                  Routes.updateObject(
                    cmsObjectName: cmsObject.name,
                    existingCmsObjectValueId: cmsObject.idToString(cmsObjectValue.id),
                  ),
                ),
                title: Text(cmsObjectValue.id.toString()),
                subtitle: Text(cmsObjectValue.values.map((e) => e.value).join(' | ')),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: cmsObjectValueList.cmsObjectValues.length,
          ),
        ),
      ],
    );
  }
}
