import 'package:bill_app/core/constants/app_constants.dart';
import 'package:bill_app/core/theme/app_theme.dart';
import 'package:bill_app/core/utils/decimal_utils.dart';
import 'package:flutter/material.dart';

/// Glassmorphic summary card showing bill totals
class BillSummaryCard extends StatelessWidget {
  final double totalAmount;
  final double commission;
  final double finalPayable;
  final bool isCompact;

  const BillSummaryCard({
    super.key,
    required this.totalAmount,
    required this.commission,
    required this.finalPayable,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.gradientCardDecoration(
        gradient: AppConstants.mixedGradient,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isCompact ? AppConstants.paddingM : AppConstants.paddingL,
        ),
        child: Column(
          children: [
            // Total Row
            _buildSummaryRow(
              label: 'Total',
              labelTamil: 'மொத்தம்',
              amount: totalAmount,
              isLarge: false,
            ),
            
            Divider(
              color: Colors.white.withValues(alpha: 0.3),
              height: AppConstants.paddingM * 2,
            ),
            
            // Commission Row
            _buildSummaryRow(
              label: 'Commission',
              labelTamil: 'கமிஷன்',
              amount: commission,
              isLarge: false,
              isNegative: true,
            ),
            
            const SizedBox(height: AppConstants.paddingS),
            
            // Final Payable Row
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: _buildSummaryRow(
                label: 'Final Payable',
                labelTamil: 'பட்டி',
                amount: finalPayable,
                isLarge: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String labelTamil,
    required double amount,
    required bool isLarge,
    bool isNegative = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            Text(
              labelTamil,
              style: TextStyle(
                fontSize: isLarge ? 12 : 10,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (isNegative && amount > 0)
              Text(
                '- ',
                style: TextStyle(
                  fontSize: isLarge ? 24 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            Text(
              DecimalUtils.formatIndianCurrency(amount),
              style: TextStyle(
                fontSize: isLarge ? 24 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Compact horizontal summary for list items
class BillSummaryChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color? backgroundColor;
  final Color? textColor;

  const BillSummaryChip({
    super.key,
    required this.label,
    required this.amount,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor ?? AppConstants.primaryGreen,
            ),
          ),
          const SizedBox(width: AppConstants.paddingS),
          Text(
            DecimalUtils.formatIndianCurrency(amount),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor ?? AppConstants.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
