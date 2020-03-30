import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//https://jsoneditoronline.herokuapp.com/v1/docs/259be5399b0b48969aa37372e86cb187

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application();
  }
}

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
