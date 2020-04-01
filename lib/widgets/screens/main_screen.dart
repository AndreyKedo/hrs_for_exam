import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hrs/domain/usecases/general_usecase.dart';
import 'package:hrs/widgets/pages/employees_page.dart';
import 'package:hrs/widgets/pages/events_page.dart';
import 'package:hrs/widgets/screens/add_employee_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<_PageNavigationState> nav = GlobalKey<_PageNavigationState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Кадры'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (id) async {
              if(id == 0){
                final result = await Navigator.pushNamed(context, AddEmployeeScreen.route);
                if(result != null)
                  GetIt.I.get<GeneralUseCase>().addEmployee(result);
              }
            },
            itemBuilder: (context){
              return [
                PopupMenuItem<int>(value: 0, child: Text('Зарегестрировать сотрудника'),),
              ];
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Container(
              child: Center(
                child: Text('Обработка сведений по учету работы отдела кадров', softWrap: true,),
              ),
            ),),
            ListTile(
              title: Text('Сотрудники'),
              onTap: (){
                nav.currentState.navigator.currentState.pushNamed(EmployeesPage.route);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('События'),
              onTap: (){
                nav.currentState.navigator.currentState.pushNamed(EventsPage.route);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: PageNavigation(key: nav,),
    );
  }
}

class PageNavigation extends StatefulWidget {
  PageNavigation({Key key}) : super(key: key);
  @override
  _PageNavigationState createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigator,
      onGenerateRoute: (settings){
        if(settings.name == EventsPage.route)
          return MaterialPageRoute(
              builder: (context){
                return EventsPage();
              }
          );
        return MaterialPageRoute(
            builder: (context){
              return EmployeesPage();
            }
        );
      },
    );
  }
}
