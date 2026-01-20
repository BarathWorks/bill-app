import 'package:equatable/equatable.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_item.dart';

/// Base class for billing states
abstract class BillingState extends Equatable {
  const BillingState();

  @override
  List<Object?> get props => [];
}

/// Initial state with empty bill form
class BillingInitial extends BillingState {
  final String shopName;
  final String area;
  final List<BillItem> items;
  final double totalAmount;
  final double commission;
  final double finalPayable;

  const BillingInitial({
    this.shopName = '',
    this.area = '',
    this.items = const [],
    this.totalAmount = 0.0,
    this.commission = 0.0,
    this.finalPayable = 0.0,
  });

  @override
  List<Object?> get props => [
        shopName,
        area,
        items,
        totalAmount,
        commission,
        finalPayable,
      ];

  BillingInitial copyWith({
    String? shopName,
    String? area,
    List<BillItem>? items,
    double? totalAmount,
    double? commission,
    double? finalPayable,
  }) {
    final newItems = items ?? this.items;
    final newTotal = totalAmount ?? _calculateTotal(newItems);
    final newCommission = commission ?? this.commission;
    final newFinal = finalPayable ?? (newTotal - newCommission);

    return BillingInitial(
      shopName: shopName ?? this.shopName,
      area: area ?? this.area,
      items: newItems,
      totalAmount: newTotal,
      commission: newCommission,
      finalPayable: newFinal,
    );
  }

  double _calculateTotal(List<BillItem> items) {
    return items.fold<double>(0.0, (sum, item) => sum + item.amount);
  }
}

/// Loading state
class BillingLoading extends BillingState {
  const BillingLoading();
}

/// Bill generated successfully
class BillGeneratedSuccess extends BillingState {
  final Bill bill;

  const BillGeneratedSuccess(this.bill);

  @override
  List<Object?> get props => [bill];
}

/// Bill deleted successfully
class BillDeletedSuccess extends BillingState {
  final String message;

  const BillDeletedSuccess([this.message = 'Bill deleted successfully']);

  @override
  List<Object?> get props => [message];
}

/// Error state
class BillingError extends BillingState {
  final String message;

  const BillingError(this.message);

  @override
  List<Object?> get props => [message];
}

/// All bills loaded successfully
class BillsLoaded extends BillingState {
  final List<Bill> bills;

  const BillsLoaded(this.bills);

  @override
  List<Object?> get props => [bills];
}

/// Bills search results
class BillsSearchResults extends BillingState {
  final List<Bill> bills;
  final String query;

  const BillsSearchResults(this.bills, this.query);

  @override
  List<Object?> get props => [bills, query];
}
