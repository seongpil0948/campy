flutter clean \
    && rm ios/Podfile.lock pubspec.lock \
    && rm -rf ios/Pods ios/Runner.xcworkspace \
    && flutter build ipa  