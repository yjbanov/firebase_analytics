import 'dart:async';

import 'package:meta/meta.dart';

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
  Future<Null> logEvent({@required String name, Map<String, String> parameters}) async {
    await _channel.invokeMethod('logEvent', <String, dynamic>{
      'name': name,
      'parameters': parameters,
    });
  }
}
