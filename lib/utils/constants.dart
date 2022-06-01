import 'package:flutter/foundation.dart';

String endpoint =
    [TargetPlatform.android, TargetPlatform.iOS].contains(defaultTargetPlatform)
        ? "http://10.0.2.2:8080/api"
        : "http://localhost:8080/api";
