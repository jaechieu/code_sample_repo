import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VideoPlayerWidget extends HookWidget {
  final String videoUrl;
  final BoxFit? fit;
  final SwiperController? controller;
  const VideoPlayerWidget({
    required this.videoUrl,
    this.fit,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CachedVideoPlayerController? videoPlayerController;
    final memoizedFuture = useMemoized(
      () async {
        videoPlayerController = CachedVideoPlayerController.network(
          videoUrl,
        );
        await videoPlayerController?.setVolume(0);
        await videoPlayerController?.initialize();
        if (controller != null) {
          controller?.stopAutoplay();
          Timer(videoPlayerController?.value.duration ?? Duration.zero, () {
            controller?.startAutoplay();
          });
        }
        await videoPlayerController?.setLooping(true);
        await videoPlayerController?.play();
        return videoPlayerController;
      },
    );
    final futureSnapshot = useFuture(memoizedFuture);

    useEffect(() {
      return () {
        videoPlayerController?.dispose();
      };
    }, const []);

    return futureSnapshot.connectionState == ConnectionState.done &&
            futureSnapshot.hasData
        ? kIsWeb
            ? FittedBox(
                fit: fit ?? BoxFit.cover,
                child: SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: CachedVideoPlayer(
                    futureSnapshot.data!,
                  ),
                ),
              )
            : CachedVideoPlayer(
                futureSnapshot.data!,
              )
        : SizedBox();
  }
}
