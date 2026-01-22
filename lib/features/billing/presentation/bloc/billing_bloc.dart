import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/usecases/generate_bill.dart';
import '../../domain/usecases/get_all_bills.dart';
import '../../domain/usecases/delete_bill.dart';
import 'billing_event.dart';
import 'billing_state.dart';

/// BLoC for managing billing state
class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final GenerateBill generateBill;
  final GetAllBills getAllBills;
  final DeleteBill deleteBill;

  BillingBloc({
    required this.generateBill,
    required this.getAllBills,
    required this.deleteBill,
  }) : super(const BillingInitial()) {
    on<AddBillItemEvent>(_onAddBillItem);
    on<RemoveBillItemEvent>(_onRemoveBillItem);
    on<UpdateBillItemEvent>(_onUpdateBillItem);
    on<UpdateShopDetailsEvent>(_onUpdateShopDetails);
    on<UpdateCommissionEvent>(_onUpdateCommission);
    on<GenerateBillEvent>(_onGenerateBill);
    on<LoadAllBillsEvent>(_onLoadAllBills);
    on<DeleteBillEvent>(_onDeleteBill);
    on<ResetBillFormEvent>(_onResetBillForm);
    on<SearchBillsEvent>(_onSearchBills);
  }

  void _onAddBillItem(AddBillItemEvent event, Emitter<BillingState> emit) {
    if (state is BillingInitial) {
      final currentState = state as BillingInitial;
      final newItems = List<BillItem>.from(currentState.items)..add(event.item);
      emit(currentState.copyWith(items: newItems));
    }
  }

  void _onRemoveBillItem(RemoveBillItemEvent event, Emitter<BillingState> emit) {
    if (state is BillingInitial) {
      final currentState = state as BillingInitial;
      if (event.index >= 0 && event.index < currentState.items.length) {
        final newItems = List<BillItem>.from(currentState.items)
          ..removeAt(event.index);
        emit(currentState.copyWith(items: newItems));
      }
    }
  }

  void _onUpdateBillItem(UpdateBillItemEvent event, Emitter<BillingState> emit) {
    if (state is BillingInitial) {
      final currentState = state as BillingInitial;
      if (event.index >= 0 && event.index < currentState.items.length) {
        final newItems = List<BillItem>.from(currentState.items);
        newItems[event.index] = event.item;
        emit(currentState.copyWith(items: newItems));
      }
    }
  }

  void _onUpdateShopDetails(
    UpdateShopDetailsEvent event,
    Emitter<BillingState> emit,
  ) {
    if (state is BillingInitial) {
      final currentState = state as BillingInitial;
      emit(currentState.copyWith(
        shopName: event.shopName,
        area: event.area,
      ));
    }
  }

  void _onUpdateCommission(
    UpdateCommissionEvent event,
    Emitter<BillingState> emit,
  ) {
    if (state is BillingInitial) {
      final currentState = state as BillingInitial;
      emit(currentState.copyWith(commission: event.commission));
    }
  }

  Future<void> _onGenerateBill(
    GenerateBillEvent event,
    Emitter<BillingState> emit,
  ) async {
    if (state is BillingInitial) {
      final currentState = state as BillingInitial;

      // Validation
      if (currentState.shopName.isEmpty) {
        emit(const BillingError('Please enter shop name'));
        emit(currentState);
        return;
      }

      if (currentState.items.isEmpty) {
        emit(const BillingError('Please add at least one item'));
        emit(currentState);
        return;
      }

      emit(const BillingLoading());

      final result = await generateBill(GenerateBillParams(
        shopName: currentState.shopName,
        area: currentState.area,
        items: currentState.items,
        commission: currentState.commission,
      ));

      result.fold(
        (failure) => emit(BillingError(failure.toString())),
        (bill) => emit(BillGeneratedSuccess(bill)),
      );
    }
  }

  Future<void> _onLoadAllBills(
    LoadAllBillsEvent event,
    Emitter<BillingState> emit,
  ) async {
    emit(const BillingLoading());

    final result = await getAllBills(const NoParams());

    result.fold(
      (failure) => emit(BillingError(failure.toString())),
      (bills) => emit(BillsLoaded(bills)),
    );
  }

  Future<void> _onDeleteBill(
    DeleteBillEvent event,
    Emitter<BillingState> emit,
  ) async {
    emit(const BillingLoading());

    final result = await deleteBill(event.billId);

    await result.fold(
      (failure) async => emit(BillingError(failure.toString())),
      (_) async {
        emit(const BillDeletedSuccess());
        // Reload bills after deletion
        add(const LoadAllBillsEvent());
      },
    );
  }

  void _onResetBillForm(ResetBillFormEvent event, Emitter<BillingState> emit) {
    emit(const BillingInitial());
  }

  Future<void> _onSearchBills(
    SearchBillsEvent event,
    Emitter<BillingState> emit,
  ) async {
    final query = event.query.toLowerCase().trim();

    // If query is empty, load all bills
    if (query.isEmpty) {
      add(const LoadAllBillsEvent());
      return;
    }

    emit(const BillingLoading());

    final result = await getAllBills(const NoParams());

    result.fold(
      (failure) => emit(BillingError(failure.toString())),
      (bills) {
        // Filter bills by shop name or area
        final filteredBills = bills.where((bill) {
          final shopNameMatch = bill.shopName.toLowerCase().contains(query);
          final areaMatch = bill.area.toLowerCase().contains(query);
          return shopNameMatch || areaMatch;
        }).toList();

        emit(BillsSearchResults(filteredBills, event.query));
      },
    );
  }
}
