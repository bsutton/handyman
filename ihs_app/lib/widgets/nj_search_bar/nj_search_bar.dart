import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String searchTerm);

class NjSearchBar extends StatefulWidget {
  final VoidCallback onClose;
  final SearchCallback onSearch;
  NjSearchBar({Key key, @required this.onClose, @required this.onSearch}) : super(key: key);

  @override
  _NjSearchBarState createState() => _NjSearchBarState();
}

class _NjSearchBarState extends State<NjSearchBar> {
  final Debouncer<String> _debouncer = Debouncer<String>(
    Duration(milliseconds: 500),
  );

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
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.only(left: 16.0),
                ),
                onChanged: (search) => _debouncer.value = search,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: widget.onClose,
            )
          ],
        ),
      ),
    );
  }
}
