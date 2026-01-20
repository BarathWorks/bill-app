/// Hive storage constants for box names, type adapter IDs, and keys
class HiveConstants {
  HiveConstants._();

  // Box Names
  static const String billsBox = 'bills_box';
  static const String settingsBox = 'settings_box';

  // Type Adapters IDs - Must be unique across the app
  static const int billModelTypeId = 0;
  static const int billItemModelTypeId = 1;
  static const int settingsModelTypeId = 2;

  // Keys for single-value boxes
  static const String settingsKey = 'app_settings';
}
