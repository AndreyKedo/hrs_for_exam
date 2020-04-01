# HRS

Экзаменицаионный проект по теме: "Разработка программного комплекса для обработки сведений по учету работы отдела кадров предприятия."

## Функций

- Регистрация сотрудников
- Уволить сотрудников
- Зарегистрировать событие
- Просмотр событий
- Просмотр отчета по сотруднику

## Особенности

Подкгрузка должностей производиться из [удаленного источника][https://jsoneditoronline.org/#left=cloud.259be5399b0b48969aa37372e86cb187]

Данные должны соответсвовать следующему формату
```
    {
      "positions":[
        {"name" : "Преподаватель", "salary": 170},
        {"name" : "Администратор", "salary": 180},
        {"name" : "Уборщик", "salary": 140},
        {"name" : "Охранник", "salary": 120}
      ]
    }
```

### Описание полей
* `positions` массив статусов
* `name` название должности
* `salary` ставка в час

## Описание страниц и экранов

Даллее будут описаны страницы и экраны приложения, и их предназначение.

### Страцница сотрудников

Страница отображает текущих трудоустроенных сотрудников.

![](doc/img/empl.png)

### Страница событий

Страница отображает события произошедшие с сотрудниками за переод их работы
> Устроился, работает, отпуск, уволен

![](doc/img/evp.png)

### Форма регистрации сотрудника

Экран позволяет произвести регисрацию нового сотрудника в системе.

![](doc/img/fre.png)

## Описание функционала

Далее будет продемонстрирован функционал программы и описание.

### Регистраци сотрудника

Форма регистрации содержит следующие поля
* ФИО
* Дата рождения
* Пол
* Должность
> Для выбора должности открывается отдельный экран содержащий список.

![](doc/img/reg.gif)

### Уволить сотрудника

После выполнения операции выбранные сотрудник исчезнит из списка и зарагестрируется событие увольнения.

![](doc/img/rem.gif)

### Регистраци события и просмотр отчета

После нажатия кнопки `Добавить событие` появится дилоговое окно с выбором события.
Для просмотра отчета о сотруднике нажмите кнопку `Детали`.
Отчет содержит основную информацию о сотруднике и его события.

![](doc/img/view.gif)

## Работа с БД

Далее буду продемонстрированы вставки SQL запросов.

### Создание БД

```
CREATE TABLE position (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name TEXT NOT NULL,salary INTEGER NOT NULL)
CREATE TABLE employee (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          fio TEXT NOT NULL,
          day_of_birth INTEGER NOT NULL,
          sex INTEGER NOT NULL,
          remove INTEGER DEFAULT 0,
          id_position INTEGER NOT NULL,
          FOREIGN KEY(id_position) REFERENCES position(id)
CREATE TABLE event (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          type TEXT NOT NULL,
          date INTEGER NOT NULL,
          id_employee INTEGER NOT NULL,
          FOREIGN KEY(id_employee) REFERENCES employee(id)
```

### Выгрузка сотрудников

```
SELECT    employee.id, employee.fio, employee.day_of_birth, employee.sex,
          employee.id_position, position.name, position.salary 
          FROM employee LEFT JOIN position on employee.id_position = position.id WHERE employee.remove = ?
```

### Выгрузка событий 

```
SELECT event.type, event.date, employee.id, 
      employee.fio, employee.day_of_birth, employee.sex,
      position.name, position.salary
      FROM event LEFT JOIN employee on event.id_employee = employee.id 
      LEFT JOIN position on employee.id_position = position.id
```