import 'package:realm/realm.dart';
part 'model.g.dart';

@RealmModel()
class _Person {
  @PrimaryKey()
  @MapTo('_id')
  late int id;
  late String name;
  late String age;
}
