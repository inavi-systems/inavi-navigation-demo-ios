# iNavi Navigation SDK for iOS

iNavi Navigation SDK iOS 샘플 프로젝트입니다. CocoaPods로 `inavi-navigation-sdk`를 연동하고, `naviSDKSample` 앱에서 지도 표시, 검색, 경로 탐색, 주행 관련 SDK 사용 예시를 확인할 수 있습니다.

## Developer Guide

- 배포 문서: https://inavi-systems.github.io/inavi-navigation-demo-ios/ios-developer-guide/
- 문서 원본: `docs/index.md`

실행 전 `naviSDKSample/Info.plist`의 `INaviAppKey` 값을 발급받은 AppKey로 설정해야 합니다.

## 주요 파일

- `Podfile`: `inavi-navigation-sdk` CocoaPods 의존성 설정
- `naviSDKSample/ViewController.swift`: SDK 초기화 및 샘플 UI 진입점
- `naviSDKSample/Info.plist`: AppKey, 위치 권한, ATS, Background Mode 설정
- `docs/index.md`: iOS SDK 개발 가이드 본문
