import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:test_realm/src/constant/atlas_app_id.dart';
import 'package:test_realm/src/feature/auth/presentation/login.dart';
import 'package:test_realm/src/feature/chat/domain/message_model.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  late RealmResults<MessageModel> realmResults;
  late Realm realm;

  final messageController = TextEditingController();

  void _inital() async {
    final appConfig = AppConfiguration(kAtlasAppId);
    final app = App(appConfig);
    final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
    realm = Realm(Configuration.flexibleSync(user, [MessageModel.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(realm.all<MessageModel>());
    });
    realmResults = realm.all<MessageModel>();
    setState(() {});
  }

  @override
  void initState() {
    _inital();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userNameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Za Developer Group'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: realmResults.changes,
                builder: (context, snapShot) {
                  return ListView.separated(
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      if (username == realmResults[index].username) {
                        return RightMessageBox(
                          username: realmResults[index].username ?? '',
                          message: realmResults[index].message ?? '',
                          deleteOnTap: () {
                            _deleteMessage(messageModel: realmResults[index]);
                          },
                        );
                      } else {
                        return LeftMessageBox(
                            username: realmResults[index].username ?? '',
                            message: realmResults[index].message ?? '');
                      }
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: realmResults.length,
                  );
                }),
          ),
          MessageSendWidget(
            messageController: messageController,
            sendOnTap: () {
              _sendMessage(username: username ?? '');
            },
          ),
        ],
      ),
      // bottomNavigationBar: MessageSendWidget(
      //   messageController: messageController,
      //   sendOnTap: () {
      //     _sendMessage(username: username ?? '');
      //   },
      // ),
    );
  }

  void _sendMessage({required String username}) {
    if (messageController.text.isNotEmpty) {
      realm.write(() => realm.add(MessageModel(
            ObjectId(),
            message: messageController.text,
            username: username,
          )));
      messageController.clear();
    }
  }

  void _deleteMessage({required MessageModel messageModel}) {
    realm.write(() => realm.delete(messageModel));
    Navigator.pop(context);
  }
}

class RightMessageBox extends StatelessWidget {
  const RightMessageBox(
      {super.key,
      required this.message,
      required this.deleteOnTap,
      required this.username});

  final String message;
  final String username;
  final GestureTapCallback deleteOnTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Delete Message',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                            onPressed: deleteOnTap,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  //color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                Text('Delete'),
                              ],
                            ))
                      ],
                    ),
                  ),
                ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(right: 10, left: 100),
                //  width: 300,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 193, 216, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Text(message),
              ),
            ],
          ),
          if (username.isNotEmpty)
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: Text(
                  username,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ))
        ],
      ),
    );
  }
}

class LeftMessageBox extends StatelessWidget {
  const LeftMessageBox(
      {super.key, required this.message, required this.username});

  final String message;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 100, left: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 193, 216, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(message),
            ),
          ],
        ),
        if (username.isNotEmpty)
          Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                username,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ))
      ],
    );
  }
}

class MessageSendWidget extends StatelessWidget {
  const MessageSendWidget(
      {super.key, required this.messageController, required this.sendOnTap});

  final TextEditingController messageController;

  final GestureTapCallback? sendOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field can\'t be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: 'Message',
                  border: OutlineInputBorder(
                      gapPadding: 0, borderRadius: BorderRadius.circular(10)),
                  isDense: true),
            ),
          ),
          IconButton(
            onPressed: sendOnTap,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
