import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tawabel/data_provider/objectBox.dart';
import 'package:tawabel/enums/customer_status_enum.dart';
import 'package:tawabel/enums/customer_type_enum.dart';
import 'package:tawabel/enums/filter_enums.dart';
import 'package:tawabel/models/abandoned_model.dart';
import 'package:tawabel/models/customer_model.dart';
import 'package:tawabel/models/tawabel_customer_model.dart';
import 'package:tawabel/objectbox.g.dart';
import 'package:tawabel/utils/excel_utils.dart';

import 'package:http/http.dart' as http;

class ExcelManipulationBloc extends ChangeNotifier {
  String baseURL = "http://127.0.0.1:4000";
  String excelFileName = "customers.xlsx";
  String customerSheetName = "Sheet1";
  List<CustomerModel> customers = [];
  List<AbandonedModel> abandoned = [];
  List<CustomerModel> _filteredCustomers = [];
  List<String> block = [];
  var excelFile;
  String? _status;
  bool? isCustomer;

  String? filterBy;

  void setFilterBy(String? filterBy) {
    this.filterBy = filterBy;
    notifyListeners();
  }

  String? customerStatus;

  void setCustomerStatus(String? customerStatus) {
    this.customerStatus = customerStatus;
    notifyListeners();
  }

  bool _spinner = false;
  bool get getSpinner => _spinner;

  void _spinnerOn() {
    _spinner = true;
    notifyListeners();
  }

  void _spinnerOff() {
    _spinner = false;
    notifyListeners();
  }

  Future<dynamic>? spinner(callBackFunc) async {
    _spinnerOn();
    var response = await callBackFunc;
    _spinnerOff();
    return response;
  }

  String? get status => _status;

  void setStatus(String x) {
    _systemStatus = x;
    notifyListeners();
  }

  List<CustomerModel> get getFilteredCustomer => _filteredCustomers;

  Future<bool> setExcelFile() async {
    excelFile = await ExcelUtils.getExcelDocument();
    if (excelFile != null) {
      setStatus("File is okay. Select Read data");
      return true;
    } else {
      setStatus("File is not okay. Please, check the file.");
      return false;
    }
  }

  Future<bool> readCustomers() async {
    customers =
        await ExcelUtils.readCustomerTable(excelFile[customerSheetName]);
    if (customers.isNotEmpty) {
      setStatus("Total ${customers.length} found");
      return true;
    }
    return false;
  }

  Future<bool> readAbandoned() async {
    abandoned =
        await ExcelUtils.readAbandonedTable(excelFile[customerSheetName]);
    if (abandoned.isNotEmpty) {
      setStatus("Total ${abandoned.length} found");
      return true;
    }
    return false;
  }

  saveCustomers() async {
    var directory = await getApplicationDocumentsDirectory();

    final _myFile = File('${directory.path}/xxxx.json');

    _myFile.writeAsStringSync(
        jsonEncode(customers.map((e) => e.toJson()).toList()));
  }

  Future<void> saveBatch(Map<String, List<CustomerModel>> lists) async {
    var directory = await getApplicationDocumentsDirectory();

    for (var name in lists.keys) {
      final _myFile = File('${directory.path}/$name.json');

      if (lists[name] != null && lists[name]!.isNotEmpty) {
        _myFile.writeAsStringSync(
            jsonEncode(lists[name]!.map((e) => e.toJson()).toList()));
      }
    }
  }

