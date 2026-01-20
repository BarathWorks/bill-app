import 'package:equatable/equatable.dart';

/// Bill item entity representing a single item transaction
class BillItem extends Equatable {
  /// Name of the flower/item
  final String itemName;

  /// Date of the transaction
  final DateTime date;

  /// Quantity of flowers in kg or units
  final double quantity;

  /// Rate per unit/kg
  final double rate;

  /// Calculated amount (quantity * rate)
  final double amount;

  const BillItem({
    required this.itemName,
    required this.date,
    required this.quantity,
    required this.rate,
    required this.amount,
  });

  /// Factory to create BillItem with automatic amount calculation
  factory BillItem.create({
    required String itemName,
    required DateTime date,
    required double quantity,
    required double rate,
  }) {
    return BillItem(
      itemName: itemName,
      date: date,
      quantity: quantity,
      rate: rate,
      amount: (quantity * rate * 100).roundToDouble() / 100,
    );
  }

  /// Copy with new values
  BillItem copyWith({
    String? itemName,
    DateTime? date,
    double? quantity,
    double? rate,
    double? amount,
  }) {
    final newQty = quantity ?? this.quantity;
    final newRate = rate ?? this.rate;
    return BillItem(
      itemName: itemName ?? this.itemName,
      date: date ?? this.date,
      quantity: newQty,
      rate: newRate,
      amount: amount ?? ((newQty * newRate * 100).roundToDouble() / 100),
    );
  }

  @override
  List<Object?> get props => [itemName, date, quantity, rate, amount];
}
