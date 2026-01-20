import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/print_service.dart';
import '../../domain/entities/bill.dart';
import '../widgets/traditional_bill_widget.dart';
import '../widgets/printer_selection_dialog.dart';

/// Bill preview page with traditional format and print/share actions
class BillPreviewPage extends StatefulWidget {
  final Bill bill;

  const BillPreviewPage({super.key, required this.bill});

  @override
  State<BillPreviewPage> createState() => _BillPreviewPageState();
}

class _BillPreviewPageState extends State<BillPreviewPage> {
  final PrintService _printService = PrintService();
  bool _isPrinting = false;

  Future<void> _handlePrint() async {
    // Check if already connected
    final isConnected = await _printService.isConnected;

    if (!isConnected) {
      // Show printer selection dialog
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (ctx) => PrinterSelectionDialog(
          onDeviceSelected: (BluetoothDevice device) {
            // After connection, print the bill
            _printBill();
          },
        ),
      );
    } else {
      // Already connected, print directly
      await _printBill();
    }
  }

  Future<void> _printBill() async {
    setState(() {
      _isPrinting = true;
    });

    try {
      final success = await _printService.printBill(
        bill: widget.bill,
        isTamil: true,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Bill printed successfully! / பில் அச்சிடப்பட்டது!'),
              ],
            ),
            backgroundColor: AppConstants.primaryGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Failed to print. Please check printer connection.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _handlePrint,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bill Preview', style: TextStyle(fontSize: 18)),
            Text(
              'பில் முன்னோட்டம்',
              style: TextStyle(fontSize: 12, color: AppConstants.textSecondary),
            ),
          ],
        ),
        backgroundColor: AppConstants.backgroundLight,
        elevation: 0,
        actions: [
          // Printer status indicator
          FutureBuilder<bool>(
            future: _printService.isConnected,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.paddingS),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isConnected ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.print,
                      size: 20,
                      color: isConnected
                          ? AppConstants.primaryGreen
                          : Colors.grey,
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bill Preview
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: TraditionalBillWidget(bill: widget.bill, isTamil: true),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Print Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isPrinting ? null : _handlePrint,
                      icon: _isPrinting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.print),
                      label: Text(
                        _isPrinting ? 'Printing...' : 'Print / அச்சிடு',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                        backgroundColor: AppConstants.accentViolet,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),

                  // Done Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Done / முடிந்தது'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                        backgroundColor: AppConstants.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
