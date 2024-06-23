import 'package:dcli/dcli.dart';

/// setup script to help get a linux (ubuntu) dev environment working.
void main() { 
  /// The flutter package flutter_secure_storage_linux needs these
  /// lib deps.
  'apt install libsecret-1-dev libsecret-tools libsecret-1-0'
      .start(privileged: true);
}
