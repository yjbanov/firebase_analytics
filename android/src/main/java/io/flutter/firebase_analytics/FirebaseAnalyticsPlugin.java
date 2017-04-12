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
      final Map<String, String> jsonParams = (Map<String, String>) arguments.get("parameters");
      final Bundle eventParameters = new Bundle();

      if (jsonParams != null) {
        for (Map.Entry<String, String> jsonParam : jsonParams.entrySet()) {
          eventParameters.putString(jsonParam.getKey(), jsonParam.getValue());
        }
      }

      firebaseAnalytics.logEvent(eventName, eventParameters);
      response.success("OK");
    } else {
      response.notImplemented();
    }
  }
}
