import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/bill_repository.dart';

/// Use case for deleting a bill
class DeleteBill implements UseCase<Unit, String> {
  final BillRepository repository;

  DeleteBill(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteBill(id);
  }
}
