import 'package:equatable/equatable.dart';
import '../../domain/entities/bill_item.dart';

/// Base class for billing events
abstract class BillingEvent extends Equatable {
  const BillingEvent();

  @override
  List<Object?> get props => [];
}

/// Add a new item to the current bill
class AddBillItemEvent extends BillingEvent {
  final BillItem item;

  const AddBillItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Remove an item from the current bill by index
class RemoveBillItemEvent extends BillingEvent {
  final int index;

  const RemoveBillItemEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Update an existing item in the current bill
class UpdateBillItemEvent extends BillingEvent {
  final int index;
  final BillItem item;

  const UpdateBillItemEvent(this.index, this.item);

  @override
  List<Object?> get props => [index, item];
}

/// Update shop details
class UpdateShopDetailsEvent extends BillingEvent {
  final String? shopName;
  final String? area;

  const UpdateShopDetailsEvent({this.shopName, this.area});

  @override
  List<Object?> get props => [shopName, area];
}

/// Update commission amount
class UpdateCommissionEvent extends BillingEvent {
  final double commission;

  const UpdateCommissionEvent(this.commission);

  @override
  List<Object?> get props => [commission];
}

/// Generate and save the bill
class GenerateBillEvent extends BillingEvent {
  const GenerateBillEvent();
}

/// Load all saved bills
class LoadAllBillsEvent extends BillingEvent {
  const LoadAllBillsEvent();
}

/// Delete a bill by ID
class DeleteBillEvent extends BillingEvent {
  final String billId;

  const DeleteBillEvent(this.billId);

  @override
  List<Object?> get props => [billId];
}

/// Reset the bill form for a new bill
class ResetBillFormEvent extends BillingEvent {
  const ResetBillFormEvent();
}

/// Search bills by query
class SearchBillsEvent extends BillingEvent {
  final String query;

  const SearchBillsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
