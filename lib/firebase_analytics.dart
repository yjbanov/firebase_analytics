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

  /// Logs a custom Flutter Analytics event with the given [name] and event [parameters].
  Future<Null> logEvent({@required String name, Map<String, String> parameters}) async {
    if (_reservedEventNames.contains(name)) {
      throw new ArgumentError.value(name, 'name',
          'Event name is reserved and cannot be used');
    }

    await _channel.invokeMethod('logEvent', <String, dynamic>{
      'name': name,
      'parameters': parameters,
    });
  }

  /// Logs the standard `add_payment_info` event.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#ADD_PAYMENT_INFO
  Future<Null> logAddPaymentInfo() {
    return logEvent(name: 'add_payment_info');
  }

  /// Logs the standard `add_to_cart` event.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#ADD_TO_CART
  Future<Null> logAddToCart({
    String itemId,
    String itemName,
    String itemCategory,
    String quantity,
    String price,
    String value,
    String currency,
    String origin,
    String itemLocationId,
    String destination,
    String startDate,
    String endDate,
  }) {
    return logEvent(
      name: 'add_to_cart',
      parameters: _filterOutNulls(<String, String>{
        ITEM_ID: itemId,
        ITEM_NAME: itemName,
        ITEM_CATEGORY: itemCategory,
        QUANTITY: quantity,
        PRICE: price,
        VALUE: value,
        CURRENCY: currency,
        ORIGIN: origin,
        ITEM_LOCATION_ID: itemLocationId,
        DESTINATION: destination,
        START_DATE: startDate,
        END_DATE: endDate,
      }),
    );
  }

  Future<Null> logAddToWishlist({
    String itemId,
    String itemName,
    String itemCategory,
    String quantity,
    String price,
    String value,
    String currency,
    String itemLocationId,
  }) {
    return logEvent(
      name: 'add_to_wishlist',
      parameters: _filterOutNulls(<String, String>{
        ITEM_ID: itemId,
        ITEM_NAME: itemName,
        ITEM_CATEGORY: itemCategory,
        QUANTITY: quantity,
        PRICE: price,
        VALUE: value,
        CURRENCY: currency,
        ITEM_LOCATION_ID: itemLocationId,
      }),
    );
  }
}

/// Mutates the [parameters] map, removing all parameters whose value is `null`.
Map<String, String> _filterOutNulls(Map<String, String> parameters) {
  // To prevent concurrent modification
  final List<String> copyOfKeys = parameters.keys.toList();
  for (String key in copyOfKeys) {
    if (parameters[key] == null)
      parameters.remove(key);
  }
}

/// Reserved event names that cannot be used.
///
/// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html
const List<String> _reservedEventNames = <String>[
  'app_clear_data',
  'app_uninstall',
  'app_update',
  'error',
  'first_open',
  'in_app_purchase',
  'notification_dismiss',
  'notification_foreground',
  'notification_open',
  'notification_receive',
  'os_update',
  'session_start',
  'user_engagement',
];

// The following constants are defined in:
//
// https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Param.html

/// Game achievement ID.
const String ACHIEVEMENT_ID = 'achievement_id';

/// `CAMPAIGN_DETAILS` click ID.
const String ACLID = 'aclid';

/// `CAMPAIGN_DETAILS` name; used for keyword analysis to identify a specific
/// product promotion or strategic campaign.
const String CAMPAIGN = 'campaign';

/// Character used in game.
const String CHARACTER = 'character';

/// `CAMPAIGN_DETAILS` content; used for A/B testing and content-targeted ads to
/// differentiate ads or links that point to the same URL.
const String CONTENT = 'content';

/// Type of content selected.
const String CONTENT_TYPE = 'content_type';

/// Coupon code for a purchasable item.
const String COUPON = 'coupon';

/// `CAMPAIGN_DETAILS` custom parameter.
const String CP1 = 'cp1';

/// Purchase currency in 3 letter ISO_4217 format.
const String CURRENCY = 'currency';

/// Flight or Travel destination.
const String DESTINATION = 'destination';

/// The arrival date, check-out date, or rental end date for the item.
const String END_DATE = 'end_date';

/// Flight number for travel events.
const String FLIGHT_NUMBER = 'flight_number';

/// Group/clan/guild id.
const String GROUP_ID = 'group_id';

/// Item category.
const String ITEM_CATEGORY = 'item_category';

/// Item ID.
const String ITEM_ID = 'item_id';

/// The Google Place ID that corresponds to the associated item.
const String ITEM_LOCATION_ID = 'item_location_id';

/// Item name.
const String ITEM_NAME = 'item_name';

/// Level in game (long).
const String LEVEL = 'level';

/// Location.
const String LOCATION = 'location';

/// `CAMPAIGN_DETAILS` medium; used to identify a medium such as email or
/// cost-per-click (cpc).
const String MEDIUM = 'medium';

/// Number of nights staying at hotel (long).
const String NUMBER_OF_NIGHTS = 'number_of_nights';

/// Number of passengers traveling (long).
const String NUMBER_OF_PASSENGERS = 'number_of_passengers';

/// Number of rooms for travel events (long).
const String NUMBER_OF_ROOMS = 'number_of_rooms';

/// Flight or Travel origin.
const String ORIGIN = 'origin';

/// Purchase price (double).
const String PRICE = 'price';

/// Purchase quantity (long).
const String QUANTITY = 'quantity';

/// Score in game (long).
const String SCORE = 'score';

/// The search string/keywords used.
const String SEARCH_TERM = 'search_term';

/// Shipping cost (double).
const String SHIPPING = 'shipping';

/// Signup method.
const String SIGN_UP_METHOD = 'sign_up_method';

/// `CAMPAIGN_DETAILS` source; used to identify a search engine, newsletter, or
/// other source.
const String SOURCE = 'source';

/// The departure date, check-in date, or rental start date for the item.
const String START_DATE = 'start_date';

/// Tax amount (double).
const String TAX = 'tax';

/// `CAMPAIGN_DETAILS` term; used with paid search to supply the keywords for
/// ads.
const String TERM = 'term';

/// A single ID for a ecommerce group transaction.
const String TRANSACTION_ID = 'transaction_id';

/// Travel class.
const String TRAVEL_CLASS = 'travel_class';

/// A context-specific numeric value which is accumulated automatically for
/// each event type.
const String VALUE = 'value';

/// Name of virtual currency type.
const String VIRTUAL_CURRENCY_NAME = 'virtual_currency_name';
