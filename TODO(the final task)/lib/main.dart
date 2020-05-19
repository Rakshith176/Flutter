
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<String>('tasks');
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  TextEditingController _editControl;
  Box<String> tasksBox;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _editControl= TextEditingController();
    _events = {};
    _selectedEvents = [];
    tasksBox = Hive.box<String>('tasks');
   initPrefs();
   //initialize the flutter local notification plugin
   var initializationSettingsAndroid = new  AndroidInitializationSettings('app_icon');
   var initializationSettingsIOS = new IOSInitializationSettings();
   var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


  }


  Future _noTasks() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New work',
      'You have added a new task..',
      platformChannelSpecifics,
      payload: 'No_sound'


    );
  }

  initPrefs() async {

    // Mapping the date and events present in hive box

    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(decodeMap(json.decode(tasksBox.get("events")??"{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(

        title: Text('TODOs',textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,                                                  //display the calendar view using table calendar property
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.pinkAccent)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events) {
                setState(() {

                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                  //this keeps the current date always highlighted from other dates in the calendar

                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),

      ..._selectedEvents.asMap().entries.map((todo){                              /* Converting the list of mapped dates and events as Map and displaying the events
                                                                                    for a particular date using list tile property */

        int index= todo.key;
        String value = todo.value;
        _showNotification();



         return ListTile(
           title: Text('$index. ${value[0].toUpperCase()}${value.substring(1)}',style:TextStyle(color: Colors.red,fontSize: 20)),


           trailing: Row(
           mainAxisSize: MainAxisSize.min,
             children: <Widget>[
             IconButton(
           icon: Icon(Icons.edit),
           onPressed: () async{
             await  showDialog(
                 context: context,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title: Text('Edit TODO'),
                     content: TextFormField(
                       controller: _editControl,
                     ),
                     actions: <Widget>[
                       FlatButton(
                           onPressed: (){
                             if(_editControl.text.isNotEmpty){
                               //editing the particular task and updating the map and elements present  in the hive box
                               _events[_controller.selectedDay].insert(index, _editControl.text);
                               _events[_controller.selectedDay].removeAt((index+1));
                              state();
                              _editControl.clear();
                             }
                             tasksBox.put("events", json.encode(encodeMap(_events)));
                             Navigator.pop(context);
                           },

                           child: Text('OK')
                       ),
                       FlatButton(
                         child: Text('Cancel'),
                         onPressed: (){
                           Navigator.pop(context);
                         },
                       )

                     ],
                   );
                 }
             );

           }


             ),
          IconButton(
           icon: Icon(Icons.delete),//display the delete icon for a better understanding
           onPressed: () async{
             await showDialog(
                 context: context,
               builder: (BuildContext context){
                   return AlertDialog(
                     title: Text('Are you sure?'),
                     content: Text('Delete $value?'),
                     actions: <Widget>[
                       FlatButton(
                         child: Text('YES'),
                         onPressed: (){
                           //using the removeAt property to remove the task that is no longer needed and updating the hive box again
                           _events[_controller.selectedDay].removeAt(index);
                           state();
                           tasksBox.put("events", json.encode(encodeMap(_events)));
                           Navigator.pop(context);
                         },
                       ),
                       FlatButton(
                         child: Text('NO'),
                         onPressed: ()=>Navigator.pop(context),
                       )
                     ],
                   );
               }
               
             );
           }
         ),
        ],
        )
           );

       

      })


            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        onPressed: _addDialog,

      ),

    );
  }

  _addDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _eventController,
            decoration: InputDecoration(hintText: 'Add your tasks'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Save"),
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                if (_events[_controller.selectedDay] != null) {
                  _events[_controller.selectedDay].add(_eventController.text);
                  _noTasks();
                } else {
                  _events[_controller.selectedDay] = [_eventController.text];
                  _noTasks();
                }
                tasksBox.put("events", json.encode(encodeMap(_events)));
                _eventController.clear();
                Navigator.pop(context);
              },
            )
          ],
        ));
    state();
  }



  _showNotification() async{
    //display this notification if the there is any tasks added for the day before itself
    var time = new Time(8,0, 0);//at 8am
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Hurryy up!!!!',
        'Check if u have any things todo for today',
        time,
        platformChannelSpecifics);
  }
  void state(){
      setState(() {
        _selectedEvents = _events[_controller.selectedDay];

      });



  }




}


