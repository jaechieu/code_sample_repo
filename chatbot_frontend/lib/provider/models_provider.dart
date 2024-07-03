import 'package:chatbot_frontend/models/models_model.dart';
import 'package:chatbot_frontend/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = 'babbage';

  Future<List<ModelsModel>> get getAllModelsProvider {
    return ApiService.getModels();
  }

  String get getCurrentModel {
    return currentModel;
  }

  String setCurrentModel(String newModel) {
    currentModel = newModel;
    return currentModel;
  }
}
