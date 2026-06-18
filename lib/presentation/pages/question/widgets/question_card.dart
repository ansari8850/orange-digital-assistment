import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/question.dart';
import '../../../domain/entities/user_response.dart';
import 'option_widget.dart';
import 'text_answer_widget.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final UserResponse response;
  final Function(List<String>, String?) onAnswerChanged;

  const QuestionCard({
    super.key,
    required this.question,
    required this.response,
    required this.onAnswerChanged,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  List<String> selectedAnswerIds = [];
  String? textAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswerIds = List.from(widget.response.selectedAnswerIds);
    textAnswer = widget.response.textAnswer;
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id || oldWidget.response != widget.response) {
      setState(() {
        selectedAnswerIds = List.from(widget.response.selectedAnswerIds);
        textAnswer = widget.response.textAnswer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.question.isComprehension && widget.question.passage != null) ...[
            _buildPassage(context),
            const SizedBox(height: 24),
          ],
          _buildQuestionText(context),
          const SizedBox(height: 24),
          _buildAnswerOptions(context),
        ],
      ),
    );
  }

  Widget _buildPassage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passage',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.question.passage!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    return Text(
      widget.question.text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAnswerOptions(BuildContext context) {
    switch (widget.question.type) {
      case QuestionType.objective:
      case QuestionType.trueFalse:
        return _buildSingleChoiceOptions(context);
      case QuestionType.multiSelect:
        return _buildMultiSelectOptions(context);
      case QuestionType.subjective:
        return TextAnswerWidget(
          initialText: textAnswer,
          wordLimit: widget.question.wordLimit,
          onChanged: (value) {
            textAnswer = value;
            widget.onAnswerChanged(selectedAnswerIds, textAnswer);
          },
        );
      case QuestionType.comprehension:
        return _buildComprehensionOptions(context);
    }
  }

  Widget _buildSingleChoiceOptions(BuildContext context) {
    return Column(
      children: widget.question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = selectedAnswerIds.contains(option.id);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OptionWidget(
            option: option,
            index: index,
            isSelected: isSelected,
            isMultiSelect: false,
            onTap: () {
              setState(() {
                selectedAnswerIds = [option.id];
              });
              widget.onAnswerChanged(selectedAnswerIds, textAnswer);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiSelectOptions(BuildContext context) {
    return Column(
      children: widget.question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = selectedAnswerIds.contains(option.id);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OptionWidget(
            option: option,
            index: index,
            isSelected: isSelected,
            isMultiSelect: true,
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedAnswerIds.remove(option.id);
                } else {
                  selectedAnswerIds.add(option.id);
                }
              });
              widget.onAnswerChanged(selectedAnswerIds, textAnswer);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComprehensionOptions(BuildContext context) {
    // For comprehension questions, treat them like objective questions
    return _buildSingleChoiceOptions(context);
  }
}
