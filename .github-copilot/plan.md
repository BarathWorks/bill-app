Master Prompt: Bilingual Flower Distributor Billing App
Project Overview
You are building a bilingual (Tamil & English) flower distributor billing mobile application using Flutter with BLoC state management and Clean Architecture. This app digitizes traditional handwritten bills for flower distributors, enabling quick bill generation, thermal printing, and record management while maintaining the familiar paper bill format.
Tech Stack

Framework: Flutter (Android primary, iOS-ready)
State Management: BLoC (flutter_bloc)
Architecture: Clean Architecture (Domain, Data, Presentation layers)
Local Storage: Hive (NoSQL, fast, lightweight)
Printing: Bluetooth thermal printer integration (58mm/80mm paper)
Localization: Flutter intl package for Tamil & English
Dependency Injection: get_it
Functional Programming: dartz (Either pattern)

Required Packages
yamldependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Localization
  intl: ^0.18.1
  flutter_localizations:
    sdk: flutter
  
  # Printing
  blue_thermal_printer: ^1.2.2
  # OR esc_pos_bluetooth: ^0.4.1
  
  # Utils
  uuid: ^4.2.2
  path_provider: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
  injectable_generator: ^2.4.1
  
  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.5
```

## Clean Architecture Structure with Hive
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── hive_constants.dart
│   │   └── strings.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── usecases/
│   │   └── usecase.dart
│   ├── utils/
│   │   ├── decimal_utils.dart
│   │   ├── date_formatter.dart
│   │   └── bill_formatter.dart
│   └── di/
│       └── injection_container.dart
├── features/
│   ├── billing/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── bill_local_datasource.dart
│   │   │   │   └── bill_local_datasource_impl.dart
│   │   │   ├── models/
│   │   │   │   ├── bill_model.dart           # @HiveType
│   │   │   │   └── bill_item_model.dart      # @HiveType
│   │   │   └── repositories/
│   │   │       └── bill_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── bill.dart
│   │   │   │   └── bill_item.dart
│   │   │   ├── repositories/
│   │   │   │   └── bill_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_bill.dart
│   │   │       ├── get_all_bills.dart
│   │   │       ├── get_bill_by_id.dart
│   │   │       └── delete_bill.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── billing_bloc.dart
│   │       │   ├── billing_event.dart
│   │       │   └── billing_state.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── bill_preview_page.dart
│   │       └── widgets/
│   │           ├── bill_item_row.dart
│   │           ├── bill_summary_card.dart
│   │           └── traditional_bill_widget.dart
│   ├── records/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       │   └── records_page.dart
│   │       └── widgets/
│   │           └── bill_list_item.dart
│   ├── settings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── settings_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── settings_model.dart       # @HiveType
│   │   │   └── repositories/
│   │   │       └── settings_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── settings.dart
│   │   │   ├── repositories/
│   │   │   │   └── settings_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_settings.dart
│   │   │       ├── update_settings.dart
│   │   │       └── change_language.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       │   └── settings_page.dart
│   │       └── widgets/
│   └── printing/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── printer_datasource.dart
│       │   └── repositories/
│       │       └── printer_repository_impl.dart
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── printer_repository.dart
│       │   └── usecases/
│       │       ├── discover_printers.dart
│       │       ├── connect_printer.dart
│       │       └── print_bill.dart
│       └── presentation/
│           ├── bloc/
│           └── widgets/
│               └── printer_connection_dialog.dart
├── l10n/
│   ├── app_en.arb
│   └── app_ta.arb
└── main.dart
Hive Setup & Configuration
1. Hive Constants
dart// core/constants/hive_constants.dart
class HiveConstants {
  // Box Names
  static const String billsBox = 'bills_box';
  static const String settingsBox = 'settings_box';
  
  // Type Adapters IDs
  static const int billModelTypeId = 0;
  static const int billItemModelTypeId = 1;
  static const int settingsModelTypeId = 2;
  
  // Keys
  static const String settingsKey = 'app_settings';
}
2. Hive Initialization in main.dart
dart// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'core/constants/hive_constants.dart';
import 'features/billing/data/models/bill_model.dart';
import 'features/billing/data/models/bill_item_model.dart';
import 'features/settings/data/models/settings_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  Hive.registerAdapter(BillModelAdapter());
  Hive.registerAdapter(BillItemModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());
  
  // Open Hive Boxes
  await Hive.openBox<BillModel>(HiveConstants.billsBox);
  await Hive.openBox<SettingsModel>(HiveConstants.settingsBox);
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flower Billing',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ta', 'IN'),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50), // Vibrant Green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          secondary: const Color(0xFF9C27B0), // Violet
        ),
        fontFamily: 'NotoSansTamil', // Supports Tamil
      ),
      home: const HomePage(),
    );
  }
}
3. Hive Models with Type Adapters
Bill Item Model
dart// features/billing/data/models/bill_item_model.dart
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/bill_item.dart';
import '../../../../core/constants/hive_constants.dart';

part 'bill_item_model.g.dart'; // Generated file

@HiveType(typeId: HiveConstants.billItemModelTypeId)
class BillItemModel extends BillItem {
  @HiveField(0)
  final String day;
  
  @HiveField(1)
  final double quantity;
  
  @HiveField(2)
  final double rate;
  
  @HiveField(3)
  final double amount;

  const BillItemModel({
    required this.day,
    required this.quantity,
    required this.rate,
    required this.amount,
  }) : super(
          day: day,
          quantity: quantity,
          rate: rate,
          amount: amount,
        );

  factory BillItemModel.fromEntity(BillItem item) {
    return BillItemModel(
      day: item.day,
      quantity: item.quantity,
      rate: item.rate,
      amount: item.amount,
    );
  }

  factory BillItemModel.calculate({
    required String day,
    required double quantity,
    required double rate,
  }) {
    return BillItemModel(
      day: day,
      quantity: quantity,
      rate: rate,
      amount: quantity * rate,
    );
  }

  BillItemModel copyWith({
    String? day,
    double? quantity,
    double? rate,
    double? amount,
  }) {
    return BillItemModel(
      day: day ?? this.day,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
    );
  }
}
Bill Model
dart// features/billing/data/models/bill_model.dart
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/bill.dart';
import 'bill_item_model.dart';
import '../../../../core/constants/hive_constants.dart';

part 'bill_model.g.dart'; // Generated file

@HiveType(typeId: HiveConstants.billModelTypeId)
class BillModel extends Bill {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime date;
  
  @HiveField(2)
  final String shopName;
  
  @HiveField(3)
  final String area;
  
  @HiveField(4)
  final List<BillItemModel> items;
  
  @HiveField(5)
  final double totalAmount;
  
  @HiveField(6)
  final double commission;
  
  @HiveField(7)
  final double finalPayable;

  const BillModel({
    required this.id,
    required this.date,
    required this.shopName,
    required this.area,
    required this.items,
    required this.totalAmount,
    required this.commission,
    required this.finalPayable,
  }) : super(
          id: id,
          date: date,
          shopName: shopName,
          area: area,
          items: items,
          totalAmount: totalAmount,
          commission: commission,
          finalPayable: finalPayable,
        );

  factory BillModel.fromEntity(Bill bill) {
    return BillModel(
      id: bill.id,
      date: bill.date,
      shopName: bill.shopName,
      area: bill.area,
      items: bill.items.map((item) => BillItemModel.fromEntity(item)).toList(),
      totalAmount: bill.totalAmount,
      commission: bill.commission,
      finalPayable: bill.finalPayable,
    );
  }

  factory BillModel.calculate({
    required String id,
    required DateTime date,
    required String shopName,
    required String area,
    required List<BillItemModel> items,
    required double commission,
  }) {
    final totalAmount = items.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final finalPayable = totalAmount - commission;

    return BillModel(
      id: id,
      date: date,
      shopName: shopName,
      area: area,
      items: items,
      totalAmount: totalAmount,
      commission: commission,
      finalPayable: finalPayable,
    );
  }
}
Settings Model
dart// features/settings/data/models/settings_model.dart
import 'package:hive/hive.dart';
import '../../domain/entities/settings.dart';
import '../../../../core/constants/hive_constants.dart';

part 'settings_model.g.dart'; // Generated file

@HiveType(typeId: HiveConstants.settingsModelTypeId)
class SettingsModel extends Settings {
  @HiveField(0)
  final String distributorName;
  
  @HiveField(1)
  final String ownerName;
  
  @HiveField(2)
  final String phone1;
  
  @HiveField(3)
  final String phone2;
  
  @HiveField(4)
  final String address;
  
  @HiveField(5)
  final double defaultCommission;
  
  @HiveField(6)
  final String language; // 'ta' or 'en'

  const SettingsModel({
    required this.distributorName,
    required this.ownerName,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.defaultCommission,
    required this.language,
  }) : super(
          distributorName: distributorName,
          ownerName: ownerName,
          phone1: phone1,
          phone2: phone2,
          address: address,
          defaultCommission: defaultCommission,
          language: language,
        );

  factory SettingsModel.fromEntity(Settings settings) {
    return SettingsModel(
      distributorName: settings.distributorName,
      ownerName: settings.ownerName,
      phone1: settings.phone1,
      phone2: settings.phone2,
      address: settings.address,
      defaultCommission: settings.defaultCommission,
      language: settings.language,
    );
  }

  factory SettingsModel.defaultSettings() {
    return const SettingsModel(
      distributorName: 'பூ விநியோகம்', // Default Tamil name
      ownerName: '',
      phone1: '',
      phone2: '',
      address: '',
      defaultCommission: 0.0,
      language: 'ta', // Default to Tamil
    );
  }

  SettingsModel copyWith({
    String? distributorName,
    String? ownerName,
    String? phone1,
    String? phone2,
    String? address,
    double? defaultCommission,
    String? language,
  }) {
    return SettingsModel(
      distributorName: distributorName ?? this.distributorName,
      ownerName: ownerName ?? this.ownerName,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      defaultCommission: defaultCommission ?? this.defaultCommission,
      language: language ?? this.language,
    );
  }
}
4. Generate Hive Adapters
Run this command to generate the .g.dart files:
bashflutter pub run build_runner build --delete-conflicting-outputs
5. Data Sources with Hive
Bill Local Data Source
dart// features/billing/data/datasources/bill_local_datasource.dart
import 'package:dartz/dartz.dart';
import '../models/bill_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class BillLocalDataSource {
  Future<Unit> saveBill(BillModel bill);
  Future<List<BillModel>> getAllBills();
  Future<BillModel> getBillById(String id);
  Future<Unit> deleteBill(String id);
}
dart// features/billing/data/datasources/bill_local_datasource_impl.dart
import 'package:hive/hive.dart';
import 'package:dartz/dartz.dart';
import 'bill_local_datasource.dart';
import '../models/bill_model.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../../../core/error/exceptions.dart';

class BillLocalDataSourceImpl implements BillLocalDataSource {
  final Box<BillModel> billBox;

  BillLocalDataSourceImpl({required this.billBox});

  @override
  Future<Unit> saveBill(BillModel bill) async {
    try {
      await billBox.put(bill.id, bill);
      return unit;
    } catch (e) {
      throw CacheException();
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
      throw CacheException();
    }
  }

  @override
  Future<BillModel> getBillById(String id) async {
    try {
      final bill = billBox.get(id);
      if (bill == null) {
        throw CacheException();
      }
      return bill;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> deleteBill(String id) async {
    try {
      await billBox.delete(id);
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }
}
Settings Local Data Source
dart// features/settings/data/datasources/settings_local_datasource.dart
import 'package:hive/hive.dart';
import 'package:dartz/dartz.dart';
import '../models/settings_model.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<Unit> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box<SettingsModel> settingsBox;

  SettingsLocalDataSourceImpl({required this.settingsBox});

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final settings = settingsBox.get(HiveConstants.settingsKey);
      if (settings == null) {
        // Return default settings if none exist
        final defaultSettings = SettingsModel.defaultSettings();
        await saveSettings(defaultSettings);
        return defaultSettings;
      }
      return settings;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> saveSettings(SettingsModel settings) async {
    try {
      await settingsBox.put(HiveConstants.settingsKey, settings);
      return unit;
    } catch (e) {
      throw CacheException();
    }
  }
}
Domain Layer (Entities)
Bill Entity
dart// features/billing/domain/entities/bill.dart
import 'package:equatable/equatable.dart';
import 'bill_item.dart';

class Bill extends Equatable {
  final String id;
  final DateTime date;
  final String shopName;
  final String area;
  final List<BillItem> items;
  final double totalAmount;
  final double commission;
  final double finalPayable;

  const Bill({
    required this.id,
    required this.date,
    required this.shopName,
    required this.area,
    required this.items,
    required this.totalAmount,
    required this.commission,
    required this.finalPayable,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        shopName,
        area,
        items,
        totalAmount,
        commission,
        finalPayable,
      ];
}
Bill Item Entity
dart// features/billing/domain/entities/bill_item.dart
import 'package:equatable/equatable.dart';

class BillItem extends Equatable {
  final String day;
  final double quantity;
  final double rate;
  final double amount;

  const BillItem({
    required this.day,
    required this.quantity,
    required this.rate,
    required this.amount,
  });

  @override
  List<Object?> get props => [day, quantity, rate, amount];
}
Settings Entity
dart// features/settings/domain/entities/settings.dart
import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String distributorName;
  final String ownerName;
  final String phone1;
  final String phone2;
  final String address;
  final double defaultCommission;
  final String language; // 'ta' or 'en'

  const Settings({
    required this.distributorName,
    required this.ownerName,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.defaultCommission,
    required this.language,
  });

  @override
  List<Object?> get props => [
        distributorName,
        ownerName,
        phone1,
        phone2,
        address,
        defaultCommission,
        language,
      ];
}
Repository Implementation with Hive
dart// features/billing/data/repositories/bill_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/bill.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/bill_local_datasource.dart';
import '../models/bill_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

class BillRepositoryImpl implements BillRepository {
  final BillLocalDataSource localDataSource;

  BillRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> saveBill(Bill bill) async {
    try {
      final billModel = BillModel.fromEntity(bill);
      await localDataSource.saveBill(billModel);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Bill>>> getAllBills() async {
    try {
      final bills = await localDataSource.getAllBills();
      return Right(bills);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Bill>> getBillById(String id) async {
    try {
      final bill = await localDataSource.getBillById(id);
      return Right(bill);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBill(String id) async {
    try {
      await localDataSource.deleteBill(id);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
Dependency Injection with Hive
dart// core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../core/constants/hive_constants.dart';
import '../../features/billing/data/datasources/bill_local_datasource.dart';
import '../../features/billing/data/datasources/bill_local_datasource_impl.dart';
import '../../features/billing/data/models/bill_model.dart';
import '../../features/billing/data/repositories/bill_repository_impl.dart';
import '../../features/billing/domain/repositories/bill_repository.dart';
import '../../features/billing/domain/usecases/generate_bill.dart';
import '../../features/billing/domain/usecases/get_all_bills.dart';
import '../../features/billing/presentation/bloc/billing_bloc.dart';

import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/models/settings_model.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/update_settings.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Billing
  
  // Bloc
  sl.registerFactory(
    () => BillingBloc(
      generateBill: sl(),
      getAllBills: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GenerateBill(sl()));
  sl.registerLazySingleton(() => GetAllBills(sl()));
  
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
  
  // Register Hive boxes
  sl.registerLazySingleton<Box<BillModel>>(
    () => Hive.box<BillModel>(HiveConstants.billsBox),
  );
  
  sl.registerLazySingleton<Box<SettingsModel>>(
    () => Hive.box<SettingsModel>(HiveConstants.settingsBox),
  );
}
BLoC Implementation Example
Billing Events
dart// features/billing/presentation/bloc/billing_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/bill.dart';
import '../../../billing/data/models/bill_item_model.dart';

abstract class BillingEvent extends Equatable {
  const BillingEvent();

  @override
  List<Object?> get props => [];
}

class AddBillItemEvent extends BillingEvent {
  final BillItemModel item;

  const AddBillItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveBillItemEvent extends BillingEvent {
  final int index;

  const RemoveBillItemEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateBillItemEvent extends BillingEvent {
  final int index;
  final BillItemModel item;

  const UpdateBillItemEvent(this.index, this.item);

  @override
  List<Object?> get props => [index, item];
}

class GenerateBillEvent extends BillingEvent {
  final String shopName;
  final String area;
  final List<BillItemModel> items;
  final double commission;

  const GenerateBillEvent({
    required this.shopName,
    required this.area,
    required this.items,
    required this.commission,
  });

  @override
  List<Object?> get props => [shopName, area, items, commission];
}

class LoadAllBillsEvent extends BillingEvent {}

class ResetBillFormEvent extends BillingEvent {}
Billing States
dart// features/billing/presentation/bloc/billing_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/bill.dart';
import '../../../billing/data/models/bill_item_model.dart';

abstract class BillingState extends Equatable {
  const BillingState();

  @override
  List<Object?> get props => [];
}

class BillingInitial extends BillingState {
  final List<BillItemModel> items;
  final double totalAmount;
  final double commission;
  final double finalPayable;

  const BillingInitial({
    this.items = const [],
    this.totalAmount = 0.0,
    this.commission = 0.0,
    this.finalPayable = 0.0,
  });

  @override
  List<Object?> get props => [items, totalAmount, commission, finalPayable];

  BillingInitial copyWith({
    List<BillItemModel>? items,
    double? totalAmount,
    double? commission,
    double? finalPayable,
  }) {
    return BillingInitial(
      items: items ?? this.items,Continue10:23 PM  totalAmount: totalAmount ?? this.totalAmount,
  commission: commission ?? this.commission,
  finalPayable: finalPayable ?? this.finalPayable,
);
}
}
class BillingLoading extends BillingState {}
class BillGeneratedSuccess extends BillingState {
final Bill bill;
const BillGeneratedSuccess(this.bill);
@override
List<Object?> get props => [bill];
}
class BillGenerationError extends BillingState {
final String message;
const BillGenerationError(this.message);
@override
List<Object?> get props => [message];
}
class BillsLoaded extends BillingState {
final List<Bill> bills;
const BillsLoaded(this.bills);
@override
List<Object?> get props => [bills];
}

## Localization Setup

### ARB Files
```json
// l10n/app_en.arb
{
  "@@locale": "en",
  "appName": "Flower Billing",
  "home": "Home",
  "records": "Records",
  "settings": "Settings",
  "shopName": "Shop Name",
  "area": "Area",
  "day": "Day",
  "quantity": "Quantity",
  "rate": "Rate",
  "amount": "Amount",
  "total": "Total",
  "commission": "Commission",
  "finalPayable": "Final Payable",
  "generateBill": "Generate Bill",
  "addItem": "Add Item",
  "removeItem": "Remove",
  "distributorName": "Distributor Name",
  "ownerName": "Owner Name",
  "phone": "Phone",
  "address": "Address",
  "defaultCommission": "Default Commission",
  "language": "Language",
  "tamil": "Tamil",
  "english": "English",
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "print": "Print",
  "preview": "Preview",
  "noBills": "No bills found",
  "billSavedSuccess": "Bill saved successfully",
  "errorSavingBill": "Error saving bill"
}
```
```json
// l10n/app_ta.arb
{
  "@@locale": "ta",
  "appName": "பூ பில்லிங்",
  "home": "முகப்பு",
  "records": "பதிவுகள்",
  "settings": "அமைப்புகள்",
  "shopName": "கடை பெயர்",
  "area": "இடம்",
  "day": "தேதி",
  "quantity": "எடை",
  "rate": "விலை",
  "amount": "தொகை",
  "total": "மொத்தம்",
  "commission": "கமிஷன்",
  "finalPayable": "பட்டி",
  "generateBill": "பில் உருவாக்கு",
  "addItem": "சேர்க்கவும்",
  "removeItem": "நீக்கு",
  "distributorName": "விநியோகஸ்தர் பெயர்",
  "ownerName": "உரிமையாளர் பெயர்",
  "phone": "தொலைபேசி",
  "address": "முகவரி",
  "defaultCommission": "இயல்புநிலை கமிஷன்",
  "language": "மொழி",
  "tamil": "தமிழ்",
  "english": "ஆங்கிலம்",
  "save": "சேமிக்கவும்",
  "cancel": "ரத்து செய்",
  "delete": "நீக்கு",
  "print": "அச்சிடு",
  "preview": "முன்னோட்டம்",
  "noBills": "பில்கள் இல்லை",
  "billSavedSuccess": "பில் வெற்றிகரமாக சேமிக்கப்பட்டது",
  "errorSavingBill": "பில் சேமிப்பதில் பிழை"
}
```

## Critical Hive Best Practices

### 1. Always Close Boxes When Not Needed
```dart
@override
void dispose() {
  // Close boxes if needed (usually not required in app lifecycle)
  // Hive.box(HiveConstants.billsBox).close();
  super.dispose();
}
```

### 2. Compact Boxes Periodically
```dart
// Compact box to reclaim space
await billBox.compact();
```

### 3. Handle Migrations
```dart
// If you need to update your model structure
class BillModelV2 extends BillModel {
  @HiveField(8)
  final String? gstNumber; // New field
  
