import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bill.dart';
import '../repositories/bill_repository.dart';

/// Use case for fetching a specific bill by ID
class GetBillById implements UseCase<Bill, String> {
  final BillRepository repository;

  GetBillById(this.repository);

  @override
  Future<Either<Failure, Bill>> call(String id) async {
    return await repository.getBillById(id);
  }
}
