import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_realm/src/feature/auth/presentation/login.dart';
import 'package:test_realm/src/feature/chat/domain/model.dart';
import 'package:test_realm/src/router/go_router.dart';

final newRealmProvider = StateProvider<Realm?>((ref) {
  return null;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
  container.read(userNameProvider.notifier).state =
      prefs.getString('user_name') ?? '';
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'Za Flutter Developer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: goRouter,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RealmResults<Person> allItems;
  late Realm realm;

  inital() async {
    final app = App(AppConfiguration('application-1-gnyko'));
    final user = await app.logIn(Credentials.anonymous());
    print('sdfds');
    realm = Realm(Configuration.flexibleSync(user, [Person.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(realm.all<Person>());
    });
    allItems = realm.all<Person>();
    setState(() {});
  }

  @override
  void initState() {
    inital();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: allItems.changes,
          builder: (context, snapShot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var i in allItems)
                  Row(
                    children: [
                      Text(i.name),
                      Text(i.age),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          realm.write(() {
                            i.name = 'Phat Htoke';
                            i.age = 'lynn khant';
                          });
                        },
                        child: const Icon(Icons.edit),
                      ),
                      InkWell(
                        onTap: () {
                          realm.write(() => realm.delete(i));
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int i = 1;
          i++;
          setState(() {});
          realm.write(() =>
              realm.add(Person(i, 'Pyae Hmue Hay Marn (Phat Htoke)', '20')));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
