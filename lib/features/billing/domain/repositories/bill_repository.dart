import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bill.dart';

/// Abstract repository interface for billing operations
abstract class BillRepository {
  /// Save a new bill or update existing one
  Future<Either<Failure, Unit>> saveBill(Bill bill);
  
  /// Get all saved bills, sorted by date (newest first)
  Future<Either<Failure, List<Bill>>> getAllBills();
  
  /// Get a specific bill by its ID
  Future<Either<Failure, Bill>> getBillById(String id);
  
  /// Delete a bill by its ID
  Future<Either<Failure, Unit>> deleteBill(String id);
  
  /// Search bills by shop name or area
  Future<Either<Failure, List<Bill>>> searchBills(String query);
  
  /// Get bills within a date range
  Future<Either<Failure, List<Bill>>> getBillsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
