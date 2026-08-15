import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/ai_controller.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final AiController controller = GetIt.instance<AiController>();
  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Ask the AI',
                hintText: 'Type a travel question, e.g. "Find flights to NYC"',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                controller.sendQuery(value.trim());
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: controller.isLoading
                  ? null
                  : () {
                      controller.sendQuery(_queryController.text.trim());
                    },
              child: controller.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text('Send'),
            ),
            const SizedBox(height: 24),
            if (controller.errorMessage != null) ...[
              Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
            ],
            if (controller.response != null) ...[
              const Text(
                'AI Answer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    controller.response!.answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ] else if (!controller.isLoading) ...[
              const Expanded(
                child: Center(
                  child: Text(
                    'Ask anything about flights, booking, or travel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