  Future<String> filterAll() async {
    Map<String, List<CustomerModel>> list = {
      FilterEnums.zeroInMadina.name: [],
      FilterEnums.zeroOutMadina.name: [],
      FilterEnums.oneTwoInMadina.name: [],
      FilterEnums.oneTwoOutMadina.name: [],
      FilterEnums.threeFourInMadina.name: [],
      FilterEnums.threeFourOutMadina.name: [],
      FilterEnums.fivePlusInMainda.name: [],
      FilterEnums.fivePlusOutMainda.name: [],
      FilterEnums.unKnownOrderMadina.name: [],
      FilterEnums.unKnownOrderOutMadinah.name: [],
    };
    for (var item in customers) {
      if (item.numberOfOrder == null && item.city == "Madinah") {
        list[FilterEnums.unKnownOrderMadina.name]!.add(item);
      }

      if (item.numberOfOrder == 0 && item.city == "Madinah") {
        list[FilterEnums.zeroInMadina.name]!.add(item);
      }

      if ((item.numberOfOrder == 1 || item.numberOfOrder == 2) &&
          item.city == "Madinah") {
        list[FilterEnums.oneTwoInMadina.name]!.add(item);
      }

      if ((item.numberOfOrder == 3 || item.numberOfOrder == 4) &&
          item.city == "Madinah") {
        list[FilterEnums.threeFourInMadina.name]!.add(item);
      }

      if (item.numberOfOrder! > 4 && item.city == "Madinah") {
        list[FilterEnums.fivePlusInMainda.name]!.add(item);
      }

      if (item.numberOfOrder == null && item.city != "Madinah") {
        list[FilterEnums.unKnownOrderOutMadinah.name]!.add(item);
      }

      if (item.numberOfOrder == 0 && item.city != "Madinah") {
        list[FilterEnums.zeroOutMadina.name]!.add(item);
      }

      if ((item.numberOfOrder == 1 || item.numberOfOrder == 2) &&
          item.city != "Madinah") {
        list[FilterEnums.oneTwoOutMadina.name]!.add(item);
      }

      if ((item.numberOfOrder == 3 || item.numberOfOrder == 4) &&
          item.city != "Madinah") {
        list[FilterEnums.threeFourOutMadina.name]!.add(item);
      }

      if (item.numberOfOrder! > 4 && item.city != "Madinah") {
        list[FilterEnums.fivePlusOutMainda.name]!.add(item);
      }
    }
    await saveBatch(list);

    return "Saved";
  }

  // ***************************** Search functionality **************************
  String _selectedStatus = "";
  String _selectedFilter = "";

  setSelectedStatus(String x) {
    _selectedStatus = x;
    notifyListeners();
  }

  setSelectedFilter(String x) {
    _selectedFilter = x;
    notifyListeners();
  }

  String get selectedStatus => _selectedStatus;
  String get selectedFilter => _selectedFilter;

  // ************************** OBJECTBOX FUNCTIONALITY *************************
  late ObjectBox objectBox;
  late final Box<CustomerModel> itemModelBox;
  late final Box<TawabelCustomerModel> tawabelCustomerModelBox;
  late final Box<AbandonedModel> abandonedModelBox;
  List<CustomerModel> dbCustomers = [];

  setObjectBox(ObjectBox? objectBox) {
    if (objectBox == null) return;
    objectBox = objectBox;

    // itemModelBox = Box<CustomerModel>(objectBox.store);
    tawabelCustomerModelBox = Box<TawabelCustomerModel>(objectBox.store);
    abandonedModelBox = Box<AbandonedModel>(objectBox.store);
  }

  void addItem(CustomerModel customerModel) {
    itemModelBox.put(customerModel);
  }

  void addAllCustomer() {
    itemModelBox.removeAll();
    var x = itemModelBox.putMany(customers);
    setStatus("Added ${x.length} customers to the database");
  }

  void getData() {
    dbCustomers = itemModelBox.getAll();
    setStatus("${dbCustomers.length} customers are available on the database");
  }

  String filterStatus = "";

  // String filter
  // search customer v2
  void searchCustomerV2() {}

