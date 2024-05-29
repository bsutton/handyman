import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';

import '../widgets/audio_media.dart';
import '../widgets/blocking_ui.dart';

// ignore: avoid_classes_with_only_static_members
class DialogPlayback {
  static prefix0.Future<void> show(
      BuildContext context, Future<AudioMedia> audioMedia) async {
    await BlockingUI().run(() async {
      // var media = await audioMedia;
      // var track = Track.fromBuffer(media.buffer,
      //     mediaFormat: WellKnownMediaFormats.adtsAac);

      // var player = SoundPlayerUI.fromTrack(
      //   track,
      // );

      // DialogModal.show(
      //   context,
      //   title: 'Play Message',
      //   okLabel: 'Done',
      //   showCancel: false,
      //   builder: (context) {
      //     return Padding(
      //       padding: const EdgeInsets.only(
      //           top: NJTheme.padding * 3,
      //           bottom: NJTheme.padding * 3,
      //           left: NJTheme.padding,
      //           right: NJTheme.padding),
      //       child: player,
      //     );
      //   },
      // );

      await (await audioMedia).dispose();
    }, label: 'Retrieving Recording');
  }
}
