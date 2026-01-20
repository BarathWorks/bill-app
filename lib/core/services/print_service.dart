import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../../features/billing/domain/entities/bill.dart';
import '../utils/decimal_utils.dart';

/// Service for handling Bluetooth thermal printing
class PrintService {
  static final PrintService _instance = PrintService._internal();
  factory PrintService() => _instance;
  PrintService._internal();

  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;
  BluetoothDevice? _connectedDevice;

  /// Check if printer is connected
  Future<bool> get isConnected async {
    try {
      return await _printer.isConnected ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get list of paired Bluetooth devices
  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      // Request Bluetooth permissions
      await _requestPermissions();

      final devices = await _printer.getBondedDevices();
      return devices;
    } catch (e) {
      print('Error getting devices: $e');
      return [];
    }
  }

  /// Request necessary permissions
  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    return statuses.values.every(
      (status) => status == PermissionStatus.granted,
    );
  }

  /// Connect to a Bluetooth device
  Future<bool> connect(BluetoothDevice device) async {
    try {
      if (await isConnected) {
        await disconnect();
      }
      await _printer.connect(device);
      _connectedDevice = device;
      return true;
    } catch (e) {
      print('Error connecting: $e');
      return false;
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    try {
      await _printer.disconnect();
      _connectedDevice = null;
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }

  /// Print a bill
  Future<bool> printBill({
    required Bill bill,
    String distributorName = 'பூ விநியோகம்',
    String ownerName = '',
    String phone1 = '',
    String phone2 = '',
    String address = '',
    bool isTamil = true,
  }) async {
    try {
      if (!await isConnected) {
        return false;
      }

      // Start printing
      await _printer.printNewLine();

      // Header - Distributor Name (Center aligned)
      await _printer.printCustom(distributorName, 3, 1);

      if (ownerName.isNotEmpty) {
        await _printer.printCustom(ownerName, 1, 1);
      }

      if (address.isNotEmpty) {
        await _printer.printCustom(address, 0, 1);
      }

      // Phone numbers
      final phones = [phone1, phone2].where((p) => p.isNotEmpty).join(' / ');
      if (phones.isNotEmpty) {
        await _printer.printCustom(phones, 0, 1);
      }

      await _printer.printCustom('--------------------------------', 1, 1);

      // Bill details
      final dateStr = DateFormat('dd/MM/yyyy').format(bill.date);
      final billNo = bill.id.substring(0, 8).toUpperCase();

      await _printer.printLeftRight(isTamil ? 'தேதி:' : 'Date:', dateStr, 1);
      await _printer.printLeftRight(
        isTamil ? 'பில் எண்:' : 'Bill No:',
        billNo,
        1,
      );

      // Customer info
      await _printer.printLeftRight(
        isTamil ? 'கடை:' : 'Shop:',
        bill.shopName,
        1,
      );
      if (bill.area.isNotEmpty) {
        await _printer.printLeftRight(
          isTamil ? 'இடம்:' : 'Area:',
          bill.area,
          1,
        );
      }

      await _printer.printCustom('--------------------------------', 1, 1);

      // Items header
      await _printer.printCustom(
        isTamil
            ? 'பொருள்    எடை   விலை   தொகை'
            : 'Item      Qty   Rate   Amount',
        1,
        0,
      );
      await _printer.printCustom('--------------------------------', 1, 1);

      // Items
      for (final item in bill.items) {
        final name = item.itemName.length > 10
            ? '${item.itemName.substring(0, 10)}'
            : item.itemName.padRight(10);
        final qty = item.quantity.toStringAsFixed(1).padLeft(5);
        final rate = item.rate.toStringAsFixed(0).padLeft(5);
        final amount = item.amount.toStringAsFixed(2).padLeft(7);

        await _printer.printCustom('$name$qty$rate$amount', 0, 0);
      }

      await _printer.printCustom('--------------------------------', 1, 1);

      // Summary
      await _printer.printLeftRight(
        isTamil ? 'மொத்தம்:' : 'Total:',
        DecimalUtils.formatIndianCurrency(bill.totalAmount),
        1,
      );

      if (bill.commission > 0) {
        await _printer.printLeftRight(
          isTamil ? 'கமிஷன்:' : 'Commission:',
          '- ${DecimalUtils.formatIndianCurrency(bill.commission)}',
          1,
        );
      }

      await _printer.printCustom('================================', 1, 1);

      // Final payable (Large & Bold)
      await _printer.printLeftRight(
        isTamil ? 'பட்டி:' : 'PAYABLE:',
        DecimalUtils.formatIndianCurrency(bill.finalPayable),
        2,
      );

      await _printer.printCustom('================================', 1, 1);

      // Footer
      await _printer.printNewLine();
      await _printer.printCustom(
        isTamil ? '*** நன்றி ***' : '*** Thank You ***',
        1,
        1,
      );

      // Feed paper
      await _printer.printNewLine();
      await _printer.printNewLine();
      await _printer.printNewLine();

      return true;
    } catch (e) {
      print('Error printing: $e');
      return false;
    }
  }

  /// Get connected device
  BluetoothDevice? get connectedDevice => _connectedDevice;
}
