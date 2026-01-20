import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/settings.dart';

/// Abstract repository interface for settings operations
abstract class SettingsRepository {
  /// Get current app settings
  Future<Either<Failure, Settings>> getSettings();
  
  /// Save/update app settings
  Future<Either<Failure, Unit>> saveSettings(Settings settings);
}
