import 'package:equatable/equatable.dart';
import '../../domain/entities/settings.dart';

/// Base class for settings events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load current settings
class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Update settings
class UpdateSettingsEvent extends SettingsEvent {
  final Settings settings;

  const UpdateSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Change app language
class ChangeLanguageEvent extends SettingsEvent {
  final String language; // 'ta' or 'en'

  const ChangeLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}
