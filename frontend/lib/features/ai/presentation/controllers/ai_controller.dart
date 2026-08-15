import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_ai.dart';
import '../../domain/entities/ai.dart';

class AiController extends ChangeNotifier {
  final GetAI getAI;

  AiController({required this.getAI});

  bool isLoading = false;
  String? errorMessage;
  AIResponse? response;

  Future<void> sendQuery(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      response = await getAI.call(query: query);
    } catch (e) {
      errorMessage = e.toString();
      response = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
