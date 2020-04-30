
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:hive_flutter/hive_flutter.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<String>('tasks');
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'TODO APP',
      home:ListApp(),
    );
  }
}
class ListApp extends StatefulWidget {
  @override
  _ListAppState createState() => _ListAppState();

}

class _ListAppState extends State<ListApp> {
  Box<String> tasksBox;
  TextEditingController _controller = TextEditingController();
  TextEditingController _order= TextEditingController();


  void initState() {
    super.initState();
    tasksBox = Hive.box<String>('tasks');

  }


  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); //function implemented for present date to be displayed
    String formattedDate = DateFormat(' EEE d MMM').format(now);
    return Scaffold(

      appBar: AppBar(
        title: Text('TODO for $formattedDate',
          style: TextStyle(color: Colors.black, fontSize: 25),),
        centerTitle: true,

      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ValueListenableBuilder(
                valueListenable: tasksBox.listenable(),
                builder: (context, Box<String> tasks, _){
                  return ListView.separated(
                      itemBuilder: (context, index){
                        final key = tasks.keys.toList()[index];
                        final value = tasks.get(key);

                        return ListTile(
                          title: Text('$value', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                          subtitle: Text('$key', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: <Widget>[
                             IconButton(icon: Icon(Icons.delete),
                                 onPressed:(){
                               tasksBox.deleteAt(index);
                             },
                             )


                           ],
                         ),
                        );
                      },
                      separatorBuilder:(_, index) => Divider(),
                      itemCount: tasks.keys.toList().length
                  );
                },
              )
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text('ADD Tasks'),
                  onPressed: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(hintText: 'Enter the order of the task',
                                        suffixIcon: IconButton(
                                          onPressed: ()=> _order.clear(),
                                          icon: Icon(Icons.clear),)),
                                    keyboardType: TextInputType.numberWithOptions(),
                                    controller: _order,
                                  ),
                                  SizedBox(height: 15,),
                                  TextField(
                                    decoration: InputDecoration(hintText: 'Enter the Task',
                                        suffixIcon: IconButton(
                                          onPressed: ()=> _controller.clear(),
                                          icon: Icon(Icons.clear),)),
                                    controller: _controller,
                                  ),
                                  SizedBox(height: 15,),
                                  FlatButton
                                    (
                                      onPressed: (){
                                        final value=_controller.text;
                                        final key = _order.text;
                                        tasksBox.put(key,value);

                                        Navigator.pop(context);

                                      },
                                      child: Text('ADD')
                                  )

                                ],
                              ),
                            ),
                          );
                        }

                    );
                  },
                )



              ],
            ),
          )
        ],
      ),

    );
  }
}







