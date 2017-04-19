// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.firebase_analytics;

import java.util.Map;

import com.google.firebase.FirebaseApp;
import com.google.firebase.analytics.FirebaseAnalytics;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.FlutterMethodChannel;
import io.flutter.plugin.common.FlutterMethodChannel.MethodCallHandler;
import io.flutter.plugin.common.FlutterMethodChannel.Response;
import io.flutter.plugin.common.MethodCall;

/**
 * Flutter plugin for Firebase Analytics.
 */
public class FirebaseAnalyticsPlugin implements MethodCallHandler {
  private final FlutterActivity activity;
  private final FirebaseAnalytics firebaseAnalytics;

  public static FirebaseAnalyticsPlugin register(FlutterActivity activity) {
    return new FirebaseAnalyticsPlugin(activity);
  }

  private FirebaseAnalyticsPlugin(FlutterActivity activity) {
    this.activity = activity;
    FirebaseApp.initializeApp(activity);
    this.firebaseAnalytics = FirebaseAnalytics.getInstance(activity);
    new FlutterMethodChannel(activity.getFlutterView(), "firebase_analytics").setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Response response) {
    switch (call.method) {
      case "logEvent":
        handleLogEvent(call, response);
        break;
      case "setUserId":
        handleSetUserId(call, response);
        break;
      case "setCurrentScreen":
        handleSetCurrentScreen(call, response);
        break;
      case "setAnalyticsCollectionEnabled":
        handleSetAnalyticsCollectionEnabled(call, response);
        break;
      case "setMinimumSessionDuration":
        handleSetMinimumSessionDuration(call, response);
        break;
      case "setSessionTimeoutDuration":
        handleSetSessionTimeoutDuration(call, response);
        break;
      case "setUserProperty":
        handleSetUserProperty(call, response);
        break;
      default:
        response.notImplemented();
        break;
    }
  }

  private void handleLogEvent(MethodCall call, Response response) {
    @SuppressWarnings("unchecked")
    Map<String, Object> arguments = (Map<String, Object>) call.arguments;
    final String eventName = (String) arguments.get("name");

    @SuppressWarnings("unchecked")
    final Bundle parameterBundle = createBundleFromMap((Map<String, Object>) arguments.get("parameters"));
    firebaseAnalytics.logEvent(eventName, parameterBundle);
    response.success(null);
  }

  private void handleSetUserId(MethodCall call, Response response) {
    final String id = (String) call.arguments;
    firebaseAnalytics.setUserId(id);
    response.success(null);
  }

  private void handleSetCurrentScreen(MethodCall call, Response response) {
    @SuppressWarnings("unchecked")
    Map<String, Object> arguments = (Map<String, Object>) call.arguments;
    final String screenName = (String) arguments.get("screenName");
    final String screenClassOverride = (String) arguments.get("screenClassOverride");

    firebaseAnalytics.setCurrentScreen(activity, screenName, screenClassOverride);
    response.success(null);
  }

  private void handleSetAnalyticsCollectionEnabled(MethodCall call, Response response) {
    final Boolean enabled = (Boolean) call.arguments;
    firebaseAnalytics.setAnalyticsCollectionEnabled(enabled);
    response.success(null);
  }

  private void handleSetMinimumSessionDuration(MethodCall call, Response response) {
    final Integer milliseconds = (Integer) call.arguments;
    firebaseAnalytics.setMinimumSessionDuration(milliseconds);
    response.success(null);
  }

  private void handleSetSessionTimeoutDuration(MethodCall call, Response response) {
    final Integer milliseconds = (Integer) call.arguments;
    firebaseAnalytics.setSessionTimeoutDuration(milliseconds);
    response.success(null);
  }

  private void handleSetUserProperty(MethodCall call, Response response) {
    @SuppressWarnings("unchecked")
    Map<String, Object> arguments = (Map<String, Object>) call.arguments;
    final String name = (String) arguments.get("name");
    final String value = (String) arguments.get("value");

    firebaseAnalytics.setUserProperty(name, value);
    response.success(null);
  }

  private static Bundle createBundleFromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    Bundle bundle = new Bundle();
    for (Map.Entry<String, Object> jsonParam : map.entrySet()) {
      final Object value = jsonParam.getValue();
      final String key = jsonParam.getKey();
      if (value instanceof String) {
        bundle.putString(key, (String) value);
      } else if (value instanceof Integer) {
        bundle.putInt(key, (Integer) value);
      } else if (value instanceof Double) {
        bundle.putDouble(key, (Double) value);
      } else if (value instanceof Boolean) {
        bundle.putBoolean(key, (Boolean) value);
      } else {
        throw new IllegalArgumentException("Unsupported value type: " + value.getClass().getCanonicalName());
      }
    }
    return bundle;
  }
}
