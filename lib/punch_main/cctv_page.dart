import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CCTVPage extends StatefulWidget {
  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  late VlcPlayerController playerController;

  @override
  void initState() {
    super.initState();
    playerController = VlcPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.grey[350], //색상변경 필요
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("CCTV #1"),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          playerController.value.isPlaying
                              ? playerController.pause()
                              : playerController.play();
                        });
                      },
                      child: const Text("Play/Pause"),
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.control_camera)),
                  ],
                ),
                VlcPlayer(
                  controller: playerController,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ]),
        ),
        Container(
          alignment: Alignment.center,
          // height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.grey[350], //색상변경 필요
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("CCTV #2"),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          playerController.value.isPlaying
                              ? playerController.pause()
                              : playerController.play();
                        });
                      },
                      child: const Text("Play/Pause"),
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.control_camera)),
                  ],
                ),
                VlcPlayer(
                  controller: playerController,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ]),
        ),
      ])),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
