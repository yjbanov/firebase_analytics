// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
  Future<Null> logEvent({@required String name, Map<String, dynamic> parameters}) async {
    if (_reservedEventNames.contains(name)) {
      throw new ArgumentError.value(name, 'name',
          'Event name is reserved and cannot be used');
    }

    const String kReservedPrefix = 'firebase_';

    if (name.startsWith(kReservedPrefix)) {
      throw new ArgumentError.value(name, 'name',
          'Prefix "$kReservedPrefix" is reserved and cannot be used.');
    }

    await _channel.invokeMethod('logEvent', <String, dynamic>{
      'name': name,
      'parameters': parameters,
    });
  }

  /// Logs the standard `add_payment_info` event.
  ///
  /// This event signifies that a user has submitted their payment information
  /// to your app.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#ADD_PAYMENT_INFO
  Future<Null> logAddPaymentInfo() {
    return logEvent(name: 'add_payment_info');
  }

  /// Logs the standard `add_to_cart` event.
  ///
  /// This event signifies that an item was added to a cart for purchase. Add
  /// this event to a funnel with [logEcommercePurchase] to gauge the
  /// effectiveness of your checkout process. Note: If you supply the
  /// [value] parameter, you must also supply the [currency] parameter so that
  /// revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#ADD_TO_CART
  Future<Null> logAddToCart({
    @required String itemId,
    @required String itemName,
    @required String itemCategory,
    @required int quantity,
    double price,
    double value,
    String currency,
    String origin,
    String itemLocationId,
    String destination,
    String startDate,
    String endDate,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'add_to_cart',
      parameters: _filterOutNulls(<String, dynamic>{
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

  /// Logs the standard `add_to_wishlist` event.
  ///
  /// This event signifies that an item was added to a wishlist. Use this event
  /// to identify popular gift items in your app. Note: If you supply the
  /// [value] parameter, you must also supply the [currency] parameter so that
  /// revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#ADD_TO_WISHLIST
  Future<Null> logAddToWishlist({
    @required String itemId,
    @required String itemName,
    @required String itemCategory,
    @required int quantity,
    double price,
    double value,
    String currency,
    String itemLocationId,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'add_to_wishlist',
      parameters: _filterOutNulls(<String, dynamic>{
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

  /// Logs the standard `app_open` event.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#APP_OPEN
  Future<Null> logAppOpen() {
    return logEvent(name: 'app_open');
  }

  /// Logs the standard `begin_checkout` event.
  ///
  /// This event signifies that a user has begun the process of checking out.
  /// Add this event to a funnel with your [logEcommercePurchase] event to
  /// gauge the effectiveness of your checkout process. Note: If you supply the
  /// [value] parameter, you must also supply the [currency] parameter so that
  /// revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#BEGIN_CHECKOUT
  Future<Null> logBeginCheckout({
    double value,
    String currency,
    String transactionId,
    int numberOfNights,
    int numberOfRooms,
    int numberOfPassengers,
    String origin,
    String destination,
    String startDate,
    String endDate,
    String travelClass,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'begin_checkout',
      parameters: _filterOutNulls(<String, dynamic>{
        VALUE: value,
        CURRENCY: currency,
        TRANSACTION_ID: transactionId,
        NUMBER_OF_NIGHTS: numberOfNights,
        NUMBER_OF_ROOMS: numberOfRooms,
        NUMBER_OF_PASSENGERS: numberOfPassengers,
        ORIGIN: origin,
        DESTINATION: destination,
        START_DATE: startDate,
        END_DATE: endDate,
        TRAVEL_CLASS: travelClass,
      }),
    );
  }

  /// Logs the standard `campaign_details` event.
  ///
  /// Log this event to supply the referral details of a re-engagement campaign.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#CAMPAIGN_DETAILS
  Future<Null> logCampaignDetails({
    @required String source,
    @required String medium,
    @required String campaign,
    String term,
    String content,
    String aclid,
    String cp1,
  }) {
    return logEvent(
      name: 'campaign_details',
      parameters: _filterOutNulls(<String, String>{
        SOURCE: source,
        MEDIUM: medium,
        CAMPAIGN: campaign,
        TERM: term,
        CONTENT: content,
        ACLID: aclid,
        CP1: cp1,
      }),
    );
  }

  /// Logs the standard `earn_virtual_currency` event.
  ///
  /// This event tracks the awarding of virtual currency in your app. Log this
  /// along with [logSpendVirtualCurrency] to better understand your virtual
  /// economy.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#EARN_VIRTUAL_CURRENCY
  Future<Null> logEarnVirtualCurrency({
    @required String virtualCurrencyName,
    @required num value,
  }) {
    return logEvent(
      name: 'earn_virtual_currency',
      parameters: _filterOutNulls(<String, dynamic>{
        VIRTUAL_CURRENCY_NAME: virtualCurrencyName,
        VALUE: value,
      }),
    );
  }

  /// Logs the standard `ecommerce_purchase` event.
  ///
  /// This event signifies that an item was purchased by a user. Note: This is
  /// different from the in-app purchase event, which is reported automatically
  /// for Google Play-based apps. Note: If you supply the [value] parameter,
  /// you must also supply the [currency] parameter so that revenue metrics can
  /// be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#ECOMMERCE_PURCHASE
  Future<Null> logEcommercePurchase({
    String currency,
    double value,
    String transactionId,
    double tax,
    double shipping,
    String coupon,
    String location,
    int numberOfNights,
    int numberOfRooms,
    int numberOfPassengers,
    String origin,
    String destination,
    String startDate,
    String endDate,
    String travelClass,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'ecommerce_purchase',
      parameters: _filterOutNulls(<String, dynamic>{
        CURRENCY: currency,
        VALUE: value,
        TRANSACTION_ID: transactionId,
        TAX: tax,
        SHIPPING: shipping,
        COUPON: coupon,
        LOCATION: location,
        NUMBER_OF_NIGHTS: numberOfNights,
        NUMBER_OF_ROOMS: numberOfRooms,
        NUMBER_OF_PASSENGERS: numberOfPassengers,
        ORIGIN: origin,
        DESTINATION: destination,
        START_DATE: startDate,
        END_DATE: endDate,
        TRAVEL_CLASS: travelClass,
      }),
    );
  }

  /// Logs the standard `generate_lead` event.
  ///
  /// Log this event when a lead has been generated in the app to understand
  /// the efficacy of your install and re-engagement campaigns. Note: If you
  /// supply the [value] parameter, you must also supply the [currency]
  /// parameter so that revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#GENERATE_LEAD
  Future<Null> logGenerateLead({
    String currency,
    double value,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'generate_lead',
      parameters: _filterOutNulls(<String, dynamic>{
        CURRENCY: currency,
        VALUE: value,
      }),
    );
  }

  /// Logs the standard `join_group` event.
  ///
  /// Log this event when a user joins a group such as a guild, team or family.
  /// Use this event to analyze how popular certain groups or social features
  /// are in your app.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#JOIN_GROUP
  Future<Null> logJoinGroup({
    @required String groupId,
  }) {
    return logEvent(
      name: 'join_group',
      parameters: _filterOutNulls(<String, dynamic>{
        GROUP_ID: groupId,
      }),
    );
  }

  /// Logs the standard `level_up` event.
  ///
  /// This event signifies that a player has leveled up in your gaming app. It
  /// can help you gauge the level distribution of your userbase and help you
  /// identify certain levels that are difficult to pass.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#LEVEL_UP
  Future<Null> logLevelUp({
    @required int level,
    String character,
  }) {
    return logEvent(
      name: 'level_up',
      parameters: _filterOutNulls(<String, dynamic>{
        LEVEL: level,
        CHARACTER: character,
      }),
    );
  }

  /// Logs the standard `login` event.
  ///
  /// Apps with a login feature can report this event to signify that a user
  /// has logged in.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#LOGIN
  Future<Null> logLogin() {
    return logEvent(name: 'login');
  }

  /// Logs the standard `post_score` event.
  ///
  /// Log this event when the user posts a score in your gaming app. This event
  /// can help you understand how users are actually performing in your game
  /// and it can help you correlate high scores with certain audiences or
  /// behaviors.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#POST_SCORE
  Future<Null> logPostScore({
    @required int score,
    int level,
    String character,
  }) {
    return logEvent(
      name: 'post_score',
      parameters: _filterOutNulls(<String, dynamic>{
        SCORE: score,
        LEVEL: level,
        CHARACTER: character,
      }),
    );
  }

  /// Logs the standard `present_offer` event.
  ///
  /// This event signifies that the app has presented a purchase offer to a
  /// user. Add this event to a funnel with the [logAddToCart] and
  /// [logEcommercePurchase] to gauge your conversion process. Note: If you
  /// supply the [value] parameter, you must also supply the [currency]
  /// parameter so that revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#PRESENT_OFFER
  Future<Null> logPresentOffer({
    @required String itemId,
    @required String itemName,
    @required String itemCategory,
    @required int quantity,
    double price,
    double value,
    String currency,
    String itemLocationId,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'present_offer',
      parameters: _filterOutNulls(<String, dynamic>{
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

  /// Logs the standard `purchase_refund` event.
  ///
  /// This event signifies that an item purchase was refunded. Note: If you
  /// supply the [value] parameter, you must also supply the [currency]
  /// parameter so that revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#PURCHASE_REFUND
  Future<Null> logPurchaseRefund({
    String currency,
    double value,
    String transactionId,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'purchase_refund',
      parameters: _filterOutNulls(<String, dynamic>{
        CURRENCY: currency,
        VALUE: value,
        TRANSACTION_ID: transactionId,
      }),
    );
  }

  /// Logs the standard `search` event.
  ///
  /// Apps that support search features can use this event to contextualize
  /// search operations by supplying the appropriate, corresponding parameters.
  /// This event can help you identify the most popular content in your app.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#SEARCH
  Future<Null> logSearch({
    @required String searchTerm,
    int numberOfNights,
    int numberOfRooms,
    int numberOfPassengers,
    String origin,
    String destination,
    String startDate,
    String endDate,
    String travelClass,
  }) {
    return logEvent(
      name: 'search',
      parameters: _filterOutNulls(<String, dynamic>{
        SEARCH_TERM: searchTerm,
        NUMBER_OF_NIGHTS: numberOfNights,
        NUMBER_OF_ROOMS: numberOfRooms,
        NUMBER_OF_PASSENGERS: numberOfPassengers,
        ORIGIN: origin,
        DESTINATION: destination,
        START_DATE: startDate,
        END_DATE: endDate,
        TRAVEL_CLASS: travelClass,
      }),
    );
  }

  /// Logs the standard `select_content` event.
  ///
  /// This general purpose event signifies that a user has selected some
  /// content of a certain type in an app. The content can be any object in
  /// your app. This event can help you identify popular content and categories
  /// of content in your app.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#SELECT_CONTENT
  Future<Null> logSelectContent({
    @required String contentType,
    @required String itemId,
  }) {
    return logEvent(
      name: 'select_content',
      parameters: _filterOutNulls(<String, dynamic>{
        CONTENT_TYPE: contentType,
        ITEM_ID: itemId,
      }),
    );
  }

  /// Logs the standard `share` event.
  ///
  /// Apps with social features can log the Share event to identify the most
  /// viral content.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#SHARE
  Future<Null> logShare({
    @required String contentType,
    @required String itemId,
  }) {
    return logEvent(
      name: 'share',
      parameters: _filterOutNulls(<String, dynamic>{
        CONTENT_TYPE: contentType,
        ITEM_ID: itemId,
      }),
    );
  }

  /// Logs the standard `sign_up` event.
  ///
  /// This event indicates that a user has signed up for an account in your
  /// app. The parameter signifies the method by which the user signed up. Use
  /// this event to understand the different behaviors between logged in and
  /// logged out users.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#SIGN_UP
  Future<Null> logSignUp({
    @required String signUpMethod,
  }) {
    return logEvent(
      name: 'sign_up',
      parameters: _filterOutNulls(<String, dynamic>{
        SIGN_UP_METHOD: signUpMethod,
      }),
    );
  }

  /// Logs the standard `spend_virtual_currency` event.
  ///
  /// This event tracks the sale of virtual goods in your app and can help you
  /// identify which virtual goods are the most popular objects of purchase.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#SPEND_VIRTUAL_CURRENCY
  Future<Null> logSpendVirtualCurrency({
    @required String itemName,
    @required String virtualCurrencyName,
    @required num value,
  }) {
    return logEvent(
      name: 'spend_virtual_currency',
      parameters: _filterOutNulls(<String, dynamic>{
        ITEM_NAME: itemName,
        VIRTUAL_CURRENCY_NAME: virtualCurrencyName,
        VALUE: value,
      }),
    );
  }

  /// Logs the standard `tutorial_begin` event.
  ///
  /// This event signifies the start of the on-boarding process in your app.
  /// Use this in a funnel with [logTutorialComplete] to understand how many
  /// users complete this process and move on to the full app experience.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#TUTORIAL_BEGIN
  Future<Null> logTutorialBegin() {
    return logEvent(name: 'tutorial_begin');
  }

  /// Logs the standard `tutorial_complete` event.
  ///
  /// Use this event to signify the user's completion of your app's on-boarding
  /// process. Add this to a funnel with [logTutorialBegin] to gauge the
  /// completion rate of your on-boarding process.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#TUTORIAL_COMPLETE
  Future<Null> logTutorialComplete() {
    return logEvent(name: 'tutorial_complete');
  }

  /// Logs the standard `unlock_achievement` event with a given achievement
  /// [id].
  ///
  /// Log this event when the user has unlocked an achievement in your game.
  /// Since achievements generally represent the breadth of a gaming
  /// experience, this event can help you understand how many users are
  /// experiencing all that your game has to offer.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#UNLOCK_ACHIEVEMENT
  Future<Null> logUnlockAchievement({
    @required String id,
  }) {
    return logEvent(
      name: 'unlock_achievement',
      parameters: _filterOutNulls(<String, dynamic>{
        ACHIEVEMENT_ID: id,
      }),
    );
  }

  /// Logs the standard `view_item` event.
  ///
  /// This event signifies that some content was shown to the user. This
  /// content may be a product, a webpage or just a simple image or text. Use
  /// the appropriate parameters to contextualize the event. Use this event to
  /// discover the most popular items viewed in your app. Note: If you supply
  /// the [value] parameter, you must also supply the [currency] parameter so
  /// that revenue metrics can be computed accurately.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#VIEW_ITEM
  Future<Null> logViewItem({
    @required String itemId,
    @required String itemName,
    @required String itemCategory,
    String itemLocationId,
    double price,
    int quantity,
    String currency,
    double value,
    String flightNumber,
    int numberOfPassengers,
    int numberOfNights,
    int numberOfRooms,
    String origin,
    String destination,
    String startDate,
    String endDate,
    String searchTerm,
    String travelClass,
  }) {
    _requireValueAndCurrencyTogether(value, currency);

    return logEvent(
      name: 'view_item',
      parameters: _filterOutNulls(<String, dynamic>{
        ITEM_ID: itemId,
        ITEM_NAME: itemName,
        ITEM_CATEGORY: itemCategory,
        ITEM_LOCATION_ID: itemLocationId,
        PRICE: price,
        QUANTITY: quantity,
        CURRENCY: currency,
        VALUE: value,
        FLIGHT_NUMBER: flightNumber,
        NUMBER_OF_PASSENGERS: numberOfPassengers,
        NUMBER_OF_NIGHTS: numberOfNights,
        NUMBER_OF_ROOMS: numberOfRooms,
        ORIGIN: origin,
        DESTINATION: destination,
        START_DATE: startDate,
        END_DATE: endDate,
        SEARCH_TERM: searchTerm,
        TRAVEL_CLASS: travelClass,
      }),
    );
  }

  /// Logs the standard `view_item_list` event.
  ///
  /// Log this event when the user has been presented with a list of items of a
  /// certain category.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#VIEW_ITEM_LIST
  Future<Null> logViewItemList({
    @required String itemCategory,
  }) {
    return logEvent(
      name: 'view_item_list',
      parameters: _filterOutNulls(<String, dynamic>{
        ITEM_CATEGORY: itemCategory,
      }),
    );
  }

  /// Logs the standard `view_search_results` event.
  ///
  /// Log this event when the user has been presented with the results of a
  /// search.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#VIEW_SEARCH_RESULTS
  Future<Null> logViewSearchResults({
    @required String searchTerm,
  }) {
    return logEvent(
      name: 'view_search_results',
      parameters: _filterOutNulls(<String, dynamic>{
        SEARCH_TERM: searchTerm,
      }),
    );
  }
}

/// Creates a new map containing all of the key/value pairs from [parameters]
/// except those whose value is `null`.
Map<String, dynamic> _filterOutNulls(Map<String, dynamic> parameters) {
  final Map<String, dynamic> filtered = <String, dynamic>{};
  filtered.forEach((String key, dynamic value) {
    if (value != null)
      filtered[key] = value;
  });
  return filtered;
}

void _requireValueAndCurrencyTogether(double value, String currency) {
  if (value != null && currency == null) {
    throw new ArgumentError(
      'If you supply the "value" parameter, you must also supply the '
      '"currency" parameter.'
    );
  }
}

/// Reserved event names that cannot be used.
///
/// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html
const List<String> _reservedEventNames = const <String>[
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
