import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:math_rush/core/utils/ad_helper.dart';
import 'package:math_rush/core/services/consent_service.dart';

class AdService extends GetxService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  DateTime? _lastInterstitialTime;
  final Duration interstitialCooldown = const Duration(minutes: 2);

  bool _hasRevived = false;
  bool get hasRevived => _hasRevived;

  void resetReviveStatus() {
    _hasRevived = false;
  }

  void markRevived() {
    _hasRevived = true;
  }

  Future<AdService> init() async {
    final consentService = Get.find<ConsentService>();

    if (await consentService.canRequestAds) {
      await MobileAds.instance.initialize();
      _loadInterstitialAd();
      _loadRewardedAd();
    } else {
      debugPrint('AdService: Consent not granted. Ads will not load.');
    }

    return this;
  }

  // INTERSTITIAL AD

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (err) {
          debugPrint('Interstitial failed to load: $err');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    final now = DateTime.now();

    if (_lastInterstitialTime != null &&
        now.difference(_lastInterstitialTime!) < interstitialCooldown) {
      debugPrint('AdService: Interstitial in cooldown. Skipping.');
      onAdClosed?.call();
      return;
    }

    if (_interstitialAd == null) {
      debugPrint('AdService: Ad not ready yet.');
      _loadInterstitialAd();
      onAdClosed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _lastInterstitialTime = DateTime.now();
        _loadInterstitialAd();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _loadInterstitialAd();
        onAdClosed?.call();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // REWARDED AD

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (err) {
          debugPrint('Rewarded failed to load: $err');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({
    required Function onUserEarnedReward,
    Function? onAdDismissed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('AdService: Rewarded ad not ready.');
      _loadRewardedAd();
      onAdDismissed?.call();
      return;
    }

    bool hasReward = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
        if (!hasReward) onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _loadRewardedAd();
        onAdDismissed?.call();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        hasReward = true;
        onUserEarnedReward();
      },
    );
    _rewardedAd = null;
  }

  // BANNER AD

  BannerAd createBannerAd({
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
