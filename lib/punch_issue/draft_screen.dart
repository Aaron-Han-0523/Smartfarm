import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:plms_start/pages/utils/header_issue.dart';

import '../globals/globals.dart' as globals;

// https://www.youtube.com/watch?v=eWhnXGjppHw

/*
* name : DraftPage
* description : draft page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class DraftPage extends StatefulWidget {
  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  double _cdx = 0;
  double _cdy = 0;

  double get cdx => this._cdx;
  double get cdy => this._cdy;

  set cdx(double newCdx) => this._cdx = newCdx;
  set cdy(double newCdy) => this._cdy = newCdy;

  // double boxWidth = 100.0;
  // double boxHeight = 100.0;

  var pixelX = [];
  var pixelY = [];

  @override
  void initState() {
    Future.microtask(() {
      _cdx = 0;
      _cdy = 0;
    }).then((_) => setState(() {}));
    super.initState();
  }

  GlobalKey _key = GlobalKey();
  double _x = 0;
  double _y = 0;
  void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext!.findRenderObject() as RenderBox?;
    Offset position = box!.localToGlobal(Offset.zero);
    setState(() {
      _x = position.dx;
      _y = position.dy;
    });
    print([
      double.parse((_x).toStringAsFixed(2)),
      double.parse((_y).toStringAsFixed(2))
    ]);
  }

  //       .toStringAsFixed(2)),
  // 도면 좌표 찍기 화면
  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    var buttonWidth = Get.width * 1 / 3.5;

    return Scaffold(

        // appBar: AppBar(
        //   backgroundColor: Color(0xff2B3745),
        //   automaticallyImplyLeading: false,
        //   title:
        // ),
        body: SafeArea(
          child: Container(
            color: Color(0xFFE6E6E6),
            child: Column(
              children: [
                Header(
                  title: "Select Location",
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1.4 / 9,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFE6E6E6),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffB7C5B9),
                            borderRadius: BorderRadius.only(
                                topLeft: radius, bottomLeft: radius),
                          ),
                          height: MediaQuery.of(context).size.height * 1.4 / 9,
                          width: Get.width * 1 / 50,
                        ),
                        Container(
                          width: Get.width - Get.width * 0.83 / 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: radius, bottomRight: radius),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffB7C5B9),
                                offset: Offset(0, 0.3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Category : ${globals.punch_issue_Category[0]}'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        'System : ${globals.punch_issue_System[0]}'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        'Subsystem : ${globals.punch_issue_Sub_System[0]}')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  key: _key,
                  height: MediaQuery.of(context).size.height * 4 / 7,
                  color: Color(0xFFE6E6E6),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails td) {
                      setState(() {
                        _getOffset(_key);
                        this.cdx =
                            // td.globalPosition.dx - (this.boxWidth * 0.26);
                            td.globalPosition.dx - 30;
                        this.cdy =
                            // td.globalPosition.dy - (this.boxHeight * 2.63);
                            td.globalPosition.dy - 230;
                        print(td.globalPosition.dx);
                        print([
                          (td.globalPosition.dx - _x) / (Get.width - _x * 2),
                          (td.globalPosition.dy - _y) / (Get.width - _x * 2)
                        ]);
                        double _px =
                            (td.globalPosition.dx - _x) / (Get.width - _x * 2);
                        double _py =
                            (td.globalPosition.dy - _y) / (Get.width - _x * 2);
                        print([
                          double.parse(_px.toStringAsFixed(2)),
                          double.parse(_py.toStringAsFixed(2))
                        ]);

                        if (pixelX.length == 1) {
                          pixelX.removeAt(0);
                          pixelY.removeAt(0);
                          pixelX.add(double.parse(_px.toStringAsFixed(2)));
                          pixelY.add(double.parse(_py.toStringAsFixed(2)));
                        } else {
                          pixelX.add(double.parse(_px.toStringAsFixed(2)));
                          pixelY.add(double.parse(_py.toStringAsFixed(2)));
                        }
                      });
                      print([pixelX, pixelY]);
                    },
                    child: Container(
                      color: Color(0xFFE6E6E6),
                      // padding: EdgeInsets.all(15),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              width:
                                  MediaQuery.of(context).size.width * 90 / 99,
                              height:
                                  MediaQuery.of(context).size.width * 90 / 99,
                              child:
                                  globals.punch_issue_Drawings_File.length == 1
                                      ? Image.file(
                                          globals.punch_issue_Drawings_File[0],
                                          fit: BoxFit.fill,
                                        )
                                      : null),

                          // Image.asset(
                          //   'assets/images/punch_draft_sample.jpg',
                          //   width: MediaQuery.of(context).size.width * 90 / 99,
                          //   height: MediaQuery.of(context).size.height,
                          //   fit: BoxFit.fill,
                          // ),
                          Transform.translate(
                            offset: Offset(cdx, cdy),
                            child: Container(
                              // child: Icon(Icons.add_location_sharp, color: Colors.white,),
                              child: Icon(
                                Icons.add_location_sharp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 20),
          color: Color(0xFFE6E6E6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: buttonWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    primary: Color(0xff71838D), // background
                    // onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel"),
                ),
              ),
              // Container(
              //   width: buttonWidth,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.all(0),
              //       primary: Color(0xff5D8595), // background
              //       // onPrimary: Colors.white, // foreground
              //     ),
              //     onPressed: () {},
              //     child: Text("Clear Location"),
              //   ),
              // ),
              Container(
                width: buttonWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    primary: Color(0xff2F4C5A), // background
                    // onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    globals.punch_issue_Pixel_X = [];
                    globals.punch_issue_Pixel_Y = [];
                    globals.punch_issue_Pixel_cdX = [];
                    globals.punch_issue_Pixel_cdY = [];
                    globals.punch_issue_Pixel_X.add(pixelX[0]);
                    globals.punch_issue_Pixel_Y.add(pixelY[0]);

                    globals.punch_issue_Pixel_cdX.add(cdx - 180);
                    globals.punch_issue_Pixel_cdY.add(cdy - 190);
                    print(
                        "globals.punch_issue_Pixel: ${globals.punch_issue_Pixel_X}");
                    print(
                        "globals.punch_issue_Pixel: ${globals.punch_issue_Pixel_Y}");
                    Get.back();
                  },
                  child: Text("Save Location"),
                ),
              ),
            ],
          ),
        ));
  }
}
