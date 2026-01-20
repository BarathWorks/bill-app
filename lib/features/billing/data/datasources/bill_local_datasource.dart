import 'package:dartz/dartz.dart';
import '../models/bill_model.dart';

/// Abstract data source interface for local bill operations
abstract class BillLocalDataSource {
  /// Save a bill to local storage
  Future<Unit> saveBill(BillModel bill);
  
  /// Get all saved bills
  Future<List<BillModel>> getAllBills();
  
  /// Get a specific bill by ID
  Future<BillModel> getBillById(String id);
  
  /// Delete a bill by ID
  Future<Unit> deleteBill(String id);
  
  /// Search bills by shop name or area
  Future<List<BillModel>> searchBills(String query);
  
  /// Get bills within a date range
  Future<List<BillModel>> getBillsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
