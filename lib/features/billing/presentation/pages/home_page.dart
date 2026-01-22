import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/bill_item.dart';
import '../bloc/billing_bloc.dart';
import '../bloc/billing_event.dart';
import '../bloc/billing_state.dart';
import '../widgets/bill_item_row.dart';
import '../widgets/bill_summary_card.dart';
import 'bill_preview_page.dart';

/// Modern home page for bill creation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _shopNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _commissionController = TextEditingController(text: '0');

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppConstants.animNormal,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _areaController.dispose();
    _commissionController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillingBloc, BillingState>(
      listener: (context, state) {
        if (state is BillGeneratedSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BillPreviewPage(bill: state.bill),
            ),
          ).then((_) {
            context.read<BillingBloc>().add(const ResetBillFormEvent());
            _shopNameController.clear();
            _areaController.clear();
            _commissionController.text = '0';
          });
        } else if (state is BillingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundLight,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildCustomerInfoCard(state),
                        const SizedBox(height: AppConstants.paddingL),
                        _buildItemsSection(state),
                        const SizedBox(height: AppConstants.paddingL),
                        if (state is BillingInitial && state.items.isNotEmpty)
                          BillSummaryCard(
                            totalAmount: state.totalAmount,
                            commission: state.commission,
                            finalPayable: state.finalPayable,
                          ),
                        const SizedBox(height: AppConstants.paddingL),
                        _buildGenerateButton(state),
                        const SizedBox(height: AppConstants.paddingXL),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppConstants.backgroundLight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: AppConstants.paddingM,
          bottom: AppConstants.paddingM,
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppConstants.mixedGradient.createShader(bounds),
                child: const Text(
                  '🌸 Flower Billing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'பூ பில்லிங்',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<BillingBloc>().add(const ResetBillFormEvent());
            _shopNameController.clear();
            _areaController.clear();
            _commissionController.text = '0';
          },
          icon: Container(
            padding: const EdgeInsets.all(AppConstants.paddingS),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: const Icon(Icons.refresh, color: AppConstants.textSecondary),
          ),
        ),
        const SizedBox(width: AppConstants.paddingS),
      ],
    );
  }

  Widget _buildCustomerInfoCard(BillingState state) {
    return Container(
      decoration: AppTheme.glassDecoration,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                decoration: BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: const Icon(
                  Icons.store_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              const Text(
                'Customer Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          _buildTextField(
            controller: _shopNameController,
            label: 'Shop Name / கடை பெயர்',
            hint: 'Enter customer name',
            icon: Icons.person_outline,
            onChanged: (value) {
              context.read<BillingBloc>().add(
                UpdateShopDetailsEvent(shopName: value),
              );
            },
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildTextField(
            controller: _areaController,
            label: 'Area / இடம்',
            hint: 'Enter area/location',
            icon: Icons.location_on_outlined,
            onChanged: (value) {
              context.read<BillingBloc>().add(
                UpdateShopDetailsEvent(area: value),
              );
            },
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildTextField(
            controller: _commissionController,
            label: 'Commission / கமிஷன்',
            hint: '0',
            icon: Icons.percent,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final commission = double.tryParse(value) ?? 0.0;
              context.read<BillingBloc>().add(
                UpdateCommissionEvent(commission),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
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

  Widget _buildItemsSection(BillingState state) {
    final items = state is BillingInitial ? state.items : <BillItem>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingS),
                  decoration: BoxDecoration(
                    gradient: AppConstants.accentGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bill Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    Text(
                      '${items.length} items added',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddItemDialog(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.accentViolet,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM,
                  vertical: AppConstants.paddingS,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        if (items.isEmpty)
          _buildEmptyItemsState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return BillItemRow(
                index: index,
                itemName: item.itemName,
                quantity: item.quantity,
                amount: item.amount,
                onEdit: () => _showEditItemDialog(context, index, item),
                onDelete: () {
                  context.read<BillingBloc>().add(RemoveBillItemEvent(index));
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyItemsState() {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: Colors.grey.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            'No items added yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'Tap "Add" to add bill items',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BillingState state) {
    final isLoading = state is BillingLoading;
    final hasItems = state is BillingInitial && state.items.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: hasItems
            ? AppConstants.primaryGradient
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              ),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: hasItems
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
          onTap: hasItems && !isLoading
              ? () {
                  context.read<BillingBloc>().add(const GenerateBillEvent());
                }
              : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white, size: 24),
                      SizedBox(width: AppConstants.paddingS),
                      Text(
                        'Generate Bill / பில் உருவாக்கு',
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

  void _showAddItemDialog(BuildContext context) {
    final itemNameController = TextEditingController();
    final qtyController = TextEditingController();
    final rateController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXL),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
                const Text(
                  'Add Item / சேர்க்கவும்',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.paddingL),

                // Item Name Field
                TextField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name / பொருள் பெயர்',
                    hintText: 'e.g., Rose, Jasmine, மல்லி',
                    prefixIcon: Icon(Icons.local_florist),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Date Picker
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppConstants.primaryGreen,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: AppConstants.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppConstants.primaryGreen,
                        ),
                        const SizedBox(width: AppConstants.paddingM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date / தேதி',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Quantity and Rate row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Quantity / எடை',
                          hintText: '0.0',
                          prefixIcon: Icon(Icons.scale),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: TextField(
                        controller: rateController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Rate / விலை',
                          hintText: '0',
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingL),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final itemName = itemNameController.text.trim();
                          final qty = double.tryParse(qtyController.text) ?? 0;
                          final rate =
                              double.tryParse(rateController.text) ?? 0;

                          if (itemName.isNotEmpty && qty > 0 && rate > 0) {
                            final item = BillItem.create(
                              itemName: itemName,
                              date: selectedDate,
                              quantity: qty,
                              rate: rate,
                            );
                            this.context.read<BillingBloc>().add(
                              AddBillItemEvent(item),
                            );
                            Navigator.pop(ctx);
                          } else {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Add Item'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, int index, BillItem item) {
    final itemNameController = TextEditingController(text: item.itemName);
    final qtyController = TextEditingController(text: item.quantity.toString());
    final rateController = TextEditingController(text: item.rate.toString());
    DateTime selectedDate = item.date;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXL),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
                const Text(
                  'Edit Item / திருத்து',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.paddingL),

                TextField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name / பொருள் பெயர்',
                    prefixIcon: Icon(Icons.local_florist),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppConstants.primaryGreen,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppConstants.primaryGreen,
                        ),
                        const SizedBox(width: AppConstants.paddingM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date / தேதி',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Quantity / எடை',
                          prefixIcon: Icon(Icons.scale),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: TextField(
                        controller: rateController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Rate / விலை',
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingL),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final itemName = itemNameController.text.trim();
                          final qty = double.tryParse(qtyController.text) ?? 0;
                          final rate =
                              double.tryParse(rateController.text) ?? 0;

                          if (itemName.isNotEmpty && qty > 0 && rate > 0) {
                            final updatedItem = BillItem.create(
                              itemName: itemName,
                              date: selectedDate,
                              quantity: qty,
                              rate: rate,
                            );
                            this.context.read<BillingBloc>().add(
                              UpdateBillItemEvent(index, updatedItem),
                            );
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
