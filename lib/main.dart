import 'dart:async';
import 'package:flutter/material.dart';
import 'Service.dart';
import 'User.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: SixScreen()
    );
  }
}

class SixScreen extends StatefulWidget {
  @override
  _SixScreennState createState() => _SixScreennState();
}

final String url = "https://gist.githubusercontent.com/aws1994/f583d54e5af8e56173492d3f60dd5ebf/raw/c7796ba51d5a0d37fc756cf0fd14e54434c547bc/anime.json";

class Debouncer {
  final int miliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.miliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(microseconds: miliseconds), action);
  }
}

class _SixScreennState extends State<SixScreen> {
  final _debouncer = Debouncer(miliseconds: 2000);
  List<User> users = List();
  List<User> filterUser = List();

  @override
  void initState() {
    super.initState();
    Service.getUsers().then((usersFromServer) {
      setState(() {
        users = usersFromServer;
      });
    });
  }

  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text('Filter list');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appBarTitle,
        elevation: 2,
        centerTitle: true,
        // leading: Icon(Icons.search),
        brightness: Brightness.dark,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      scrollPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      onChanged: (string) {
                        _debouncer.run(() {
                          setState(() {
                            filterUser = users
                                .where((u) =>
                                    (u.name
                                        .toLowerCase()
                                        .contains(string.toLowerCase())) ||
                                    u.name
                                        .toLowerCase()
                                        .contains(string.toLowerCase()))
                                .toList();
                          });
                        });
                      },
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                        // prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: 'search... ',
                        hintStyle: new TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text('Filter List');
                  }
                });
              })
        ],
        titleSpacing: 2.0,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filterUser = users
                      .where((u) =>
                          (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase())) ||
                          u.name.toLowerCase().contains(string.toLowerCase()))
                      .toList();
                });
              });
            },
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                hintText: 'Enter text to search'),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filterUser.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          filterUser[index].name,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          filterUser[index].email.toLowerCase(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
