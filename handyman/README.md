# handyman

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Gradle:

The project has an explicit path set for java in the android/gradle.properties file.
You will like need to update this path to point to your local java installation.

Note; android needs java 11.


# Upgrading the database.

Each time the app is launched it will check if the database needs to
be upgraded and automatically upgrade the databse.

The upgrade scripts are shipped as assets in the
 assets/sql/upgrade_scripts

In development to upgrade the database create a .sql file with the name
'vNN.sql'

Where NN is the new version number.
The version number must be an integer and should be one higher than the
previous version file in the directory.

Once you have added a new version file you must register it by
running the script:

tool/build.dart

This script updates the asset/sql/upgrade_list.json file which is 
used at run time to identify the set of upgrade assets.


