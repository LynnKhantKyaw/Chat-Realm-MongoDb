import 'package:realm/realm.dart';
import 'package:test_realm/src/feature/chat/domain/message_model.dart';

class MessageRepoModel {
  final RealmResults<MessageModel> realmResults;
  final Realm realm;
  MessageRepoModel({required this.realmResults, required this.realm});
}
