import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'TODO APP',
      home:  ListApp()

    );
  }
}
class ListApp extends StatefulWidget {
  @override
  _ListAppState createState() => _ListAppState();
}

class _ListAppState extends State<ListApp> {
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(' EEE d MMM').format(now);
    return Scaffold(

        appBar: AppBar(
          title: Text('TODO for $formattedDate',
            style: TextStyle(color: Colors.black, fontSize: 25),),
          centerTitle: true,

        ),
        body:

        ListView(
          children: <Widget>[

            ListTile(
              leading: Icon(Icons.access_alarms),
              title: Text(' Warm up'),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Check your messages'),
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Head to events list '),
            ),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Its your breakfast'),
            ),

            ListTile(
              leading: Icon(Icons.voice_chat),
              title: Text('Send a voice chat '),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop things'),
            ),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('Friends Lunch'),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Pay Bills'),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Finish your assignments'),
            ),
            ListTile(
              leading: Icon(Icons.tag_faces),
              title: Text('Its Play Time'),
            ),
            ListTile(
              leading: Icon(Icons.signal_cellular_off),
              title: Text('Analyzing Time'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.chat_bubble),
            onPressed: () {
              showDialog(context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Messages',style: TextStyle(fontSize: 30),),
                      content: Text('NO Messages'),
                      actions: <Widget>[
                        FlatButton(

                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                      ],
                    );
                  }
              );
            }
        )


    );
  }


}



