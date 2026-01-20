import 'package:equatable/equatable.dart';
import '../../domain/entities/settings.dart';

/// Base class for settings states
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial settings state
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading settings
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Settings loaded successfully
class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Settings updated successfully
class SettingsUpdated extends SettingsState {
  final Settings settings;
  final String message;

  const SettingsUpdated(this.settings, [this.message = 'Settings saved successfully']);

  @override
  List<Object?> get props => [settings, message];
}

/// Settings error
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
