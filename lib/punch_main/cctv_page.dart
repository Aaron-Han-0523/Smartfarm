import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CCTVPage extends StatefulWidget {
  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  late VlcPlayerController playerController;
  // final String urlToStreamVideo = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
  // final VlcPlayerController controller = VlcPlayerController.network(
  //   'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //   hwAcc: HwAcc.FULL,
  //   autoPlay: true,
  //   options: VlcPlayerOptions(),
  // );
  // final int playerWidth = 640;
  // final int playerHeight = 360;

  @override
  void initState() {
    super.initState();
    playerController = VlcPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VlcPlayer(
          controller: playerController,
          aspectRatio: 16 / 9,
          placeholder: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (playerController.value.isPlaying) {
                playerController.pause();
              } else {
                playerController.play();
              }
            });
          },
          child: const Text("Play/Pause"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}

// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
//
// class CCTVPage extends StatefulWidget {
//   @override
//   _CCTVPageState createState() => _CCTVPageState();
// }
//
// class _CCTVPageState extends State<CCTVPage> {
//   VideoPlayerController? _controller;
// // const  _controller=VideoPlayerController;
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         body: Center(
//           child: _controller!.value.isInitialized
//               ? AspectRatio(
//             aspectRatio: _controller!.value.aspectRatio,
//             child: VideoPlayer(_controller!),
//           )
//               : Container(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _controller!.value.isPlaying
//                   ? _controller!.pause()
//                   : _controller!.play();
//             });
//           },
//           child: Icon(
//             _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }
// }
