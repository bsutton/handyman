import 'package:flutter/material.dart';

import 'hmb_droplist_dialog.dart';

class HMBDroplist<T> extends StatefulWidget {
  const HMBDroplist({
    required this.initialItem,
    required this.items,
    required this.format,
    required this.onChanged,
    required this.title,
    super.key,
  });
  final Future<T?> Function() initialItem;
  final Future<List<T>> Function(String? filter) items;
  final String Function(T) format;
  final void Function(T) onChanged;
  final String title;

  @override
  _HMBDroplistState<T> createState() => _HMBDroplistState<T>();
}

class _HMBDroplistState<T> extends State<HMBDroplist<T>> {
  T? _selectedItem;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedItem();
  }

  Future<void> _loadSelectedItem() async {
    _selectedItem = await widget.initialItem();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          final selectedItem = await showDialog<T>(
            context: context,
            builder: (context) => HMBDroplistDialog<T>(
              getItems: widget.items,
              formatItem: widget.format,
              title: widget.title,
              selectedItem: _selectedItem,
            ),
          );

          if (selectedItem != null) {
            if (mounted) {
              setState(() {
                _selectedItem = selectedItem;
              });
            }
            widget.onChanged(selectedItem);
          }
        },
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_loading)
                    const CircularProgressIndicator()
                  else
                    Text(_selectedItem != null
                        ? widget.format(_selectedItem as T)
                        : widget.title),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ),
      );
}
