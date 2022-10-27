import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:tawabel/enums/customer_status_enum.dart';
import 'package:tawabel/enums/customer_type_enum.dart';
import 'package:tawabel/models/abandoned_model.dart';
import 'package:tawabel/models/customer_model.dart';
import 'package:tawabel/models/tawabel_customer_model.dart';

class ExcelUtils {
  static List<String> block = [
    "9660550386348",
    "9660504398809",
    "9660555617711",
  ];
  static getExcelDocument() async {
    try {
      // ByteData data = await rootBundle.load("assets/files/$fileName");
      // var bytes =
      //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // return Excel.decodeBytes(bytes);

      FilePickerResult? file = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (file == null) return null;
      File myFile = File(file.files.single.path!);

      final data = Excel.decodeBytes(await myFile.readAsBytes());

      return data;
    } catch (e) {}
  }

  static readCustomerTable(excel) {
    List<CustomerModel> customers = [];
    try {
      for (var row in excel.rows) {
        if (row[1] == null || row[3] == null) continue;
        customers.add(
          CustomerModel(
            id: 0,
            name: row[1]!.value,
            mobile: row[3]!.value,
            city: row[7]?.value,
            numberOfOrder: int.parse(
              row[10]!.value.toString(),
            ),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }

    return customers;
  }

  /*
  1 phase
  2 name
  4 mobile
  5 productnumber
  6 total
  9 update
  */
  static readAbandonedTable(excel) {
    List<AbandonedModel> customers = [];
    try {
      for (var row in excel.rows) {
        if (row[1] == null || row[4] == null) continue;
        customers.add(
          AbandonedModel(
            id: 0,
            phase: row[1]!.value,
            name: row[2]!.value,
            mobile: row[4]!.value,
            numberOfProduct: row[5]?.value,
            amount: double.parse(
              row[6]!.value.toString(),
            ),
            isSaudi: (row[4]!.value as String).startsWith("966") ? true : false,
            updatedAt: DateTime.parse(row[9]!.value),
            status: CustomerStatusEnum.unknown.name,
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }

    return customers;
  }

  static readTawabelCustomer(excel, CustomerTypeEnum type) {
    DateTime date = DateTime.now();

    List<TawabelCustomerModel> customers = [];
    try {
      for (var row in excel.rows) {
        if (row[1] == null || row[3] == null) continue;

        customers.add(
          TawabelCustomerModel(
            id: 0,
            name: row[1]!.value,
            mobile: row[3]!.value,
            city: row[7]?.value,
            numberOfOrder: int.parse(
              row[10]!.value.toString(),
            ),
            status: CustomerStatusEnum.unknown.name,
            isBlock: block.contains(row[3]!.value),
            type: type.name,
            addedDate: DateTime(date.year, date.month, date.day),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }

    return customers;
  }
}
