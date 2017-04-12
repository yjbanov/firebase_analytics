import 'dart:async';

import 'package:flutter/services.dart';

/// Firebase Analytics API.
class FirebaseAnalytics {
  static const PlatformMethodChannel _channel =
      const PlatformMethodChannel('firebase_analytics');

  /// Provides an instance of this class.
  factory FirebaseAnalytics() => const FirebaseAnalytics._();

  /// We don't want people to extend this class, but implementing its interface,
  /// e.g. in tests, is OK.
  const FirebaseAnalytics._();

  /// Logs an anlytics event with the given [name] and event [parameters].
  Future<Null> logEvent(String name, [Map<String, String> parameters]) async {
    Map<String, dynamic> data = <String, dynamic>{
      'name': name,
    };

    if (parameters != null)
      data['parameters'] = parameters;

    await _channel.invokeMethod('logEvent', data);
  }
}
