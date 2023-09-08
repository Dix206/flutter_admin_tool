import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_reference/flat_attribute_reference.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';

/// T is the type of the reference
class FlatAttributeReferenceWidget<T extends Object> extends StatefulWidget {
  final T? currentValue;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<T> onFlatTypeUpdated;
  final FlatAttributeReference<T> flatTypeReference;

  const FlatAttributeReferenceWidget({
    Key? key,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
    required this.flatTypeReference,
  }) : super(key: key);

  @override
  State<FlatAttributeReferenceWidget<T>> createState() =>
      _FlatAttributeReferenceWidgetState<T>();
}

class _FlatAttributeReferenceWidgetState<T extends Object>
    extends State<FlatAttributeReferenceWidget<T>> {
  Map<String, T> _optionsToSelect = {};

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    final isValid = widget.flatTypeReference.isValid(widget.currentValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) =>
                  TextField(
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

            final result = await widget.flatTypeReference
                .searchFunction(textEditingValue.text);
            return result.fold(
              onError: (error) => <String>[],
              onSuccess: (data) {
                _optionsToSelect = {
                  for (final reference in data)
                    widget.flatTypeReference
                        .getReferenceDisplayString(reference): reference
                };

                return _optionsToSelect.keys.toList();
              },
            );
          },
          onSelected: (selection) =>
              widget.onFlatTypeUpdated(_optionsToSelect[selection]),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(
            widget.flatTypeReference
                .valueToString(context: context, value: widget.currentValue),
          ),
          trailing: widget.currentValue == null
              ? null
              : IconButton(
                  onPressed: () => widget.onFlatTypeUpdated(null),
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
              widget.flatTypeReference.invalidValueErrorMessage ??
                  flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
