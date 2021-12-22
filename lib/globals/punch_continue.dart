library plms.continues;

/*
* name : punch_continue
* description : punch issue globals continue page.
* writer : walter
* create date : 2021-10-18
* last update : 2021-10-20
* */

// first page
bool punch_issue_isTag = true;
bool punch_issue_isBulk = false;

List punch_issue_Tag_Number = [];
List punch_issue_Bulk_Item = [];
List punch_issue_Bulk_Name = [];
List punch_issue_Category = [];
List punch_issue_System = [];
List punch_issue_Sub_System = [];
List punch_issue_Unit = [];
List punch_issue_Area = [];
List punch_issue_Punch_ID = [];
List punch_issue_Description = [];

// second page
List punch_issue_Action_On = [];
List punch_issue_Discipline = [];
List punch_issue_Raised_On = [];
List punch_issue_Date = [];
List punch_issue_Keyword = [];
List punch_issue_Design = [];
List punch_issue_Material = [];

// third page
List punch_issue_Photo = [];
List punch_issue_Photo_Path = [];
List punch_issue_Photo_Name = [];
List punch_issue_Drawings = [];
List punch_issue_Drawings_File = [];
List punch_issue_Pixel_X = [];
List punch_issue_Pixel_Y = [];
List punch_issue_Switch = [];

// status
List punch_issue_Status = [];
List punch_issue_Issued_Date = [];
