import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hrs/domain/entities/event.dart';
import 'package:hrs/domain/usecases/general_usecase.dart';

class EventsPage extends StatefulWidget {
  static final String route = '/events';
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  StreamSubscription<List<Event>> _subscription;
  final List<Event> _list = [];

  @override
  void initState() {
    GetIt.I.allReady().then((_) async {
      _subscription = GetIt.I.get<GeneralUseCase>().events.listen((list){
        setState(() {
          _list.clear();
          _list.addAll(list);
        });
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    GetIt.I.allReady().then((_){
      GetIt.I.get<GeneralUseCase>().getEvents();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _list.isEmpty ? Center(
        child: Text('Список пуст'),
      ) : ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text('Событие: ${_list[index].type}'),
            subtitle: Text('Время: ${_list[index].date.day}.${_list[index].date.month}.${_list[index].date.year}'),
            trailing: Text('Сотрудник: ${_list[index].entity.fio}'),
          );
        },
      ),
    );
  }
}
