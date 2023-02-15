import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_reference/cms_attribut_reference.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

/// T is the type of the reference
class CmsAttributReferenceWidget<T extends Object> extends StatefulWidget {
  final T? currentValue;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<T> onCmsTypeUpdated;
  final CmsAttributReference<T> cmsTypeReference;

  const CmsAttributReferenceWidget({
    Key? key,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.cmsTypeReference,
  }) : super(key: key);

  @override
  State<CmsAttributReferenceWidget<T>> createState() => _CmsAttributReferenceWidgetState<T>();
}

class _CmsAttributReferenceWidgetState<T extends Object> extends State<CmsAttributReferenceWidget<T>> {
  Map<String, T> _optionsToSelect = {};

  @override
  Widget build(BuildContext context) {
    final isValid = widget.cmsTypeReference.isValid(widget.currentValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (_) => onFieldSubmitted(),
          ),
          optionsBuilder: (textEditingValue) async {
            if (textEditingValue.text.trim().isEmpty) return const [];

            final result = await widget.cmsTypeReference.searchFunction(textEditingValue.text);
            return result.fold(
              onError: (error) => <String>[],
              onSuccess: (data) {
                _optionsToSelect = {
                  for (final reference in data) widget.cmsTypeReference.getReferenceDisplayString(reference): reference
                };

                return _optionsToSelect.keys.toList();
              },
            );
          },
          onSelected: (selection) => widget.onCmsTypeUpdated(_optionsToSelect[selection]),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(
            widget.cmsTypeReference.valueToString(context: context, value: widget.currentValue),
          ),
          trailing: widget.currentValue == null
              ? null
              : IconButton(
                  onPressed: () => widget.onCmsTypeUpdated(null),
                  icon: const Icon(Icons.delete),
                ),
        ),
        if (!isValid && widget.shouldDisplayValidationErrors)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              widget.cmsTypeReference.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
