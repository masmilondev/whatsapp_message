import 'package:objectbox/objectbox.dart';

@Entity()
class CustomerModel {
  int id;
  String name;
  String mobile;
  String? city;
  int? numberOfOrder;
  String? status;

  CustomerModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.city,
    this.numberOfOrder,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'city': city ?? "",
        'numberOfOrder': numberOfOrder ?? 0,
      };
}
