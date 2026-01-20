import 'package:equatable/equatable.dart';

/// Settings entity for app configuration
class Settings extends Equatable {
  /// Distributor business name
  final String distributorName;
  
  /// Owner's name
  final String ownerName;
  
  /// Primary phone number
  final String phone1;
  
  /// Secondary phone number
  final String phone2;
  
  /// Business address
  final String address;
  
  /// Default commission percentage/amount
  final double defaultCommission;
  
  /// Current language ('ta' for Tamil, 'en' for English)
  final String language;

  const Settings({
    required this.distributorName,
    required this.ownerName,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.defaultCommission,
    required this.language,
  });

  /// Default settings for new installations
  factory Settings.defaultSettings() {
    return const Settings(
      distributorName: 'பூ விநியோகம்', // Default Tamil name
      ownerName: '',
      phone1: '',
      phone2: '',
      address: '',
      defaultCommission: 0.0,
      language: 'ta', // Default to Tamil
    );
  }

  /// Check if language is Tamil
  bool get isTamil => language == 'ta';

  /// Copy with new values
  Settings copyWith({
    String? distributorName,
    String? ownerName,
    String? phone1,
    String? phone2,
    String? address,
    double? defaultCommission,
    String? language,
  }) {
    return Settings(
      distributorName: distributorName ?? this.distributorName,
      ownerName: ownerName ?? this.ownerName,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      defaultCommission: defaultCommission ?? this.defaultCommission,
      language: language ?? this.language,
    );
  }

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
