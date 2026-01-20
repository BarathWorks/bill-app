import 'package:hive/hive.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_item.dart';
import 'bill_item_model.dart';
import '../../../../core/constants/hive_constants.dart';

part 'bill_model.g.dart';

/// Hive model for Bill entity
@HiveType(typeId: HiveConstants.billModelTypeId)
class BillModel extends Bill {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final DateTime date;

  @override
  @HiveField(2)
  final String shopName;

  @override
  @HiveField(3)
  final String area;

  @override
  @HiveField(4)
  final List<BillItemModel> items;

  @override
  @HiveField(5)
  final double totalAmount;

  @override
  @HiveField(6)
  final double commission;

  @override
  @HiveField(7)
  final double finalPayable;

  const BillModel({
    required this.id,
    required this.date,
    required this.shopName,
    required this.area,
    required this.items,
    required this.totalAmount,
    required this.commission,
    required this.finalPayable,
  }) : super(
          id: id,
          date: date,
          shopName: shopName,
          area: area,
          items: items,
          totalAmount: totalAmount,
          commission: commission,
          finalPayable: finalPayable,
        );

  /// Create model from entity
  factory BillModel.fromEntity(Bill bill) {
    return BillModel(
      id: bill.id,
      date: bill.date,
      shopName: bill.shopName,
      area: bill.area,
      items: bill.items.map((item) => BillItemModel.fromEntity(item)).toList(),
      totalAmount: bill.totalAmount,
      commission: bill.commission,
      finalPayable: bill.finalPayable,
    );
  }

  /// Create with automatic calculations
  factory BillModel.calculate({
    required String id,
    required DateTime date,
    required String shopName,
    required String area,
    required List<BillItemModel> items,
    required double commission,
  }) {
    final totalAmount = items.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final roundedTotal = (totalAmount * 100).roundToDouble() / 100;
    final roundedCommission = (commission * 100).roundToDouble() / 100;
    final finalPayable = ((roundedTotal - roundedCommission) * 100).roundToDouble() / 100;

    return BillModel(
      id: id,
      date: date,
      shopName: shopName,
      area: area,
      items: items,
      totalAmount: roundedTotal,
      commission: roundedCommission,
      finalPayable: finalPayable,
    );
  }

  /// Convert to entity
  Bill toEntity() {
    return Bill(
      id: id,
      date: date,
      shopName: shopName,
      area: area,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      commission: commission,
      finalPayable: finalPayable,
    );
  }

  @override
  BillModel copyWith({
    String? id,
    DateTime? date,
    String? shopName,
    String? area,
    List<BillItem>? items,
    double? totalAmount,
    double? commission,
    double? finalPayable,
  }) {
    return BillModel(
      id: id ?? this.id,
      date: date ?? this.date,
      shopName: shopName ?? this.shopName,
      area: area ?? this.area,
      items: items != null
          ? items.map((item) => BillItemModel.fromEntity(item)).toList()
          : this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      commission: commission ?? this.commission,
      finalPayable: finalPayable ?? this.finalPayable,
    );
  }
}
