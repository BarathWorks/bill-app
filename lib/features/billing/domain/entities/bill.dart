import 'package:equatable/equatable.dart';
import 'bill_item.dart';

/// Bill entity representing a complete bill for a shop
class Bill extends Equatable {
  /// Unique identifier for the bill
  final String id;
  
  /// Date when the bill was created
  final DateTime date;
  
  /// Name of the shop/customer
  final String shopName;
  
  /// Area/location of the shop
  final String area;
  
  /// List of bill items (daily transactions)
  final List<BillItem> items;
  
  /// Total amount before commission
  final double totalAmount;
  
  /// Commission to be deducted
  final double commission;
  
  /// Final payable amount (total - commission)
  final double finalPayable;

  const Bill({
    required this.id,
    required this.date,
    required this.shopName,
    required this.area,
    required this.items,
    required this.totalAmount,
    required this.commission,
    required this.finalPayable,
  });

  /// Factory to create Bill with automatic calculations
  factory Bill.create({
    required String id,
    required DateTime date,
    required String shopName,
    required String area,
    required List<BillItem> items,
    required double commission,
  }) {
    final totalAmount = items.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final roundedTotal = (totalAmount * 100).roundToDouble() / 100;
    final roundedCommission = (commission * 100).roundToDouble() / 100;
    final finalPayable = ((roundedTotal - roundedCommission) * 100).roundToDouble() / 100;

    return Bill(
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

  /// Copy with new values
  Bill copyWith({
    String? id,
    DateTime? date,
    String? shopName,
    String? area,
    List<BillItem>? items,
    double? totalAmount,
    double? commission,
    double? finalPayable,
  }) {
    return Bill(
      id: id ?? this.id,
      date: date ?? this.date,
      shopName: shopName ?? this.shopName,
      area: area ?? this.area,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      commission: commission ?? this.commission,
      finalPayable: finalPayable ?? this.finalPayable,
    );
  }

  @override
  List<Object?> get props => [
        id,
        date,
        shopName,
        area,
        items,
        totalAmount,
        commission,
        finalPayable,
      ];
}
