import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'bill_local_datasource.dart';
import '../models/bill_model.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../../../core/error/exceptions.dart';

/// Hive implementation of bill local data source
class BillLocalDataSourceImpl implements BillLocalDataSource {
  final Box<BillModel> billBox;

  BillLocalDataSourceImpl({required this.billBox});

  @override
  Future<Unit> saveBill(BillModel bill) async {
    try {
      await billBox.put(bill.id, bill);
      return unit;
    } catch (e) {
      throw CacheException('Failed to save bill: $e');
    }
  }

  @override
  Future<List<BillModel>> getAllBills() async {
    try {
      final bills = billBox.values.toList();
      // Sort by date descending (newest first)
      bills.sort((a, b) => b.date.compareTo(a.date));
      return bills;
    } catch (e) {
      throw CacheException('Failed to get bills: $e');
    }
  }

  @override
  Future<BillModel> getBillById(String id) async {
    try {
      final bill = billBox.get(id);
      if (bill == null) {
        throw NotFoundException('Bill not found with id: $id');
      }
      return bill;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException('Failed to get bill: $e');
    }
  }

  @override
  Future<Unit> deleteBill(String id) async {
    try {
      await billBox.delete(id);
      return unit;
    } catch (e) {
      throw CacheException('Failed to delete bill: $e');
    }
  }

  @override
  Future<List<BillModel>> searchBills(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();
      final bills = billBox.values.where((bill) {
        return bill.shopName.toLowerCase().contains(lowercaseQuery) ||
            bill.area.toLowerCase().contains(lowercaseQuery);
      }).toList();
      bills.sort((a, b) => b.date.compareTo(a.date));
      return bills;
    } catch (e) {
      throw CacheException('Failed to search bills: $e');
    }
  }

  @override
  Future<List<BillModel>> getBillsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final bills = billBox.values.where((bill) {
        return bill.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            bill.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
      bills.sort((a, b) => b.date.compareTo(a.date));
      return bills;
    } catch (e) {
      throw CacheException('Failed to get bills by date range: $e');
    }
  }
}
