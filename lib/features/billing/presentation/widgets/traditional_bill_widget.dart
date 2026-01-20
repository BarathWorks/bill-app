import 'package:bill_app/core/constants/app_constants.dart';
import 'package:bill_app/core/utils/date_formatter.dart';
import 'package:bill_app/core/utils/decimal_utils.dart';
import 'package:bill_app/features/billing/domain/entities/bill.dart';
import 'package:flutter/material.dart';

/// Widget that renders bill in traditional handwritten format
class TraditionalBillWidget extends StatelessWidget {
  final Bill bill;
  final String distributorName;
  final String ownerName;
  final String phone1;
  final String phone2;
  final String address;
  final bool isTamil;

  const TraditionalBillWidget({
    super.key,
    required this.bill,
    this.distributorName = 'பூ விநியோகம்',
    this.ownerName = '',
    this.phone1 = '',
    this.phone2 = '',
    this.address = '',
    this.isTamil = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5), // Cream paper color
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: Colors.brown.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(),

          const Divider(color: Colors.brown, thickness: 1.5),

          // Customer Info
          _buildCustomerInfo(),

          const SizedBox(height: AppConstants.paddingM),

          // Items Table
          _buildItemsTable(),

          const Divider(color: Colors.brown, thickness: 1.5),

          // Summary
          _buildSummary(),

          const SizedBox(height: AppConstants.paddingL),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Decorative flower
        Text(
          '🌸 ✿ 🌸',
          style: TextStyle(fontSize: 24, color: Colors.pink.shade300),
        ),
        const SizedBox(height: AppConstants.paddingS),

        // Distributor Name
        Text(
          distributorName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        if (ownerName.isNotEmpty) ...[
          const SizedBox(height: AppConstants.paddingXS),
          Text(
            ownerName,
            style: TextStyle(fontSize: 14, color: Colors.brown.shade600),
            textAlign: TextAlign.center,
          ),
        ],

        if (address.isNotEmpty) ...[
          const SizedBox(height: AppConstants.paddingXS),
          Text(
            address,
            style: TextStyle(fontSize: 12, color: Colors.brown.shade500),
            textAlign: TextAlign.center,
          ),
        ],

        if (phone1.isNotEmpty || phone2.isNotEmpty) ...[
          const SizedBox(height: AppConstants.paddingXS),
          Text(
            [phone1, phone2].where((p) => p.isNotEmpty).join(' / '),
            style: TextStyle(fontSize: 12, color: Colors.brown.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.brown.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoField(isTamil ? 'கடை' : 'Shop', bill.shopName),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildInfoField(isTamil ? 'இடம்' : 'Area', bill.area),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  isTamil ? 'தேதி' : 'Date',
                  DateFormatter.formatDate(bill.date),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildInfoField(
                  isTamil ? 'பில் எண்' : 'Bill No',
                  bill.id.substring(0, 8).toUpperCase(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, color: Colors.brown.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable() {
    return Table(
      border: TableBorder.all(color: Colors.brown.shade300, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
      },
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(color: Colors.brown.shade100),
          children: [
            _buildTableCell(isTamil ? 'பொருள்' : 'Item', isHeader: true),
            _buildTableCell(isTamil ? 'எடை' : 'Qty', isHeader: true),
            _buildTableCell(isTamil ? 'விலை' : 'Rate', isHeader: true),
            _buildTableCell(isTamil ? 'தொகை' : 'Amount', isHeader: true),
          ],
        ),
        // Items
        ...bill.items.map(
          (item) => TableRow(
            children: [
              _buildTableCell(item.itemName),
              _buildTableCell(item.quantity.toStringAsFixed(1)),
              _buildTableCell('₹${item.rate.toStringAsFixed(0)}'),
              _buildTableCell('₹${item.amount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingS),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 12 : 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.brown.shade800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: Column(
        children: [
          _buildSummaryRow(
            isTamil ? 'மொத்தம்' : 'Total',
            DecimalUtils.formatIndianCurrency(bill.totalAmount),
          ),
          const SizedBox(height: AppConstants.paddingXS),
          _buildSummaryRow(
            isTamil ? 'கமிஷன்' : 'Commission',
            '- ${DecimalUtils.formatIndianCurrency(bill.commission)}',
            isSubtle: true,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppConstants.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
              border: Border.all(color: AppConstants.primaryGreen, width: 2),
            ),
            child: _buildSummaryRow(
              isTamil ? 'பட்டி' : 'Payable',
              DecimalUtils.formatIndianCurrency(bill.finalPayable),
              isLarge: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isLarge = false,
    bool isSubtle = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
            color: isSubtle ? Colors.brown.shade400 : Colors.brown.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 20 : 15,
            fontWeight: FontWeight.bold,
            color: isLarge ? AppConstants.primaryGreen : Colors.brown.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isTamil ? 'கையெழுத்து' : 'Signature',
              style: TextStyle(fontSize: 12, color: Colors.brown.shade500),
            ),
            Container(
              width: 120,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.brown.shade300, width: 1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingL),
        Text(
          '🌺 ${isTamil ? 'நன்றி' : 'Thank You'} 🌺',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.brown.shade600,
          ),
        ),
      ],
    );
  }
}
