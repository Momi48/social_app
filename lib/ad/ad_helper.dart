import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static BannerAd? _bannerAd;
  
  static void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid ? "ca-app-pub-3940256099942544/9214589741" : "ca-app-pub-3940256099942544/2435281174",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => debugPrint("Banner Ad Loaded"),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint("Banner Ad Failed: $error");
          ad.dispose();
        },
      ),
    )..load();
  }

  static Widget showBannerAd() {
    if (_bannerAd == null) {
      loadBannerAd();
      return const SizedBox(); 
    } 
    else {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
  }

  static void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }
}
