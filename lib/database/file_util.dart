import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/database/SQLiteDbProvider.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory = Directory(appDocDirectory.path + '/' + 'dir');
    // Directory appDocDirectory = await getApplicationDocumentsDirectory();
    if (await directory.exists()) {
      print(directory.path);
      return directory.path;
    }
    final dir = await directory.create(recursive: true);
    return dir.path;
  }

  bool fileExit(String path, String url) {
    String extension = url.substring(url.lastIndexOf("/"));
    File f = File(path + "$extension");
    print(f.absolute.path);
    if (f.existsSync()) {
      return true;
    }
    return false;
  }

  String getFilePath(String path, String url) {
    String extension = url.substring(url.lastIndexOf("/"));
    return "$path/$extension";
  }

  getDeleteDirectory() {
    FileUtil().getDirectoryPath().then((path) {
      final dir = Directory(path);
      dir.deleteSync(recursive: true);
    });
  }

  getClearAllData() {
    getDeleteDirectory();
    SQLiteDbProvider.db.deleteAll();
    SharedManager.instance.deleteToken();
  }

  insertDatabase(BuildContext context, DataPdf dataPdf) {
    SQLiteDbProvider.db.insert(dataPdf);
    UiUtil.showAlert(context, BaseConstant.APPNAME,
        "File downloaded successfully ", null, true);
  }

  Future<String> createImageFromString(
      String thumbnailImageEncoded, String path) async {
    if (thumbnailImageEncoded.isEmpty) {
      return BaseConstant.EMPTY;
    }
    final UriData data = Uri.parse(thumbnailImageEncoded).data!;
    print(data.isBase64);

    Uint8List bytes = base64.decode(thumbnailImageEncoded.split(',').last);
    File file =
        File(path + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  getbyteImage(String image) {
    Uint8List bytes = base64.decode(image.split(',').last);
    //   Uint8List profile = base64.decode(image);
    return bytes;
  }
}
