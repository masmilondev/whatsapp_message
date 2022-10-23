import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox?> create() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      appDocDir.createSync();

      String tawabelPath = '$appDocPath/tawabel';
      Directory(tawabelPath).createSync();

      // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
      final store = await openStore(directory: tawabelPath);
      return ObjectBox._create(store);
    } catch (e) {
      print(e);
    }
  }
}
