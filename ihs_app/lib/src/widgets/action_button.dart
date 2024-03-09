import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton(
      {required this.title,
      required this.icon,
      required this.onPressed,
      super.key,
      this.checked = false,
      this.fillColor});
  final String title;
  final IconData icon;
  final bool checked;
  final Color? fillColor;
  final void Function() onPressed;

  @override
  _ActionButtonState createState() => _ActionButtonState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(DiagnosticsProperty<bool>('checked', checked))
      ..add(ColorProperty('fillColor', fillColor))
      ..add(ObjectFlagProperty<void Function()>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(DiagnosticsProperty<bool>('checked', checked))
      ..add(ColorProperty('fillColor', fillColor))
      ..add(ObjectFlagProperty<void Function()>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(DiagnosticsProperty<bool>('checked', checked))
      ..add(ColorProperty('fillColor', fillColor))
      ..add(ObjectFlagProperty<void Function()>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(DiagnosticsProperty<bool>('checked', checked))
      ..add(ColorProperty('fillColor', fillColor))
      ..add(ObjectFlagProperty<void Function()>.has('onPressed', onPressed));
  }
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RawMaterialButton(
            onPressed: widget.onPressed,
            splashColor: widget.fillColor ??
                (widget.checked ? Colors.white : Colors.blue),
            fillColor: widget.fillColor ??
                (widget.checked ? Colors.blue : Colors.white),
            elevation: 10,
            shape: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                widget.icon,
                size: 30,
                color: widget.fillColor != null
                    ? Colors.white
                    : (widget.checked ? Colors.white : Colors.blue),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                color: widget.fillColor ?? Colors.grey[500],
              ),
            ),
          )
        ],
      );
}
