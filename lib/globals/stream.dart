/*
* name : globals
* description : punch issue globals page.
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

library plms.globals;

// first page

var temp_1 = '';
var humid_1 = '';
var exttemp_1 = '';
var soiltemp_1 = '';
var soiltemp_2 = '';
var soilhumid_1 = '';
var soilhumid_2 = '';
var pump_1 = '';
var pump_2 = '';
var valve_1 = '';
var valve_2 = '';
var motor_1 = '';
var motor_2 = '';
var motor_3 = '';
var motor_4 = '';
var motor_5 = '';
var motor_6 = '';

var alarm_en = '';
var alarm_high_temp = '';
var alarm_low_temp = '';
var watering_timer = '';

// setting page dropdownButton
String sitesDropdownValue = '';

// main page fcm Token
String fcmtoken = '';

// cctv page
List cctvs = [];
List cctv_url = [];

// soilControl page
List pumps = [];
List pump_name = [];
List<int> pumpStatus = [];
List valves = [];
List valve_name = [];
List<int> valveStatus = [];

List sensors = [];
List sensor_id = []; // pump1, pump2
List sensorStatus = []; // pump1's on/off, pump2's on/off

// environment control page
List<dynamic> sideMotors = [];
List<dynamic> topMotors = [];
List motors = [];
List motor_name = [];
List<int> motorStatus = [];

List switchs = [];
List switch_id = [];
List<bool> switchStatus = [];
