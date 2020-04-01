import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hrs/domain/entities/position.dart';
import 'package:hrs/domain/usecases/general_usecase.dart';

class SelectPositionScreen extends StatelessWidget {
  static final String route = '/selectposition';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вакансии'),
      ),
      body: _PositionList(),
    );
  }
}

class _PositionList extends StatefulWidget {
  @override
  __PositionListState createState() => __PositionListState();
}

class __PositionListState extends State<_PositionList>{
  final List<Position> _list = [];

  @override
  void initState() {
    GetIt.I.get<GeneralUseCase>().positions().then((list){
      setState(() {
        _list.clear();
        _list.addAll(list);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _list.isEmpty ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(_list[index].name),
            subtitle: Text('Ставка ${_list[index].salary} рублей в час'),
            onTap: (){
              Navigator.pop<Position>(context, _list[index]);
            },
          );
        },
      ),
    );
  }
}

