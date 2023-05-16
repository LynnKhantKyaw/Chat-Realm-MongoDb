import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:test_realm/src/constant/atlas_app_id.dart';
import 'package:test_realm/src/feature/chat/domain/message_model.dart';

class ChatRepo {
  Future<Realm> inital() async {
    final appConfig = AppConfiguration(kAtlasAppId);
    final app = App(appConfig);
    final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
    final realm =
        Realm(Configuration.flexibleSync(user, [MessageModel.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(realm.all<MessageModel>());
    });
    return realm;
  }

  Stream<RealmResults<MessageModel>> list() async* {
    final real = await inital();
    yield real.all<MessageModel>();
  }
}

final chatRepoProvider = Provider<ChatRepo>((ref) {
  return ChatRepo();
});

final realmProvider = FutureProvider<Realm>((ref) async {
  return ref.watch(chatRepoProvider).inital();
});

final chatProvider = StreamProvider<RealmResults<MessageModel>>((ref) async* {
  yield* ref.watch(chatRepoProvider).list();
});
