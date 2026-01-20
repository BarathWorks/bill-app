import 'package:hive/hive.dart';
import '../../domain/entities/bill_item.dart';
import '../../../../core/constants/hive_constants.dart';

part 'bill_item_model.g.dart';

/// Hive model for BillItem entity
@HiveType(typeId: HiveConstants.billItemModelTypeId)
class BillItemModel extends BillItem {
  @override
  @HiveField(0)
  final String itemName;

  @override
  @HiveField(1)
  final DateTime date;

  @override
  @HiveField(2)
  final double quantity;

  @override
  @HiveField(3)
  final double rate;

  @override
  @HiveField(4)
  final double amount;

  const BillItemModel({
    required this.itemName,
    required this.date,
    required this.quantity,
    required this.rate,
    required this.amount,
  }) : super(
         itemName: itemName,
         date: date,
         quantity: quantity,
         rate: rate,
         amount: amount,
       );

  /// Create model from entity
  factory BillItemModel.fromEntity(BillItem item) {
    return BillItemModel(
      itemName: item.itemName,
      date: item.date,
      quantity: item.quantity,
      rate: item.rate,
      amount: item.amount,
    );
  }

  /// Create with automatic amount calculation
  factory BillItemModel.calculate({
    required String itemName,
    required DateTime date,
    required double quantity,
    required double rate,
  }) {
    return BillItemModel(
      itemName: itemName,
      date: date,
      quantity: quantity,
      rate: rate,
      amount: (quantity * rate * 100).roundToDouble() / 100,
    );
  }

  /// Convert to entity
  BillItem toEntity() {
    return BillItem(
      itemName: itemName,
      date: date,
      quantity: quantity,
      rate: rate,
      amount: amount,
    );
  }

  @override
  BillItemModel copyWith({
    String? itemName,
    DateTime? date,
    double? quantity,
    double? rate,
    double? amount,
  }) {
    final newQty = quantity ?? this.quantity;
    final newRate = rate ?? this.rate;
    return BillItemModel(
      itemName: itemName ?? this.itemName,
      date: date ?? this.date,
      quantity: newQty,
      rate: newRate,
      amount: amount ?? ((newQty * newRate * 100).roundToDouble() / 100),
    );
  }
}
