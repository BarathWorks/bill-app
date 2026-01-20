import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/settings.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

/// Modern settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _distributorNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _addressController = TextEditingController();
  final _commissionController = TextEditingController();
  String _selectedLanguage = 'ta';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  @override
  void dispose() {
    _distributorNameController.dispose();
    _ownerNameController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _addressController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  void _populateFields(Settings settings) {
    _distributorNameController.text = settings.distributorName;
    _ownerNameController.text = settings.ownerName;
    _phone1Controller.text = settings.phone1;
    _phone2Controller.text = settings.phone2;
    _addressController.text = settings.address;
    _commissionController.text = settings.defaultCommission.toString();
    _selectedLanguage = settings.language;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded) {
          _populateFields(state.settings);
        } else if (state is SettingsUpdated) {
          setState(() {
            _hasChanges = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppConstants.primaryGreen,
            ),
          );
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundLight,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Content
                Expanded(
                  child: state is SettingsLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.primaryGreen,
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(AppConstants.paddingM),
                          child: Column(
                            children: [
                              // Business Info Card
                              _buildBusinessInfoCard(),
                              
                              const SizedBox(height: AppConstants.paddingL),
                              
                              // Contact Info Card
                              _buildContactInfoCard(),
                              
                              const SizedBox(height: AppConstants.paddingL),
                              
                              // Preferences Card
                              _buildPreferencesCard(),
                              
                              const SizedBox(height: AppConstants.paddingL),
                              
                              // Save Button
                              _buildSaveButton(),
                              
                              const SizedBox(height: AppConstants.paddingXL),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                Text(
                  'அமைப்புகள்',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_hasChanges)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingS,
                vertical: AppConstants.paddingXS,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: const Text(
                'Unsaved',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return Container(
      decoration: AppTheme.glassDecoration,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Business Information',
            'வணிக தகவல்',
            Icons.business,
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          _buildTextField(
            controller: _distributorNameController,
            label: 'Distributor Name / விநியோகஸ்தர் பெயர்',
            hint: 'Enter business name',
            icon: Icons.store,
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          _buildTextField(
            controller: _ownerNameController,
            label: 'Owner Name / உரிமையாளர் பெயர்',
            hint: 'Enter owner name',
            icon: Icons.person,
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          _buildTextField(
            controller: _addressController,
            label: 'Address / முகவரி',
            hint: 'Enter business address',
            icon: Icons.location_on,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard() {
    return Container(
      decoration: AppTheme.glassDecoration,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Contact Information',
            'தொடர்பு தகவல்',
            Icons.phone,
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          _buildTextField(
            controller: _phone1Controller,
            label: 'Phone 1 / தொலைபேசி 1',
            hint: 'Enter phone number',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          _buildTextField(
            controller: _phone2Controller,
            label: 'Phone 2 / தொலைபேசி 2',
            hint: 'Enter alternate phone (optional)',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      decoration: AppTheme.glassDecoration,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Preferences',
            'விருப்பங்கள்',
            Icons.tune,
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          _buildTextField(
            controller: _commissionController,
            label: 'Default Commission / இயல்பு கமிஷன்',
            hint: '0',
            icon: Icons.percent,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Language Selector
          const Text(
            'Language / மொழி',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          Row(
            children: [
              Expanded(
                child: _buildLanguageOption(
                  'ta',
                  'தமிழ்',
                  'Tamil',
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildLanguageOption(
                  'en',
                  'English',
                  'ஆங்கிலம்',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingS),
          decoration: BoxDecoration(
            gradient: AppConstants.mixedGradient,
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: AppConstants.paddingM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: (_) {
        if (!_hasChanges) {
          setState(() {
            _hasChanges = true;
          });
        }
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppConstants.primaryGreen),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          borderSide: const BorderSide(
            color: AppConstants.primaryGreen,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String primary, String secondary) {
    final isSelected = _selectedLanguage == code;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
          _hasChanges = true;
        });
      },
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryGreen.withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isSelected
                ? AppConstants.primaryGreen
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              primary,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppConstants.primaryGreen
                    : AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              secondary,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppConstants.primaryGreen
                    : AppConstants.textSecondary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: AppConstants.paddingS),
              const Icon(
                Icons.check_circle,
                color: AppConstants.primaryGreen,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _hasChanges
            ? AppConstants.primaryGradient
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              ),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: _hasChanges
            ? [
                BoxShadow(
                  color: AppConstants.primaryGreen.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _hasChanges ? _saveSettings : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: AppConstants.paddingS),
                Text(
                  'Save Settings / சேமி',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    final settings = Settings(
      distributorName: _distributorNameController.text,
      ownerName: _ownerNameController.text,
      phone1: _phone1Controller.text,
      phone2: _phone2Controller.text,
      address: _addressController.text,
      defaultCommission: double.tryParse(_commissionController.text) ?? 0.0,
      language: _selectedLanguage,
    );

    context.read<SettingsBloc>().add(UpdateSettingsEvent(settings));
  }
}
