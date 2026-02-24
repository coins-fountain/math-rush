import 'dart:async';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class AdService extends GetxService {
  DateTime? _lastInterstitialTime;
  bool _hasRevived = false;
  final Duration adCooldown = const Duration(minutes: 1);

  bool get hasRevived => _hasRevived;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<AdService> init() async {
    final completer = Completer<AdService>();
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadAndShowConsentFormIfRequired();
          _isInitialized = true;
          completer.complete(this);
        } else {
          await MobileAds.instance.initialize();
          _isInitialized = true;
          completer.complete(this);
        }
      },
      (FormError error) async {
        await MobileAds.instance.initialize();
        _isInitialized = true;
        completer.complete(this);
      },
    );

    return completer.future;
  }

  Future<void> _loadAndShowConsentFormIfRequired() async {
    final completer = Completer<void>();
    await ConsentForm.loadAndShowConsentFormIfRequired((
      FormError? formError,
    ) async {
      await MobileAds.instance.initialize();
      completer.complete();
    });
    return completer.future;
  }

  void resetReviveStatus() {
    _hasRevived = false;
  }

  void markRevived() {
    _hasRevived = true;
  }

  void showReviveAd({required Function(bool rewardGranted) onClosed}) {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          bool rewardEarned = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onClosed(rewardEarned);
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              onClosed(false);
            },
          );

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              rewardEarned = true;
            },
          );
        },
        onAdFailedToLoad: (err) {
          onClosed(false);
        },
      ),
    );
  }

  void showGameOverAd({required Function onAdClosed}) {
    final now = DateTime.now();

    if (_lastInterstitialTime != null &&
        now.difference(_lastInterstitialTime!) < adCooldown) {
      onAdClosed();
      return;
    }

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onAdClosed();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              onAdClosed();
            },
          );
          ad.show();
          _lastInterstitialTime = DateTime.now();
        },
        onAdFailedToLoad: (err) {
          onAdClosed();
        },
      ),
    );
  }

  BannerAd? createBannerAd({
    required Function() onAdLoaded,
    required Function() onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad();
        },
      ),
    );
  }
}
