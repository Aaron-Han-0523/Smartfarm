import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/globals/globals.dart' as globals;
import '/globals/punch_continue.dart' as continues;
// import '../punch_screen.dart';

class SuccessButton extends StatefulWidget {
  SuccessButton(
      {Key? key,
      // required this.name,
      required this.buttonname1,
      required this.buttonname2})
      : super(key: key);
  // String name;
  final String buttonname1;
  final String buttonname2;

  @override
  _SuccessButtonState createState() => _SuccessButtonState();
}

class _SuccessButtonState extends State<SuccessButton> {
  @override
  Widget build(BuildContext context) {
    var buttonWidth = Get.width * 1 / 3.0;
    return Container(
      color: Color(0xFFffffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff71838D),
              ),
              onPressed: () {
                continues.punch_issue_Tag_Number = [];
                continues.punch_issue_Bulk_Item = [];
                continues.punch_issue_Bulk_Name = [];
                continues.punch_issue_Category = [];
                continues.punch_issue_System = [];
                continues.punch_issue_Sub_System = [];
                continues.punch_issue_Unit = [];
                continues.punch_issue_Area = [];
                continues.punch_issue_Punch_ID = [];
                continues.punch_issue_Description = [];
                continues.punch_issue_Action_On = [];
                continues.punch_issue_Discipline = [];
                continues.punch_issue_Raised_On = [];
                continues.punch_issue_Date = [];
                continues.punch_issue_Keyword = [];
                continues.punch_issue_Design = [];
                continues.punch_issue_Material = [];
                continues.punch_issue_Photo = [];
                continues.punch_issue_Photo_Path = [];
                continues.punch_issue_Photo_Name = [];
                continues.punch_issue_Drawings = [];
                continues.punch_issue_Drawings_File = [];
                continues.punch_issue_Pixel_X = [];
                continues.punch_issue_Pixel_Y = [];
                continues.punch_issue_Switch = [];
                continues.punch_issue_Status = [];
                continues.punch_issue_Issued_Date = [];
                Get.offAllNamed('/home');
              },
              child: Text(widget.buttonname1),
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff2F4C5A), // background
                // onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                continues.punch_issue_Tag_Number = [];
                continues.punch_issue_Bulk_Item = [];
                continues.punch_issue_Bulk_Name = [];
                continues.punch_issue_Category = [];
                continues.punch_issue_System = [];
                continues.punch_issue_Sub_System = [];
                continues.punch_issue_Unit = [];
                continues.punch_issue_Area = [];
                continues.punch_issue_Punch_ID = [];
                continues.punch_issue_Description = [];
                continues.punch_issue_Action_On = [];
                continues.punch_issue_Discipline = [];
                continues.punch_issue_Raised_On = [];
                continues.punch_issue_Date = [];
                continues.punch_issue_Keyword = [];
                continues.punch_issue_Design = [];
                continues.punch_issue_Material = [];
                continues.punch_issue_Photo = [];
                continues.punch_issue_Photo_Path = [];
                continues.punch_issue_Photo_Name = [];
                continues.punch_issue_Drawings = [];
                continues.punch_issue_Drawings_File = [];
                continues.punch_issue_Pixel_X = [];
                continues.punch_issue_Pixel_Y = [];
                continues.punch_issue_Switch = [];
                continues.punch_issue_Status = [];
                continues.punch_issue_Issued_Date = [];

                globals.punch_issue_Category.length == 1
                    ? continues.punch_issue_Category
                        .add(globals.punch_issue_Category[0])
                    : continues.punch_issue_Category.add(null);
                globals.punch_issue_System.length == 1
                    ? continues.punch_issue_System
                        .add(globals.punch_issue_System[0])
                    : continues.punch_issue_System.add(null);
                globals.punch_issue_Sub_System.length == 1
                    ? continues.punch_issue_Sub_System
                        .add(globals.punch_issue_Sub_System[0])
                    : continues.punch_issue_Sub_System.add(null);
                globals.punch_issue_Discipline.length == 1
                    ? continues.punch_issue_Discipline
                        .add(globals.punch_issue_Discipline[0])
                    : continues.punch_issue_Discipline.add(null);
                globals.punch_issue_Status.length == 1
                    ? continues.punch_issue_Status
                        .add(globals.punch_issue_Status[0])
                    : continues.punch_issue_Status.add(null);
                globals.punch_issue_Unit.length == 1
                    ? continues.punch_issue_Unit
                        .add(globals.punch_issue_Unit[0])
                    : continues.punch_issue_Unit.add(null);
                globals.punch_issue_Area.length == 1
                    ? continues.punch_issue_Area
                        .add(globals.punch_issue_Area[0])
                    : continues.punch_issue_Area.add(null);
                globals.punch_issue_Tag_Number.length == 1
                    ? continues.punch_issue_Tag_Number
                        .add(globals.punch_issue_Tag_Number[0])
                    : continues.punch_issue_Tag_Number.add(null);
                globals.punch_issue_Bulk_Item.length == 1
                    ? continues.punch_issue_Bulk_Item
                        .add(globals.punch_issue_Bulk_Item[0])
                    : continues.punch_issue_Bulk_Item.add(null);
                globals.punch_issue_Bulk_Name.length == 1
                    ? continues.punch_issue_Bulk_Name
                        .add(globals.punch_issue_Bulk_Name[0])
                    : continues.punch_issue_Bulk_Name.add(null);
                globals.punch_issue_Action_On.length == 1
                    ? continues.punch_issue_Action_On
                        .add(globals.punch_issue_Action_On[0])
                    : continues.punch_issue_Action_On.add(null);
                globals.punch_issue_Date.length == 1
                    ? continues.punch_issue_Date
                        .add(globals.punch_issue_Date[0])
                    : continues.punch_issue_Date.add(null);
                globals.punch_issue_Issued_Date.length == 1
                    ? continues.punch_issue_Issued_Date
                        .add(globals.punch_issue_Issued_Date[0])
                    : continues.punch_issue_Issued_Date.add(null);
                globals.punch_issue_Raised_On.length == 1
                    ? continues.punch_issue_Raised_On
                        .add(globals.punch_issue_Raised_On[0])
                    : continues.punch_issue_Raised_On.add(null);
                globals.punch_issue_Design.length == 1
                    ? continues.punch_issue_Design
                        .add(globals.punch_issue_Design[0])
                    : continues.punch_issue_Design.add(null);
                globals.punch_issue_Keyword.length > 0
                    ? continues.punch_issue_Keyword =
                        globals.punch_issue_Keyword
                    : continues.punch_issue_Keyword = [];
                globals.punch_issue_Material.length == 1
                    ? continues.punch_issue_Material
                        .add(globals.punch_issue_Material[0])
                    : continues.punch_issue_Material.add(null);
                globals.punch_issue_Description.length == 1
                    ? continues.punch_issue_Description
                        .add(globals.punch_issue_Description[0])
                    : continues.punch_issue_Description.add(null);
                print(continues.punch_issue_Unit);
                Get.toNamed('/punchList');
              },
              child: Text(widget.buttonname2),
            ),
          ),
        ],
      ),
    );
  }
}
