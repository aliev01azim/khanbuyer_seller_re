import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Map user = Hive.box('userBox').get('user', defaultValue: {});
// Future<void> sessionSavePartOfBox(
//     String boxName, String key, dynamic data) async {
//   if (!await Hive.boxExists(boxName)) {
//     await Hive.openBox(boxName).onError((error, stackTrace) async {
//       final Directory dir = await getApplicationDocumentsDirectory();
//       final String dirPath = dir.path;
//       final File dbFile = File('$dirPath/$boxName.hive');
//       final File lockFile = File('$dirPath/$boxName.lock');
//       await dbFile.delete();
//       await lockFile.delete();
//       await Hive.openBox(boxName);
//       throw 'Failed to open $boxName Box\nError: $error';
//     });
//   }
//   if (boxName == 'userBox') {
//     await Hive.box<dynamic>(boxName).put(user[key], data);
//   } else {
//     await Hive.box<dynamic>(boxName).put(key, data);
//   }
// }

Future<void> sessionSaveUser(dynamic data) async {
  if (!await Hive.boxExists('userBox')) {
    await Hive.openBox('userBox').onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/userBox.hive');
      final File lockFile = File('$dirPath/userBox.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox('userBox');
      throw 'Failed to open userBox Box\nError: $error';
    });
  }
  await Hive.box<dynamic>('userBox').put('user', data);
}
