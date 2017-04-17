// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.firebase_analytics;

import java.util.Map;

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
  private final FirebaseAnalytics firebaseAnalytics;

  public static FirebaseAnalyticsPlugin register(FlutterActivity activity) {
    return new FirebaseAnalyticsPlugin(activity);
  }

  private FirebaseAnalyticsPlugin(FlutterActivity activity) {
    this.firebaseAnalytics = FirebaseAnalytics.getInstance(activity);
    new FlutterMethodChannel(activity.getFlutterView(), "firebase_analytics").setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Response response) {
    if (call.method.equals("logEvent")) {
      @SuppressWarnings("unchecked")
      Map<String, Object> arguments = (Map<String, Object>) call.arguments;
      final String eventName = (String) arguments.get("name");

      @SuppressWarnings("unchecked")
      final Bundle parameterBundle = createBundleFromMap((Map<String, Object>) arguments.get("parameters"));
      firebaseAnalytics.logEvent(eventName, parameterBundle);
      response.success(null);
    } else {
      response.notImplemented();
    }
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
