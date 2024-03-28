import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String searchTerm);

class NjSearchBar extends StatefulWidget {
  const NjSearchBar({required this.onClose, required this.onSearch, super.key});
  final VoidCallback onClose;
  final SearchCallback onSearch;

  @override
  NjSearchBarState createState() => NjSearchBarState();
}

class NjSearchBarState extends State<NjSearchBar> {
  final Debouncer<String> _debouncer =
      Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');

  @override
  void initState() {
    super.initState();
    _debouncer.values.listen(widget.onSearch);
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BottomAppBar(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.only(left: 16),
                ),
                onChanged: (search) => _debouncer.value = search,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            )
          ],
        ),
      ),
    );
}
