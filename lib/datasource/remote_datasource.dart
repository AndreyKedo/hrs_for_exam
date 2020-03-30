import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hrs/domain/entities/position.dart';
import 'package:http/http.dart';

enum Error{
  NETWORK,
  RESOURCE
}

class RemoteAPI{
  RemoteAPI(this.url);
  final String url;

  Future<List<Position>> getPosition() async {
    try{
      final result = await get(url);
      final Map<String, dynamic> subData = jsonDecode(utf8.decode(result.body.codeUnits));
      final Map<String, dynamic> data = jsonDecode(subData['data']);
      return Future.value(data['positions'].map<Position>((item) => Position.fromMap(item)).toList());
    } on TimeoutException{
      return Future<List<Position>>.error(Error.RESOURCE);
    } on SocketException {
      return Future<List<Position>>.error(Error.NETWORK);
    }
  }
}