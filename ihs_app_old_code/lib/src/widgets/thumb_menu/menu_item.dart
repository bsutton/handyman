import 'package:flutter/material.dart';

class MenuItem {

  MenuItem(this.label, this.svgFilename, this.onSelected);
  final String label;
  final String svgFilename;
  final VoidCallback onSelected;
}
