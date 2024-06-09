import 'dart:async';

import 'package:flutter/material.dart';

import 'hmb_droplist_dialog.dart';
import 'labeled_container.dart';

class HMBDroplist<T> extends FormField<T> {
  HMBDroplist({
    required this.initialItem,
    required this.items,
    required this.format,
    required this.onChanged,
    required this.title,
    this.required = true,
    super.key,
  }) : super(
          builder: (state) => _HMBDroplistContent<T>(
            state: state,
            initialItem: initialItem,
            items: items,
            format: format,
            onChanged: onChanged,
            title: title,
          ),
          validator: (value) {
            if (required && value == null) {
              return 'Required';
            }
            return null;
          },
        );

  final Future<T?> Function() initialItem;
  final Future<List<T>> Function(String? filter) items;
  final String Function(T) format;
  final void Function(T) onChanged;
  final String title;
  final bool required;

  @override
  FormFieldState<T> createState() => _HMBDroplistState<T>();
}

class _HMBDroplistState<T> extends FormFieldState<T> {
  @override
  HMBDroplist<T> get widget => super.widget as HMBDroplist<T>;

  T? _selectedItem;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadSelectedItem());
  }

  Future<void> _loadSelectedItem() async {
    _selectedItem = await widget.initialItem();
    setState(() {
      _loading = false;
    });
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _selectedItem = value;
  }

  @override
  Widget build(BuildContext context) => _HMBDroplistContent<T>(
        state: this,
        initialItem: widget.initialItem,
        items: widget.items,
        format: widget.format,
        onChanged: widget.onChanged,
        title: widget.title,
      );
}

class _HMBDroplistContent<T> extends StatelessWidget {
  const _HMBDroplistContent({
    required this.state,
    required this.initialItem,
    required this.items,
    required this.format,
    required this.onChanged,
    required this.title,
  });

  final FormFieldState<T> state;
  final Future<T?> Function() initialItem;
  final Future<List<T>> Function(String? filter) items;
  final String Function(T) format;
  final void Function(T) onChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    final state = this.state as _HMBDroplistState<T>;
    return GestureDetector(
      onTap: () async {
        final selectedItem = await showDialog<T>(
          context: context,
          builder: (context) => HMBDroplistDialog<T>(
            getItems: items,
            formatItem: format,
            title: title,
            selectedItem: state._selectedItem,
          ),
        );

        if (selectedItem != null) {
          state.didChange(selectedItem);
          onChanged(selectedItem);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          LabeledContainer(
            labelText: title,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state._loading)
                  const CircularProgressIndicator()
                else
                  Text(state._selectedItem != null
                      ? format(state._selectedItem as T)
                      : 'Select a $title'),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                state.errorText ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
