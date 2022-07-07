import 'dart:async';

import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/utils/storage.dart';

class Guard {
  static checkAuth(StreamController<bool> streamController) async {
    try {
      HttpResponse response = await UserService().getUser();
      streamController.add(response.success());
    } on Exception catch (_) {
      String token = await Storage.getToken();
      streamController.add(token.isNotEmpty);
    }
  }
}