  // Add migration logic in your data source
}
```

### 4. Use Lazy Boxes for Large Data
```dart
// For very large datasets
final lazyBox = await Hive.openLazyBox<BillModel>('bills_lazy');
final bill = await lazyBox.get('id');
```

## Decimal Precision Utility
```dart
// core/utils/decimal_utils.dart
class DecimalUtils {
  /// Rounds to 2 decimal places
  static double roundToTwo(double value) {
    return (value * 100).roundToDouble() / 100;
  }

  /// Formats amount to string with 2 decimals
  static String formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

  /// Safe multiplication with rounding
  static double multiply(double a, double b) {
    return roundToTwo(a * b);
  }

  /// Safe addition with rounding
  static double add(double a, double b) {
    return roundToTwo(a + b);
  }

  /// Safe subtraction with rounding
  static double subtract(double a, double b) {
    return roundToTwo(a - b);
  }
}
```

## Success Criteria with Hive

✅ **Hive Performance**:
- Bill save operation < 100ms
- Bill retrieval < 50ms
- List all bills < 200ms
- Box initialization < 500ms

✅ **Data Integrity**:
- All calculations precise to 2 decimal places
- No data loss on app restart
- Proper error handling for corrupt boxes
- Automatic default settings initialization

✅ **Memory Efficiency**:
- App memory usage < 100MB
- Efficient box compaction
- Lazy loading for large datasets (future)

## Getting Started Prompt for AI Code Generation

When requesting code from AI assistants, use this prompt:

> "Generate Flutter code using BLoC pattern, Clean Architecture, and **Hive local storage** for a [specific feature]. Follow these requirements:
> - Use Tamil and English localization (intl package)
> - Implement [domain/data/presentation] layer for [feature name]
> - Use Hive with type adapters (@HiveType, @HiveField)
> - Store data in offline-first Hive boxes
> - Use vibrant green/violet color scheme
> - Support decimal precision for calculations with DecimalUtils
> - Include error handling with Either<Failure, Success> pattern
> - Inject Hive boxes via get_it dependency injection
> - Write clean, modular, testable code
> 
> Context: Bilingual flower distributor billing app for non-technical users with traditional bill format and thermal printing. All data must persist locally using Hive."

---

**Version**: 1.0  
**Last Updated**: January 2026  
**Target Platform**: Android (Flutter)  
**Architecture**: Clean Architecture + BLoC + Hive  
**Local Storage**: Hive (NoSQL, Type-Safe, Fast)