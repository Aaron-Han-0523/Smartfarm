import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* name : ListComponent Page
* description : ListComponent page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ListComponent extends StatelessWidget {
  ListComponent({
    Key? key,
    this.nums,
    required this.title,
    required this.data1,
    required this.data2,
    required this.colors,
  }) : super(key: key);

  final int colors;
  final String title;
  final String data1;
  final String data2;
  final int? nums;
  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    return Row(
      children: [
        Container(
          // color: Colors.red,
          height: MediaQuery.of(context).size.height * 1.14 / 8,

          // width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 5, bottom: 10, right: 10),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 1.14 / 8,
                  width: Get.width * 1 / 50,
                  decoration: BoxDecoration(
                    color: Color(colors),
                    borderRadius:
                        BorderRadius.only(topLeft: radius, bottomLeft: radius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height * 1 / 8,
                  width: MediaQuery.of(context).size.width - Get.width * 1 / 13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: radius, bottomRight: radius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Color(colors),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        _boxsize(),
                        Text(data1),
                        _boxsize(),
                        Text(
                          data2,
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                          // softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 높이 10 박스
  Widget _boxsize() {
    return SizedBox(
      height: 10,
    );
  }
}
