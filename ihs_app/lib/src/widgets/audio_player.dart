import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../util/format.dart';
import '../util/log.dart';
import 'audio_media.dart';
import 'empty.dart';
import 'grayed_out.dart';
import 'theme/material_text_theme.dart';
import 'tick_builder.dart';

/// AudioPlayer provides a UI similar to the HTML5 UI for playing audio files.
///

@immutable
class AudioPlayer extends StatefulWidget {
  const AudioPlayer(
      {required this.media,
      super.key,
      this.enabled = false,
      this.initial = Duration.zero});
  final Future<AudioMedia> media;
  final bool enabled;
  final Duration initial;
  @override
  State<StatefulWidget> createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  // api.AudioPlayerState playerState = api.AudioPlayerState.STOPPED;

  AudioPlayerState() {
    media = widget.media;
  }

  late Future<AudioMedia> media;
  CompleterEx<bool> loaded = CompleterEx<bool>();
  //api.AudioPlayer audioApi = api.AudioPlayer();

  int bufferingCounter = 0;
  Duration position = Duration.zero;
  // If we are using the AudioPlayback then the enabled state
  // is controlled via this field and the widgets enabled param.
  bool _playbackEnabled = true;

  @override
  void initState() {
    super.initState();
    // audioApi.onAudioPositionChanged
    //     .listen((Duration position) => onPositionChanged(position));

    // audioApi.onDurationChanged.listen((Duration d) {
    //   // If we have a duration then it means the file has downloaded completely.
    //   setState(() => loaded.complete(true));
    // });

    // audioApi.onPlayerStateChanged.listen((api.AudioPlayerState s) {
    //   if (mounted) setState(() => playerState = s);
    // });

    // audioApi.onPlayerError.listen((msg) => onPlayerError(msg));
  }

  void onPlayerError(String message) {
    if (mounted) {
      setState(() {
        //      playerState = api.AudioPlayerState.STOPPED;
        position = Duration.zero;
      });
    }
  }

  void onPositionChanged(Duration position) {
    Log.d('onAudioPositionChanged:  $position');

    if (mounted) {
      // setState(() {
      //   this.position = position;
      //   // if the audio file plays as it loads these can get out of sync.
      //   media.then((audio) {
      //     if (position > audio.duration) {
      //       audio.duration = position;
      //     }
      //   });
      // });
    }
  }

  @override
  //  AudioController.of(context).registerPlayer(this);
  Widget build(BuildContext context) => FutureBuilderEx<AudioMedia>(
        future: awaitLoad,
        // show everything but greyed out whilst we wait.
        waitingBuilder: (context) => GrayedOut(
            child: Row(
          children: <Widget>[
            buildStatus(),
            Expanded(child: buildSlider()),
            TickBuilder(
                interval: const Duration(milliseconds: 300),
                limit: 3,
                active: !loaded.isCompleted,
                builder: (context, index) => buildProgressLabel(index))
          ],
        )),
        builder: (context, data) => Row(
          children: <Widget>[
            buildStatus(),
            Expanded(child: buildSlider()),
            TickBuilder(
                interval: const Duration(milliseconds: 300),
                limit: 3,
                active: !loaded.isCompleted,
                builder: (context, index) => buildProgressLabel(index))
          ],
        ),
      );

  /// waits for the media to completely load.
  // Log.d(green('awaitLoad'));
  // wait until the media loads, the media has stored its data and
  // the api has loaded the media.
  Future<AudioMedia> awaitLoad() async => Future.forEach<void>(
      [media, media.then<Future<void>>((audio) => audio.path), loaded.future],
      // ignore: avoid_types_on_closure_parameters
      (_) => null).then<AudioMedia>((void _) => media);

  Widget buildStatus() => FutureBuilderEx<AudioMedia>(
        future: () async => awaitLoad(),
        waitingBuilder: (context) => const SizedBox(
            width: 24,
            height: 24,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
        // ignore: prefer_expression_function_bodies
        builder: (_, audio) {
          // Widget button;
          // switch (playerState) {
          //   case api.AudioPlayerState.PLAYING:
          //   case api.AudioPlayerState.PAUSED:
          //     button = getButton(audio, playerState);
          //     break;
          //   case api.AudioPlayerState.STOPPED:
          //   case api.AudioPlayerState.COMPLETED:
          //     position = Duration.zero;
          //     audioApi.seek(position);
          //     button = getButton(audio, playerState);
          //     break;
          // }
          return const Empty();
        },
      );

  IconButton getButton(
    AudioMedia audio,
  ) {
    //  api.AudioPlayerState state) {
    const icon = Icons.play_arrow;

    void Function()? action = () async => onPlay(audio);

    // if (state == api.AudioPlayerState.PLAYING) {
    //   icon = Icons.pause;
    //   action = () => onPause(audio);
    // }

    if (!widget.enabled || _playbackEnabled == false) {
      action = null;
    }

    final iconButton =
        IconButton(icon: const Icon(icon, size: 28), onPressed: action);

    return iconButton;
  }

  Widget buildSlider() => FutureBuilderEx<AudioMedia>(
      future: () async => awaitLoad(),
      builder: (context, data) => SliderTheme(
          data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              inactiveTrackColor: Colors.blueGrey),
          child: Slider(
            max: (data != null ? data.duration.inMilliseconds.toDouble() : 0),
            value: position.inMilliseconds.toDouble(),
            onChanged: widget.enabled ? onSeek : null,
          )));

  Widget buildProgressLabel(int index) => FutureBuilderEx(
      future: () async => awaitLoad(),
      builder: (context, media) => ProgressLabel(media!, index, position));

  @override
  void dispose() {
    // api.release();
    stop();
    super.dispose();
  }

  Future<void> onPlay(AudioMedia audio) async {
    // if (audio.storageType == RecordingStorage.FILE) {
    //   await audioApi.play(await audio.path, isLocal: true);
    // } else {
    //   unawaited(audioApi.play(audio.url));
    // }
  }

  void onPause(AudioMedia audio) {
    //audioApi.pause();
  }

  void onSeek(double value) {
    // Note: We can only seek if the audio is ready
    setState(() => position = Duration(milliseconds: value.toInt()));
    //audioApi.seek(position);
  }

  void reset(Future<AudioMedia> media) {
    stop();
    setState(() async {
      this.media = media;
      position = Duration.zero;
    });
  }

  void playbackEnabled({required bool enabled}) {
    setState(() => _playbackEnabled = enabled);
  }

  void updateDuration(Duration duration) {
    setState(() async {
      position = Duration.zero;
      await media.then((audio) => audio.duration = duration);
    });
  }

  void stop() {
    //   audioApi.stop();
  }
}

class ProgressLabel extends StatelessWidget {
  const ProgressLabel(this.media, this.index, this.position, {super.key});
  final int index;
  final Duration position;
  final AudioMedia media;
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: MaterialTextTheme.bodyText2(context).color);

    final Widget label = FutureBuilderEx<AudioMedia>(
      future: () async => media,
      waitingBuilder: (context) =>
          Text('Buffering${'.' * index}', style: style),
      builder: (context, media) => Text(
        '${Format.duration(position, showSuffix: false)}'
        '/'
        '${Format.duration(media!.duration)}',
        style: style,
      ),
    );

    // padding to match the indent of the play button.
    return Container(
        padding: const EdgeInsets.only(right: 15), width: 110, child: label);
  }
}
