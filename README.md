# iNavi Navigation SDK for iOS

iNavi Navigation SDK iOS 샘플 프로젝트입니다. CocoaPods로 `inavi-navigation-sdk`를 연동하고, `naviSDKSample` 앱에서 지도 표시, 검색, 경로 탐색, 주행 관련 SDK 사용 예시를 확인할 수 있습니다.

## 개발 가이드

배포 문서: https://inavi-systems.github.io/inavi-navigation-demo-ios/ios-developer-guide/

실행 전 `naviSDKSample/Info.plist`의 `INaviAppKey` 값을 발급받은 AppKey로 설정해야 합니다.

## 주요 파일

- `Podfile`: `inavi-navigation-sdk` CocoaPods 의존성 설정
- `naviSDKSample/ViewController.swift`: SDK 초기화 및 샘플 UI 진입점
- `naviSDKSample/Info.plist`: AppKey, 위치 권한, ATS, Background Mode 설정
- `docs/index.md`: iOS SDK 개발 가이드 본문

## License
Copyright © 2019 iNavi Systems

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

