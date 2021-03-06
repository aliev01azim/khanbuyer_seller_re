import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:path_provider/path_provider.dart';

import 'controllers/all_bindings.dart';
import 'controllers/orders_controller.dart';
import 'helpers/local_notification_service.dart';
import 'screens/drawers_screens/account/account.dart';
import 'screens/drawers_screens/my_shop_screen/my_shop_screen.dart';
import 'screens/drawers_screens/orders_screen/orders_screen.dart';
import 'screens/home_screen.dart';
import 'screens/start_screens/slider_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await openHiveBox('userBox');
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  Get.put<ProductsController>(ProductsController());
  Get.put<OrdersController>(OrdersController());
  runApp(const MyApp());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  if (limit) {
    final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/$boxName.hive');
      final File lockFile = File('$dirPath/$boxName.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
    // clear box if it grows large
    if (box.length > 1000) {
      box.clear();
    }
  } else {
    await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/$boxName.hive');
      final File lockFile = File('$dirPath/$boxName.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);

    ///gives  the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["routeName"];

        Get.toNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["routeName"];

      Get.toNamed(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Hive.box('userBox').get('user', defaultValue: {});
    return GetMaterialApp(
      title: 'Khunbuyer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),

      debugShowCheckedModeBanner: false,
      routes: {
        '/catalog': (ctx) => MyShopScreen(),
        '/orders': (ctx) => OrdersScreen(),
        '/account': (ctx) => Account(),
      },
      // ignore: unnecessary_null_comparison
      home: user.isEmpty ? const StartScreen() : SellerScreen(),
      initialBinding: AuthBinding(),
    );
  }
}
