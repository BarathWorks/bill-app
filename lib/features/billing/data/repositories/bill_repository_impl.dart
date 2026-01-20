import 'package:dartz/dartz.dart';
import '../../domain/entities/bill.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/bill_local_datasource.dart';
import '../models/bill_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

/// Implementation of BillRepository using local Hive storage
class BillRepositoryImpl implements BillRepository {
  final BillLocalDataSource localDataSource;

  BillRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> saveBill(Bill bill) async {
    try {
      final billModel = BillModel.fromEntity(bill);
      await localDataSource.saveBill(billModel);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bill>>> getAllBills() async {
    try {
      final billModels = await localDataSource.getAllBills();
      return Right(billModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Bill>> getBillById(String id) async {
    try {
      final billModel = await localDataSource.getBillById(id);
      return Right(billModel.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBill(String id) async {
    try {
      await localDataSource.deleteBill(id);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bill>>> searchBills(String query) async {
    try {
      final billModels = await localDataSource.searchBills(query);
      return Right(billModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bill>>> getBillsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final billModels = await localDataSource.getBillsByDateRange(
        startDate,
        endDate,
      );
      return Right(billModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
