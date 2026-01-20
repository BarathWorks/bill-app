import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../entities/bill_item.dart';
import '../repositories/bill_repository.dart';

/// Parameters for generating a bill
class GenerateBillParams {
  final String shopName;
  final String area;
  final List<BillItem> items;
  final double commission;

  const GenerateBillParams({
    required this.shopName,
    required this.area,
    required this.items,
    required this.commission,
  });
}

/// Use case for generating and saving a new bill
class GenerateBill implements UseCase<Bill, GenerateBillParams> {
  final BillRepository repository;

  GenerateBill(this.repository);

  @override
  Future<Either<Failure, Bill>> call(GenerateBillParams params) async {
    // Generate unique ID
    const uuid = Uuid();
    final id = uuid.v4();

    // Create bill with auto calculations
    final bill = Bill.create(
      id: id,
      date: DateTime.now(),
      shopName: params.shopName,
      area: params.area,
      items: params.items,
      commission: params.commission,
    );

    // Save to repository
    final result = await repository.saveBill(bill);

    return result.fold(
      (failure) => Left(failure),
      (_) => Right(bill),
    );
  }
}
