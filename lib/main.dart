import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hrs/datasource/local_datasource.dart';
import 'package:hrs/datasource/remote_datasource.dart';
import 'package:hrs/domain/usecases/general_usecase.dart';
import 'package:hrs/widgets/screens/add_employee_screen.dart';
import 'package:hrs/widgets/screens/main_screen.dart';

GetIt sl = GetIt.instance;

void main() => runApp(MyApp());

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
    sl.registerSingleton<LocalDatabase>(LocalDatabase('hrs_db.db'), signalsReady: true);
    sl.registerSingleton<RemoteAPI>(RemoteAPI('https://jsoneditoronline.herokuapp.com/v1/docs/259be5399b0b48969aa37372e86cb187'));
    sl.registerSingleton<GeneralUseCase>(GeneralUseCase(db: sl.get<LocalDatabase>(), api: sl.get<RemoteAPI>()));
    super.initState();
  }


  @override
  void dispose() {
    sl.unregister<GeneralUseCase>(disposingFunction: (instance){
      instance.dispose();
    });
    sl.unregister<LocalDatabase>(disposingFunction: (instance){
      instance.dispose();
    });
    sl.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRS',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: { AddEmployeeScreen.route : (context) => AddEmployeeScreen()},
      home: MainScreen(),
    );
  }
}
