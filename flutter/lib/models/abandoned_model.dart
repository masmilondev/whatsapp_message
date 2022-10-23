import 'package:objectbox/objectbox.dart';

@Entity()
class AbandonedModel {
  int id;
  String? phase;
  String name;
  String mobile;
  int? numberOfProduct;
  double? amount;
  DateTime? updatedAt;
  bool? isSaudi;
  String? status;
  bool? isBlocked;

  AbandonedModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.isSaudi,
    this.numberOfProduct,
    this.amount,
    this.phase,
    this.updatedAt,
    this.status,
    this.isBlocked,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'isSaudi': isSaudi ?? true,
        'numberOfProduct': numberOfProduct ?? 0,
        'amount': amount ?? 0,
        'phase': phase ?? "",
        'updatedAt': updatedAt?.toIso8601String() ?? "",
        'status': status ?? "",
        'isBlocked': isBlocked ?? null,
      };
}
