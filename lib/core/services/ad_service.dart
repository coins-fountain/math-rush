import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class AdService extends GetxService {
  DateTime? _lastInterstitialTime;
  bool _hasRevived = false;
  final Duration adCooldown = const Duration(minutes: 1);

  bool get hasRevived => _hasRevived;

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    return this;
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
