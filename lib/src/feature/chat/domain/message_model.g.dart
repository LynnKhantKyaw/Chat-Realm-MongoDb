// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class MessageModel extends _MessageModel
    with RealmEntity, RealmObjectBase, RealmObject {
  MessageModel(
    ObjectId? id, {
    String? username,
    String? message,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'message', message);
  }

  MessageModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get username =>
      RealmObjectBase.get<String>(this, 'username') as String?;
  @override
  set username(String? value) => RealmObjectBase.set(this, 'username', value);

  @override
  String? get message =>
      RealmObjectBase.get<String>(this, 'message') as String?;
  @override
  set message(String? value) => RealmObjectBase.set(this, 'message', value);

  @override
  Stream<RealmObjectChanges<MessageModel>> get changes =>
      RealmObjectBase.getChanges<MessageModel>(this);

  @override
  MessageModel freeze() => RealmObjectBase.freezeObject<MessageModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MessageModel._);
    return const SchemaObject(
        ObjectType.realmObject, MessageModel, 'MessageModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('username', RealmPropertyType.string, optional: true),
      SchemaProperty('message', RealmPropertyType.string, optional: true),
    ]);
  }
}
