import 'package:flutter/material.dart';

class TextAnswerWidget extends StatefulWidget {
  final String? initialText;
  final int? wordLimit;
  final Function(String) onChanged;

  const TextAnswerWidget({
    super.key,
    this.initialText,
    this.wordLimit,
    required this.onChanged,
  });

  @override
  State<TextAnswerWidget> createState() => _TextAnswerWidgetState();
}

class _TextAnswerWidgetState extends State<TextAnswerWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(TextAnswerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText) {
      _controller.text = widget.initialText ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  String _getWordCountMessage(String text, int maxWords) {
    final currentWords = _countWords(text);
    return 'Current: $currentWords/$maxWords words';
  }

  @override
  Widget build(BuildContext context) {
    final currentWordCount = _countWords(_controller.text);
    final maxWords = widget.wordLimit ?? 300;
    final wordCountMessage = _getWordCountMessage(_controller.text, maxWords);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: 5,
          maxLength: 2000,
          decoration: InputDecoration(
            hintText: 'Type your answer here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _getStatusColor(currentWordCount, maxWords),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _getStatusColor(currentWordCount, maxWords),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {});
            widget.onChanged(value);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              wordCountMessage,
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(currentWordCount, maxWords),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (currentWordCount > maxWords)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  'Word limit exceeded',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        if (widget.wordLimit != null) ...[
          const SizedBox(height: 4),
          Text(
            'Word limit: ${widget.wordLimit} words',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(int currentWords, int maxWords) {
    final percentage = (currentWords / maxWords) * 100;
    
    if (percentage <= 70) {
      return Colors.green.shade600;
    } else if (percentage <= 90) {
      return Colors.orange.shade600;
    } else if (percentage <= 100) {
      return Colors.red.shade600;
    } else {
      return Colors.red.shade800;
    }
  }
}
