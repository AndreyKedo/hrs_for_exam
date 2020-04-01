import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hrs/domain/entities/employee.dart';
import 'package:hrs/domain/entities/event.dart';
import 'package:hrs/domain/enums/event_type.dart';
import 'package:hrs/domain/usecases/general_usecase.dart';
import 'package:hrs/widgets/pages/add_event_dialog.dart';

class EmployeesPage extends StatefulWidget {
  static final String route ='/employees';
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  StreamSubscription _subscription;
  final List<Employee> _list = [];

  @override
  void initState() {
    _subscription = GetIt.I.get<GeneralUseCase>().employees.listen((list){
      setState(() {
        _list.clear();
        _list.addAll(list);
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    GetIt.I.allReady().then((_){
      GetIt.I.get<GeneralUseCase>().getEmployees();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future addEvent(Employee emplEnity) async {
    Map<String, dynamic> eventBundle = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => AddEventDialog(nameEmployee: emplEnity.fio, types: {EventType.BUSY : 'Работает', EventType.VACATION : 'Отпуск', EventType.FIRED : 'Уволен'},)
    );
    if(eventBundle == null)
      return;
    final bundle = Event(
      entity: emplEnity,
      date: eventBundle['d'],
      type: eventBundle['t']
    );
    if(bundle.build())
      GetIt.I.get<GeneralUseCase>().addEvent(bundle);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedSwitcher(
        duration: Duration(
          milliseconds: 300
        ),
        child: _list.isEmpty ? Center(
          child: Text('Список пуст'),
        ) : ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(_list[index].fio),
              subtitle: Text(_list[index].position.name),
              dense: true,
              trailing: PopupMenuButton<int>(
                onSelected: (item){
                  switch(item){
                    case 0:
                      showModalBottomSheet(context: context, builder: (context){
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Text(_list[index].fio, style: Theme.of(context).textTheme.title,),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text('Дата рождения: ${_list[index].dayOfBirth.day}.${_list[index].dayOfBirth.month}.${_list[index].dayOfBirth.year}', style: Theme.of(context).textTheme.subhead,),
                                        Text('Пол: ${_list[index].sex ? 'Мужчина' : 'Женщина'}',style: Theme.of(context).textTheme.subhead,),
                                        Text('Должность ${_list[index].position.name}',style: Theme.of(context).textTheme.subhead,)
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width - 20,
                                    child: FutureBuilder<List<Event>>(
                                      initialData: [],
                                      future: GetIt.I.get<GeneralUseCase>().eventsForEmployee(_list[index].id),
                                      builder: (context, snapshot){
                                        if(snapshot.connectionState == ConnectionState.waiting)
                                          return Container( child: Text('Загрузка данных'), );
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index){
                                            return ListTile(
                                              title: Text('Событие: ${snapshot.data[index].type}'),
                                              subtitle: Text('Время: ${snapshot.data[index].date.day}.${snapshot.data[index].date.month}.${snapshot.data[index].date.year}'),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                      break;
                    case 1:
                      addEvent(_list[index]);
                      break;
                    case 2:
                      GetIt.I.get<GeneralUseCase>().removeEmployee(_list[index]);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(value: 0, child: ListTile(leading: Icon(Icons.assignment, color: Colors.green,), title: Text('Детали'), dense: true,)),
                  PopupMenuItem<int>(value: 1, child: ListTile( leading: Icon(Icons.edit, color: Colors.yellow,), title: Text('Добавить событие'), dense: true,)),
                  PopupMenuItem<int>(value: 2, child: ListTile( leading: Icon(Icons.remove, color: Colors.red,), title: Text('Уволить'), dense: true,)),
                ]
              )
            );
          },
        ),
      ),
    );
  }
}
