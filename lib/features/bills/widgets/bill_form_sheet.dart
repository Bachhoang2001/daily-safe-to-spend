import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';
import 'package:safe_to_spend/core/theme/app_spacing.dart';
import 'package:safe_to_spend/core/widgets/amount_keypad.dart';
import 'package:safe_to_spend/core/widgets/app_bottom_sheet.dart';
import 'package:safe_to_spend/core/widgets/primary_button.dart';
import 'package:safe_to_spend/data/models/onboarding_draft.dart';

/// Modal bottom sheet for adding or editing recurring bills.
///
/// Shared between Onboarding (Spec 009) and Bill Management (Spec 015).
class BillFormSheet extends StatefulWidget {
  /// Creates an instance of [BillFormSheet].
  const BillFormSheet({
    required this.currency,
    required this.initialDate,
    required this.onSave,
    this.initialBill,
    this.suggestedName,
    this.uuidGenerator = const DefaultUuidGenerator(),
    super.key,
  });

  /// The active currency ISO code (e.g. 'USD').
  final String currency;

  /// The reference starting date (typically today).
  final LocalDate initialDate;

  /// Existing bill draft if editing.
  final OnboardingBillDraft? initialBill;

  /// Pre-filled bill name from suggestion chip.
  final String? suggestedName;

  /// Callback emitted with the constructed or updated bill draft.
  final ValueChanged<OnboardingBillDraft> onSave;

  /// UUID generator for creating unique bill IDs.
  final UuidGenerator uuidGenerator;

  /// Helper to display this sheet using the standard bottom sheet style.
  static Future<void> show({
    required BuildContext context,
    required String currency,
    required LocalDate initialDate,
    required ValueChanged<OnboardingBillDraft> onSave,
    OnboardingBillDraft? initialBill,
    String? suggestedName,
    UuidGenerator uuidGenerator = const DefaultUuidGenerator(),
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BillFormSheet(
        currency: currency,
        initialDate: initialDate,
        initialBill: initialBill,
        suggestedName: suggestedName,
        onSave: onSave,
        uuidGenerator: uuidGenerator,
      ),
    );
  }

  @override
  State<BillFormSheet> createState() => _BillFormSheetState();
}

class _BillFormSheetState extends State<BillFormSheet> {
  late final TextEditingController _nameController;
  late Money _amount;
  late BillRecurrence _recurrence;
  late LocalDate _dueDate;
  String? _nameError;
  String? _amountError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    final initialName = widget.initialBill?.name ?? widget.suggestedName ?? '';
    _nameController = TextEditingController(text: initialName);
    _amount = widget.initialBill?.amount ?? Money.zero(widget.currency);
    _recurrence = widget.initialBill?.recurrence ?? BillRecurrence.monthly;
    _dueDate = widget.initialBill?.firstDueDate ?? widget.initialDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final nowDt = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    final initialDt = DateTime(_dueDate.year, _dueDate.month, _dueDate.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDt.isBefore(nowDt) ? nowDt : initialDt,
      firstDate: nowDt,
      lastDate: nowDt.add(const Duration(days: 365 * 3)),
    );

    if (picked != null) {
      setState(() {
        _dueDate = LocalDate(picked.year, picked.month, picked.day);
        _dateError = null;
      });
    }
  }

  void _onSavePressed() {
    final l10n = AppLocalizations.of(context)!;
    final trimmedName = _nameController.text.trim();

    String? nameErr;
    String? amtErr;
    String? dateErr;

    if (trimmedName.isEmpty) {
      nameErr = l10n.validationBillNameRequired;
    } else if (trimmedName.length > 40) {
      nameErr = l10n.validationBillNameTooLong;
    }

    if (_amount.cents <= 0) {
      amtErr = l10n.validationBillAmountPositive;
    }

    if (_dueDate.isBefore(widget.initialDate)) {
      dateErr = l10n.validationBillDatePast;
    }

    setState(() {
      _nameError = nameErr;
      _amountError = amtErr;
      _dateError = dateErr;
    });

    if (nameErr != null || amtErr != null || dateErr != null) {
      return;
    }

    final billId = widget.initialBill?.id ?? widget.uuidGenerator.generate();
    final bill = OnboardingBillDraft(
      id: billId,
      name: trimmedName,
      amount: _amount,
      recurrence: _recurrence,
      firstDueDate: _dueDate,
    );

    widget.onSave(bill);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.initialBill != null;
    final title = isEditing ? l10n.editBill : l10n.addBill;

    return AppBottomSheet(
      title: title,
      padding: EdgeInsets.only(
        left: AppSpacing.l,
        right: AppSpacing.l,
        top: AppSpacing.m,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bill Name
          TextFormField(
            controller: _nameController,
            maxLength: 40,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.billNameLabel,
              errorText: _nameError,
              filled: true,
              fillColor: isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceVariantLight,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusCard,
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            onChanged: (v) {
              if (_nameError != null) {
                setState(() => _nameError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.s),

          // Amount display
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.m,
              horizontal: AppSpacing.l,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceVariantLight,
              borderRadius: AppSpacing.borderRadiusCard,
              border: Border.all(
                color: _amountError != null
                    ? AppColors.over
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            child: Column(
              children: [
                Text(
                  l10n.billAmountLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  MoneyFormatter.format(_amount),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                if (_amountError != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _amountError!,
                    style: const TextStyle(color: AppColors.over, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s),

          // Amount Keypad
          AmountKeypad(
            initialCents: _amount.cents,
            onChanged: (money) {
              setState(() {
                _amount = Money(money.cents, widget.currency);
                _amountError = null;
              });
            },
          ),
          const SizedBox(height: AppSpacing.m),

          // First Due Date Selector
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectDueDate,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(
                    '${l10n.billDueDateLabel}: ${_dueDate.toIsoString()}',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                    side: BorderSide(
                      color: _dateError != null
                          ? AppColors.over
                          : (isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_dateError != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _dateError!,
              style: const TextStyle(color: AppColors.over, fontSize: 12),
            ),
          ],
          const SizedBox(height: AppSpacing.m),

          // Recurrence ChoiceChips
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            alignment: WrapAlignment.center,
            children: [
              ChoiceChip(
                label: Text(l10n.recurrenceWeekly),
                selected: _recurrence == BillRecurrence.weekly,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _recurrence = BillRecurrence.weekly);
                  }
                },
              ),
              ChoiceChip(
                label: Text(l10n.recurrenceMonthly),
                selected: _recurrence == BillRecurrence.monthly,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _recurrence = BillRecurrence.monthly);
                  }
                },
              ),
              ChoiceChip(
                label: Text(l10n.recurrenceYearly),
                selected: _recurrence == BillRecurrence.yearly,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _recurrence = BillRecurrence.yearly);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),

          // Save / Add Bill Button
          PrimaryButton(label: l10n.saveChanges, onPressed: _onSavePressed),
        ],
      ),
    );
  }
}
