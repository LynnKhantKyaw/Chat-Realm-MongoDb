import 'package:realm/realm.dart';
part 'message_model.g.dart';

@RealmModel()
class _MessageModel {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? id;
  String? username;
  String? message;
}
