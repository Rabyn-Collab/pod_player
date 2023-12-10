import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pod_player.dart';
import '../controllers/pod_getx_video_controller.dart';


class FullScreenView1 extends StatefulWidget {
  final String tag;
  const FullScreenView1({
    required this.tag,
    super.key,
  });

  @override
  State<FullScreenView1> createState() => _FullScreenView1State();
}

class _FullScreenView1State extends State<FullScreenView1>
    with TickerProviderStateMixin {
  late PodGetXVideoController _podCtr;
  @override
  void initState() {
    _podCtr = Get.find<PodGetXVideoController>(tag: widget.tag);
    _podCtr.fullScreenContext = context;
    _podCtr.keyboardFocusWeb?.removeListener(_podCtr.keyboadListner);

    super.initState();
  }

  @override
  void dispose() {
    _podCtr.keyboardFocusWeb?.requestFocus();
    _podCtr.keyboardFocusWeb?.addListener(_podCtr.keyboadListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _podCtr.onLoading?.call(context) ??
        const CircularProgressIndicator(
          backgroundColor: Colors.black87,
          color: Colors.white,
          strokeWidth: 2,
        );

    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          await _podCtr.disableFullScreen(
            context,
            widget.tag,
            enablePop: false,
          );
        }
        if (!kIsWeb) await _podCtr.disableFullScreen(context, widget.tag);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GetBuilder<PodGetXVideoController>(
            tag: widget.tag,
            builder: (podCtr) => Center(
              child: ColoredBox(
                color: Colors.black,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: podCtr.videoCtr == null
                        ? loadingWidget
                        : podCtr.videoCtr!.value.isInitialized
                        ? PodCoreVideoPlayer(
                      tag: widget.tag,
                      videoPlayerCtr: podCtr.videoCtr!,
                      videoAspectRatio:
                      podCtr.videoCtr?.value.aspectRatio ?? 16 / 9,
                    )
                        : loadingWidget,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