  void searchCustomer() {
    try {
      if (filterBy == null ||
          filterBy!.isEmpty ||
          customerStatus == null ||
          customerStatus!.isEmpty) {
        setStatus("Please, select filter and status");
        return;
      }

      filterStatus = "Customer status: $customerStatus \nFilter by: $filterBy";

      var query;

      isCustomer = true;

      switch (filterBy) {
        case "allZeroOrder":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.equals(0),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "allMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.notEquals(0),
                TawabelCustomerModel_.city.equals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "allOutsideMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.equals(0),
                TawabelCustomerModel_.city.notEquals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "allOutside":
          var list = tawabelCustomerModelBox
              .query(TawabelCustomerModel_.status.equals(customerStatus!))
              .build()
              .find();

          list = list
              .where((element) => !element.mobile.startsWith("966"))
              .toList();

          tawabelCustomers = list;
          setStatus(
              "${tawabelCustomers.length} customers are available on the database");

          return;

        case "zeroInMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.equals(0),
                TawabelCustomerModel_.city.equals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "zeroOutMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.equals(0),
                TawabelCustomerModel_.city.notEquals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "oneTwoInMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.between(1, 2),
                TawabelCustomerModel_.city.equals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "oneTwoOutMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.between(1, 2),
                TawabelCustomerModel_.city.notEquals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "threeFourInMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.between(3, 4),
                TawabelCustomerModel_.city.equals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "threeFourOutMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.between(3, 4),
                TawabelCustomerModel_.city.notEquals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "fivePlusInMainda":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.greaterThan(4),
                TawabelCustomerModel_.city.equals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "fivePlusOutMainda":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.greaterThan(4),
                TawabelCustomerModel_.city.notEquals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "unKnownOrderMadina":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.equals(0),
                TawabelCustomerModel_.city.equals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "unKnownOrderOutMadinah":
          query = tawabelCustomerModelBox.query(
            TawabelCustomerModel_.status.equals(customerStatus!).andAll(
              [
                TawabelCustomerModel_.numberOfOrder.equals(0),
                TawabelCustomerModel_.city.notEquals("Madinah"),
                TawabelCustomerModel_.mobile.startsWith("966"),
              ],
            ),
          );
          break;
        case "abandoned200SR":
          isCustomer = false;
          query = abandonedModelBox.query(
            AbandonedModel_.status.equals(customerStatus!).andAll(
              [
                AbandonedModel_.amount.greaterOrEqual(80),
                AbandonedModel_.isSaudi.equals(true),
                AbandonedModel_.mobile.startsWith("966"),
                AbandonedModel_.updatedAt.greaterOrEqual(
                    DateTime(2022, 10, 1, 0, 0, 0).millisecondsSinceEpoch),
                AbandonedModel_.phase.notEquals("completed"),
              ],
            ),
          );
          break;
        case "abandonedLessThan200SR":
          isCustomer = false;
          query = abandonedModelBox.query(
            AbandonedModel_.status.equals(customerStatus!).andAll(
              [
                AbandonedModel_.amount.lessThan(299),
                AbandonedModel_.isSaudi.equals(true),
              ],
            ),
          );
          break;
        case "FromAll":
          query = tawabelCustomerModelBox
              .query(TawabelCustomerModel_.status.equals(customerStatus!));

          break;
      }

      if (query == null) {
        setStatus("Please select filter and status");
      } else {
        if (isCustomer == true) {
          tawabelCustomers = query.build().find();
          setStatus(
              "${tawabelCustomers.length} customers are available on the database");
        }
        if (isCustomer == false) {
          abandoned = query.build().find();
          setStatus(
              "${abandoned.length} abandoned customers are available on the database");
        }
      }
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  // show all customers
  void showAllCustomers() {
    tawabelCustomers = tawabelCustomerModelBox.getAll();
    setStatus(
        "${tawabelCustomers.length} customers are available on the database");
    notifyListeners();
  }

  void searchCustomerByText(String text) {
    if (text.isEmpty) {
      tawabelCustomers.clear();
      setStatus("Write something to search");

      return;
    }
    tawabelCustomers = tawabelCustomerModelBox
        .query(
          TawabelCustomerModel_.name
              .contains(text, caseSensitive: false)
              .orAny([
            TawabelCustomerModel_.mobile.contains(text, caseSensitive: false),
            TawabelCustomerModel_.city.contains(text, caseSensitive: false),
            TawabelCustomerModel_.type.contains(text, caseSensitive: false),
          ]),
        )
        .build()
        .find();

    setStatus("${tawabelCustomers.length} customers found");

    notifyListeners();
  }

  blockCustomer(int id, String searchText) {
    try {
      var customer = tawabelCustomerModelBox.get(id);
      if (customer == null) {
        setStatus("Customer not found");
        return;
      }
      customer.isBlock = true;
      tawabelCustomerModelBox.put(customer);
      setStatus("Customer is blocked");
      searchCustomerByText(searchText);
    } catch (e) {
      setStatus("Customer is not found");
    } finally {
      notifyListeners();
    }
  }

  unblockCustomer(int id, String searchText) {
    try {
      var customer = tawabelCustomerModelBox.get(id);
      if (customer == null) {
        setStatus("Customer not found");
        return;
      }
      customer.isBlock = false;
      tawabelCustomerModelBox.put(customer);
      setStatus("Customer is unblocked");
      searchCustomerByText(searchText);
    } catch (e) {
      setStatus("Customer is not found");
    } finally {
      notifyListeners();
    }
  }

  void clearStatus() {
    List<TawabelCustomerModel> c = tawabelCustomerModelBox.getAll();
    for (var i in c) {
      i.status = "unknown";
    }
    itemModelBox.putMany(customers);
  }

  // ************************ API Calles **********************
  Future<void> openBrowser() async {
    var browser = "$baseURL/open-browser";

    try {
      var whatsappRes = await Dio().post(browser);
      _systemStatus = whatsappRes.data['status'];
      openWhatsApp();
    } catch (e) {
      _systemStatus = "Opening whatsapp error";
    }

    notifyListeners();
  }

  // Close brower
  Future<void> closeBrowser() async {
    var browser = "$baseURL/close-browser";

    try {
      var whatsappRes = await Dio().post(browser);
      _systemStatus = whatsappRes.data['status'];
    } catch (e) {
      _systemStatus = "Closing whatsapp error";
    }

    notifyListeners();
  }

  Future<void> openWhatsApp() async {
    // var browser = "$baseURL/open-browser";
    var whatsapp = "$baseURL/open-whatsapp";

    // try {
    //   var browserRes = await Dio().post(browser);
    //   _systemStatus = browserRes.data['status'];
    // } catch (e) {
    //   _systemStatus = "Opening browser error";
    //   notifyListeners();
    // }

    try {
      var whatsappRes = await Dio().post(whatsapp);
      _systemStatus = whatsappRes.data['status'];
      print("💥💥💥");
    } catch (e) {
      _systemStatus = "Opening whatsapp error";
    }

    notifyListeners();
  }

  bool shouldSend = true;

  stopMessage() {
    shouldSend = false;
  }

  int totalToSend = 0;
  int sent = 0;
  int remaining = 0;

  Future<void> sendBatchMessage() async {
    print("Opening browser");
    _spinnerOn();
    await openBrowser();
    await openWhatsApp();
    _spinnerOff();

    shouldSend = true;

    totalToSend = 0;
    sent = 0;
    remaining = 0;

    int count = 0;

    if (isCustomer == true && tawabelCustomers.isNotEmpty) {
      totalToSend = tawabelCustomers.length;
      notifyListeners();
      for (var item in tawabelCustomers) {
        log("Count ❤️ $count");
        if (!shouldSend) break;
        if (item.isBlock == true) continue;
        await sendMessage(
            name: item.name, number: item.mobile, message: _message);
        sent++;
        remaining = totalToSend - sent;
        notifyListeners();
        // var nowTime = TimeOfDay.now();
        // if (nowTime.hour >= 4 &&
        //     nowTime.minute >= 0 &&
        //     nowTime.hour <= 10 &&
        //     nowTime.minute <= 59) {
        //   break;
        // }
        count = count + 1;
        if (count == 5) {
          count = 0;
          // notifyListeners();
          _spinnerOn();
          print("Closing browser");
          await closeBrowser();
          print("Opening browser");
          await openBrowser();
          await openWhatsApp();
          _spinnerOff();
        }
      }
    }
    if (isCustomer == false && abandoned.isNotEmpty) {
      for (var item in abandoned) {
        if (!shouldSend) break;
        if (item.isBlocked == true) continue;
        await sendMessage(
            name: item.name, number: item.mobile, message: _message);
      }
    }
    _selectedStatus = "Sent to all successfull";
  }

  Future<void> sendMessage({
    required String name,
    required String number,
    required String message,
  }) async {
    _systemStatus = "Sending message to $name -> $number";
    var url = "$baseURL/send-message";
    Map<String, dynamic> postBody = {
      "name": name,
      "number": number,
      "message": message,
    };

    try {
      var response = await Dio().post(url, data: postBody);

      if (isCustomer == true) {
        final c = tawabelCustomerModelBox
            .query(TawabelCustomerModel_.mobile.equals(number))
            .build()
            .findFirst();

        if (c != null) {
          c.status = response.data['result']['status'];
          tawabelCustomerModelBox.put(c);
        }
      }

      if (isCustomer == false) {
        final c = abandonedModelBox
            .query(AbandonedModel_.mobile.equals(number))
            .build()
            .findFirst();

        if (c != null) {
          c.status = response.data['result']['status'];
          abandonedModelBox.put(c);
        }
      }

      _systemStatus = response.data['result']['status'];
    } catch (e) {
      _systemStatus = "Failed from system";
    } finally {
      notifyListeners();
    }
  }

  /****************** Save from customer ******************************/
  String _systemStatus = "Status";

  String get systemStatus => _systemStatus;
  List<TawabelCustomerModel> tawabelCustomers = [];
  List<TawabelCustomerModel> tawabelCustomersResult = [];

  Future<void> setCustomerFile() async {
    excelFile = await ExcelUtils.getExcelDocument();
    if (excelFile != null) {
      _systemStatus = "File is okay";
    } else {
      _systemStatus = "File Error";
    }
    notifyListeners();
  }

  Future<void> readCustomerFromFile() async {
    tawabelCustomers = ExcelUtils.readTawabelCustomer(
        excelFile["Sheet1"], CustomerTypeEnum.customer);
    if (tawabelCustomers.isNotEmpty) {
      _systemStatus = "Total ${tawabelCustomers.length} found";
    }

    notifyListeners();
  }

  Future<void> saveAbandonedFromFile() async {
    int previousDataLength = abandonedModelBox.count();

    // List of phase "completed" only from abandoned list
    List<String> completedCustomer = abandoned
        .where((element) => element.phase == "completed")
        .map((e) => e.mobile)
        .toList();

    for (var item in abandoned) {
      if (completedCustomer.contains(item.mobile)) continue;

      AbandonedModel? c = abandonedModelBox
          .query(AbandonedModel_.mobile.equals(item.mobile))
          .build()
          .findFirst();
      if (c != null) continue;

      abandonedModelBox.put(item);
    }

    if (abandonedModelBox.count() > previousDataLength) {
      _systemStatus =
          "Added ${abandonedModelBox.count() - previousDataLength} new abandoned customer";
    } else {
      _systemStatus = "No new abandoned customer";
    }

    notifyListeners();
  }

  Future<void> saveCustomersFromFile() async {
    int previousDataLength = tawabelCustomerModelBox.count();

    for (var item in tawabelCustomers) {
      TawabelCustomerModel? c = tawabelCustomerModelBox
          .query(TawabelCustomerModel_.mobile.equals(item.mobile))
          .build()
          .findFirst();
      if (c != null) continue;

      tawabelCustomerModelBox.put(item);
    }

    if (tawabelCustomerModelBox.count() > previousDataLength) {
      _systemStatus =
          "Added ${tawabelCustomerModelBox.count() - previousDataLength} new customers";
    } else {
      _systemStatus = "No new customers";
    }

    notifyListeners();
  }

  countCustomers() {
    _systemStatus = "Now total ${tawabelCustomerModelBox.count()} in the db";
    notifyListeners();
  }

  List<Condition<TawabelCustomerModel>> getFilterText(FilterEnums filter) {
    switch (filter) {
      case FilterEnums.zeroInMadina:
        return [
          TawabelCustomerModel_.city.equals('Madinah'),
          TawabelCustomerModel_.numberOfOrder.equals(0)
        ];
      case FilterEnums.zeroOutMadina:
        return [
          TawabelCustomerModel_.city.notEquals('Madinah'),
          TawabelCustomerModel_.numberOfOrder.equals(0)
        ];

      default:
        return [];
    }
  }

  findCustomers(
      FilterEnums filter, CustomerTypeEnum type, CustomerStatusEnum status) {
    tawabelCustomersResult = tawabelCustomerModelBox
        .query(
          TawabelCustomerModel_.type.equals(type.name).andAll(
            [
              TawabelCustomerModel_.isBlock.notEquals(true),
              TawabelCustomerModel_.status.equals(status.name),
              ...getFilterText(filter)
            ],
          ),
        )
        .build()
        .find();

    _systemStatus = "${tawabelCustomersResult.length} customers found";

    notifyListeners();
  }

  void clearCustomerStatus() {
    List<TawabelCustomerModel> c = tawabelCustomerModelBox.getAll();
    for (var i in c) {
      i.status = CustomerStatusEnum.unknown.name;
    }
    var x = tawabelCustomerModelBox.putMany(c);

    _systemStatus = "Status cleard";

    notifyListeners();
  }

  seeAllCustomers() {
    tawabelCustomersResult = tawabelCustomerModelBox.getAll();
    notifyListeners();
  }

  clearCustomer() {
    int remove = tawabelCustomerModelBox.removeAll();
    if (remove >= 0) {
      _systemStatus = "Removed all customers";
      tawabelCustomers.clear();
      // showAllCustomers();
    }
    notifyListeners();
  }

  clearAbandoned() {
    int remove = abandonedModelBox.removeAll();
    if (remove >= 0) {
      _systemStatus = "Removed all Abandoned";
      abandoned.clear();
      // showAllCustomers();
    }
    notifyListeners();
  }

  /****************** Save from abandoned ************************** */

  //** Set message */
  String _message = "";

  String get message => _message;

  void setMessage(String t) {
    _message = t;
    _systemStatus = _message;
    notifyListeners();
  }

  void seeMessage() {
    _systemStatus = _message;
    notifyListeners();
  }
}
