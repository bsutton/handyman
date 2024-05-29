// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../util/file_utils.dart';
import '../widgets/audio_media.dart';
import '../widgets/blocking_ui.dart';

class DialogRecorder {
  static Future<void> show(
    BuildContext context,
    Future<AudioMedia> media, {
    void Function(Uint8List)? onOK,
    void Function()? onCancel,
  }) async {
    // var localContextKey = GlobalKey<LocalContextState>();

    await BlockingUI().run<void>(
      () async {
        /// The recorder can only operate on files.
        final path = FileUtils().createTempFile(TempFileLocations.recordings);

        /// if we have existing audio write it to the file so the
        /// user can listen to it before recording over it.
        final buf = (await media).buffer!;
        if (buf.isNotEmpty) {
          await File(path).writeAsBytes(buf);
        }
        // var track =
        //     Track.fromFile(path, mediaFormat: WellKnownMediaFormats.adtsAac);

        // DialogModal.show(context, title: 'Record Message', 
        //builder: (context) {
        //   return RecorderPlaybackController(
        //       child: LocalContext(
        //           key: localContextKey,
        //           builder: (localContext) {
        //             return Column(
        //               children: [
        //                 SoundRecorderUI(
        //                   track,
        //                   requestPermissions: requestPermissions,
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.all(NJTheme.padding),
        //                   child: SoundPlayerUI.fromTrack(track),
        //                 )
        //               ],
        //             );
        //           }));
        // }, onOK: () {
        //   RecorderPlaybackController.of(localContextKey.currentContext)
        // .stop();
        //   BlockingUI().run<void>(() async {
        //     if (onOK != null) onOK(await track.asBuffer);
        //     unawaited(File(path).delete());
        //   });
        // }, onCancel: () {
        //   RecorderPlaybackController.of(localContextKey.currentContext)
        // .stop();
        //   if (onCancel != null) onCancel();
        //   File(path).delete();
        // });
      },
    );
  }

  /// Callback for when the recorder needs permissions to record
  /// to the [track].
  // static Future<bool> requestPermissions(
  //     BuildContext context, Track track) async {
  //   var granted = false;

  //   /// change this to true if the track doesn't use external storage on android.
  //   var usingExternalStorage = false;

  //   // Request Microphone permission if needed
  //   print('microphone: ${await Permission.microphone.status}');
  //   var microphoneRequired = !await Permission.microphone.isGranted;

  //   var storageRequired = false;

  //   if (usingExternalStorage) {
  //     /// only required if track is on external storage
  //     // ignore: unrelated_type_equality_checks
  //     if (Permission.storage.status == PermissionStatus.undetermined) {
  //       print(
  //          
  // 'You are probably missing the storage permission in your manifest.');
  //     }

  //     storageRequired =
  //         usingExternalStorage && !await Permission.storage.isGranted;
  //   }

  //   /// build the 'reason' why and what we are asking permissions for.
  //   if (microphoneRequired || storageRequired) {
  //     var both = false;

  //     if (microphoneRequired && storageRequired) {
  //       both = true;
  //     }

  //     var reason = 'To record a message we need permission ';

  //     if (microphoneRequired) {
  //       reason += 'to access your microphone';
  //     }

  //     if (both) {
  //       reason += ' and ';
  //     }

  //     if (storageRequired) {
  //       reason += 'to store a file on your phone';
  //     }

  //     reason += '.';

  //     if (both) {
  //       reason += " \n\nWhen prompted, click the 'Allow' button on "
  //           'each of the following prompts.';
  //     } else {
  //       reason += " \n\nWhen prompted, click the 'Allow' button.";
  //     }

  //     /// tell the user we are about to ask for permissions.
  //     if (await DialogRequestPermission.show(context, reason)) {
  //       var permissions = <Permission>[];
  //       if (microphoneRequired) permissions.add(Permission.microphone);
  //       if (storageRequired) permissions.add(Permission.storage);

  //       /// ask for the permissions.
  //       await permissions.request();

  //       /// check the user gave us the permissions.
  //       granted = await Permission.microphone.isGranted &&
  //           await Permission.storage.isGranted;
  //       if (!granted) {
  //         QuickSnack().error(context,

  //   'Recording cannot start as you did not allow the required permissions.');
  //       }
  //     } else {
  //       granted = false;
  //       QuickSnack().error(context,
  //   'Recording cannot start as you did not allow the required permissions.');
  //     }
  //   } else {
  //     granted = true;
  //   }

  //   // we already have the required permissions.
  //   return granted;
  // }
}
