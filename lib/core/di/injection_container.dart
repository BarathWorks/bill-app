import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../constants/hive_constants.dart';

// Billing Feature
import '../../features/billing/data/datasources/bill_local_datasource.dart';
import '../../features/billing/data/datasources/bill_local_datasource_impl.dart';
import '../../features/billing/data/models/bill_model.dart';
import '../../features/billing/data/repositories/bill_repository_impl.dart';
import '../../features/billing/domain/repositories/bill_repository.dart';
import '../../features/billing/domain/usecases/generate_bill.dart';
import '../../features/billing/domain/usecases/get_all_bills.dart';
import '../../features/billing/domain/usecases/get_bill_by_id.dart';
import '../../features/billing/domain/usecases/delete_bill.dart';
import '../../features/billing/presentation/bloc/billing_bloc.dart';

// Settings Feature
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/models/settings_model.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/update_settings.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  //! Features - Billing

  // Bloc
  sl.registerFactory(
    () => BillingBloc(
      generateBill: sl(),
      getAllBills: sl(),
      deleteBill: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GenerateBill(sl()));
  sl.registerLazySingleton(() => GetAllBills(sl()));
  sl.registerLazySingleton(() => GetBillById(sl()));
  sl.registerLazySingleton(() => DeleteBill(sl()));

  // Repository
  sl.registerLazySingleton<BillRepository>(
    () => BillRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BillLocalDataSource>(
    () => BillLocalDataSourceImpl(billBox: sl()),
  );

  //! Features - Settings

  // Bloc
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      updateSettings: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateSettings(sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(settingsBox: sl()),
  );

  //! Core - Hive Boxes

  // Register Hive boxes (already opened in main.dart)
  sl.registerLazySingleton<Box<BillModel>>(
    () => Hive.box<BillModel>(HiveConstants.billsBox),
  );

  sl.registerLazySingleton<Box<SettingsModel>>(
    () => Hive.box<SettingsModel>(HiveConstants.settingsBox),
  );
}
