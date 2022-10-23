import 'package:objectbox/objectbox.dart';

@Entity()
class TawabelCustomerModel {
  int id;
  String name;
  String mobile;
  String? city;
  int? numberOfOrder;
  String status;
  String? type;
  double? amount;
  bool? isBlock;
  DateTime addedDate;

  TawabelCustomerModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.status,
    required this.addedDate,
    this.city,
    this.numberOfOrder,
    this.type,
    this.amount,
    this.isBlock,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'city': city ?? "",
        'numberOfOrder': numberOfOrder ?? 0,
      };
}
