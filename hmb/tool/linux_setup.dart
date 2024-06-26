#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

/// setup script to help get a linux (ubuntu) dev environment working.
void main() {
  'apt install --assume-yes '

          /// The flutter package flutter_secure_storage_linux needs these
          /// lib deps.
          'libsecret-1-dev libsecret-tools'
          ' libjsoncpp-dev libsecret-1-0'
          // required by oidc for the secure storage pacakge. If
          // you are running KDE then this needs to be changed ksecretservices.
          ' gnome-keyring'
      .start(privileged: true);
}
