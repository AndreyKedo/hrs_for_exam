import 'package:flutter_test/flutter_test.dart';
import 'package:hrs/datasource/remote_datasource.dart';

void main() {
  test('Get positions', () async{
    RemoteAPI api = RemoteAPI('https://jsoneditoronline.herokuapp.com/v1/docs/259be5399b0b48969aa37372e86cb187');
    final data = await api.getPosition();
    expect(data != null, true);
    print(data);
  });
}
