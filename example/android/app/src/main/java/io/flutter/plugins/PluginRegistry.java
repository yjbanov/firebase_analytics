package io.flutter.plugins;

import io.flutter.app.FlutterActivity;

import io.flutter.firebase_analytics.FirebaseAnalyticsPlugin;

/**
 * Generated file. Do not edit.
 */

public class PluginRegistry {
    public FirebaseAnalyticsPlugin firebase_analytics;

    public void registerAll(FlutterActivity activity) {
        firebase_analytics = FirebaseAnalyticsPlugin.register(activity);
    }
}
