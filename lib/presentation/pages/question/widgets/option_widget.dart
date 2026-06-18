import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/answer.dart';

class OptionWidget extends StatelessWidget {
  final Answer option;
  final int index;
  final bool isSelected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const OptionWidget({
    super.key,
    required this.option,
    required this.index,
    required this.isSelected,
    required this.isMultiSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            _buildSelectionIndicator(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    if (isMultiSelect) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? Colors.blue.shade600 : Colors.white,
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      );
    } else {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
            width: 2,
          ),
          color: isSelected ? Colors.blue.shade600 : Colors.white,
        ),
        child: isSelected
            ? const Icon(
                Icons.circle,
                size: 12,
                color: Colors.white,
              )
            : null,
      );
    }
  }
}
