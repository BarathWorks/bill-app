import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../models/settings_model.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../../../core/error/exceptions.dart';

/// Abstract data source interface for settings operations
abstract class SettingsLocalDataSource {
  /// Get current app settings
  Future<SettingsModel> getSettings();
  
  /// Save app settings
  Future<Unit> saveSettings(SettingsModel settings);
}

/// Hive implementation of settings local data source
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box<SettingsModel> settingsBox;

  SettingsLocalDataSourceImpl({required this.settingsBox});

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final settings = settingsBox.get(HiveConstants.settingsKey);
      if (settings == null) {
        // Initialize with default settings if none exist
        final defaultSettings = SettingsModel.defaultSettings();
        await saveSettings(defaultSettings);
        return defaultSettings;
      }
      return settings;
    } catch (e) {
      throw CacheException('Failed to get settings: $e');
    }
  }

  @override
  Future<Unit> saveSettings(SettingsModel settings) async {
    try {
      await settingsBox.put(HiveConstants.settingsKey, settings);
      return unit;
    } catch (e) {
      throw CacheException('Failed to save settings: $e');
    }
  }
}
