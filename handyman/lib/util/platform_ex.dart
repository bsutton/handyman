import 'dart:io';

bool get isMobile => Platform.isAndroid || Platform.isIOS;
bool get isNotMobile => !isMobile;
