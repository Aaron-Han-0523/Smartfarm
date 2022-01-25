/*
* name : globals
* description : punch issue globals page.
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

library edgeworks.globals;

// site id
var siteId = '';

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

List chartData = [];

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
List<int> pumpStatus = []; // DB에 저장된 pump status 가져오기
List valves = [];
List valve_name = [];
List<int> valveStatus = []; // DB에 저장된 valve status 가져오기

List sensors = [];
List sensor_id = []; // pump1, pump2
List sensorStatus = []; // pump1's on/off, pump2's on/off

// environment control page
List<dynamic> sideMotors = [];
List<dynamic> topMotors = [];
List<dynamic> etcMotors = [];

// List motors = [];

// DB에 저장된 motor name 측창(전)
List top_motor_name = [];
List side_motor_name = [];
List etc_motor_name = [];

// mqtt의 motor_id key 담기
List motor_id = [];
// DB에 저장된 side motor id 담기
List side_motor_id = [];
// DB에 저장된 top motor id 담기
List top_motor_id = [];

// mqtt 통신을 위한 DB에 저장된 motor_id값 파싱
List topMotorId = [];
List sideMotorId = [];
List etcMotorId = [];

// mqtt 상에 motor 상태 값 담기
List<int> mqttTopMotorStatus = [];
List<int> mqttSideMotorStatus = [];

//DB에서 motor 상태 불러오기
List<int> topMotorStatus = [];
List<int> sideMotorStatus = [];
List<int> etcMotorStatus = [];

List switchs = [];
List switch_id = [];
List<bool> switchStatus = [];
