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
var motor_1 = '';
var motor_2 = '';
var motor_3 = '';
var motor_4 = '';
var motor_5 = '';
var motor_6 = '';

// setting page dropdownButton
var sitesDropdownValue = '';

// cctv page
List cctvs = [];
List cctv_url = [];

// soilControl page
List pumps = [];
List pump_name = [];
List<bool> pumpStatus = [];
List valves = [];
List valve_name = [];
List<bool> valveStatus = [];

List sensors = [];
List sensor_id = []; // pump1, pump2
List sensorStatus = []; // pump1's on/off, pump2's on/off