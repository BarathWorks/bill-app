import 'package:hive/hive.dart';
import '../../domain/entities/settings.dart';
import '../../../../core/constants/hive_constants.dart';

part 'settings_model.g.dart';

/// Hive model for Settings entity
@HiveType(typeId: HiveConstants.settingsModelTypeId)
class SettingsModel extends Settings {
  @override
  @HiveField(0)
  final String distributorName;

  @override
  @HiveField(1)
  final String ownerName;

  @override
  @HiveField(2)
  final String phone1;

  @override
  @HiveField(3)
  final String phone2;

  @override
  @HiveField(4)
  final String address;

  @override
  @HiveField(5)
  final double defaultCommission;

  @override
  @HiveField(6)
  final String language;

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

  /// Create model from entity
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

  /// Default settings for new installations
  factory SettingsModel.defaultSettings() {
    return const SettingsModel(
      distributorName: 'பூ விநியோகம்',
      ownerName: '',
      phone1: '',
      phone2: '',
      address: '',
      defaultCommission: 0.0,
      language: 'ta',
    );
  }

  /// Convert to entity
  Settings toEntity() {
    return Settings(
      distributorName: distributorName,
      ownerName: ownerName,
      phone1: phone1,
      phone2: phone2,
      address: address,
      defaultCommission: defaultCommission,
      language: language,
    );
  }

  @override
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
