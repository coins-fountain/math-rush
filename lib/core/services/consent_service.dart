import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentService extends GetxService {
  final Completer<bool> _initializationCompleter = Completer<bool>();

  Future<bool> init() async {
    ConsentDebugSettings? debugSettings;

    //for debug simulation europe user
    if (kDebugMode) {
      debugSettings = ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: ['TEST-DEVICE-HASH-ID'],
      );
    }

    final params = ConsentRequestParameters(
      consentDebugSettings: debugSettings,
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadAndShowConsentForm();
        }
        _completeInitialization();
      },
      (FormError error) {
        debugPrint('Consent Error: ${error.message}');
        _completeInitialization();
      },
    );

    return _initializationCompleter.future;
  }

  Future<void> _loadAndShowConsentForm() async {
    final completer = Completer<void>();

    ConsentForm.loadAndShowConsentFormIfRequired((FormError? formError) {
      if (formError != null) {
        debugPrint('Form Error: ${formError.message}');
      }
      completer.complete();
    });

    return completer.future;
  }

  void _completeInitialization() {
    if (!_initializationCompleter.isCompleted) {
      _initializationCompleter.complete(true);
    }
  }

  Future<bool> get canRequestAds async {
    return await ConsentInformation.instance.canRequestAds();
  }
}
