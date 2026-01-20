import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/print_service.dart';

/// Dialog for selecting a Bluetooth printer
class PrinterSelectionDialog extends StatefulWidget {
  final Function(BluetoothDevice device) onDeviceSelected;

  const PrinterSelectionDialog({super.key, required this.onDeviceSelected});

  @override
  State<PrinterSelectionDialog> createState() => _PrinterSelectionDialogState();
}

class _PrinterSelectionDialogState extends State<PrinterSelectionDialog> {
  final PrintService _printService = PrintService();
  List<BluetoothDevice> _devices = [];
  bool _isLoading = true;
  bool _isConnecting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final devices = await _printService.getPairedDevices();
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load devices: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
    });

    final success = await _printService.connect(device);

    setState(() {
      _isConnecting = false;
    });

    if (success) {
      widget.onDeviceSelected(device);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to printer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingS),
                  decoration: BoxDecoration(
                    gradient: AppConstants.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: const Icon(Icons.print, color: Colors.white, size: 20),
                ),
                const SizedBox(width: AppConstants.paddingM),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Printer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'பிரிண்டர் தேர்வு',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _loadDevices,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),

            // Content
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.paddingL),
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryGreen,
                  ),
                ),
              )
            else if (_error != null)
              _buildErrorState()
            else if (_devices.isEmpty)
              _buildEmptyState()
            else
              _buildDevicesList(),

            const SizedBox(height: AppConstants.paddingM),

            // Help text
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.paddingS),
                  Expanded(
                    child: Text(
                      'Make sure your printer is turned on and paired via Bluetooth settings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            _error ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700),
          ),
          const SizedBox(height: AppConstants.paddingM),
          ElevatedButton(onPressed: _loadDevices, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        children: [
          Icon(Icons.bluetooth_disabled, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            'No paired devices found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'பேர் செய்யப்பட்ட சாதனங்கள் இல்லை',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 250),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          final isConnected =
              _printService.connectedDevice?.address == device.address;

          return Container(
            margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppConstants.primaryGreen.withValues(alpha: 0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: isConnected
                    ? AppConstants.primaryGreen
                    : Colors.grey.shade200,
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.print,
                color: isConnected ? AppConstants.primaryGreen : Colors.grey,
              ),
              title: Text(
                device.name ?? 'Unknown Device',
                style: TextStyle(
                  fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                device.address ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: _isConnecting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : isConnected
                  ? const Icon(
                      Icons.check_circle,
                      color: AppConstants.primaryGreen,
                    )
                  : ElevatedButton(
                      onPressed: () => _connectToDevice(device),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingM,
                        ),
                      ),
                      child: const Text('Connect'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
