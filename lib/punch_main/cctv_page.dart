import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2021-12-29
* */

// TODO : 전체화면 전환

class CCTVPage extends StatefulWidget {
  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  late List<VlcPlayerController> playerControllers;
  List<String> urls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://media.w3.org/2010/05/sintel/trailer.mp4',
  ];

  bool showPlayerControls = true;
  double _aspectRatio = 16 / 9;

  // visibiliby
  List<bool> visibility_value = [true, true];

  @override
  void initState() {
    super.initState();
    playerControllers = <VlcPlayerController>[];
    for (var i = 0; i < urls.length; i++) {
      var controller = VlcPlayerController.network(
        urls[i],
        hwAcc: HwAcc.FULL,
        autoPlay: true,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
          ]),
        ),
      );
      playerControllers.add(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.all(8.0),
        itemCount: playerControllers.length,
        separatorBuilder: (_, index) {
          return Divider(height: 50, thickness: 5);
        },
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            child: Visibility(
              visible: visibility_value[index],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CCTV #${index + 1}"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                playerControllers[index].value.isPlaying
                                    ? playerControllers[index].pause()
                                    : playerControllers[index].play();
                              });
                            },
                            icon: Icon(Icons.control_camera)),
                      ],
                    ),
                    VlcPlayer(
                      controller: playerControllers[index],
                      aspectRatio: _aspectRatio,
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    for (final controller in playerControllers) {
      await controller.dispose();
    }
  }
}
