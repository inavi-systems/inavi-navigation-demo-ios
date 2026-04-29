# iOS 샘플 프로젝트 VitePress 및 GitHub Pages 적용 계획

## 목적

Android 샘플 프로젝트에 적용된 VitePress 기반 개발 가이드 문서와 GitHub Pages 자동 배포 구성을 iOS 샘플 프로젝트에도 동일한 방식으로 적용한다.

이 계획은 현재 Android 저장소의 Git 이력과 실제 최종 파일 상태를 기준으로 작성한다. iOS 저장소에는 문서 인프라를 새로 추가하되, iOS 샘플 앱 구현 파일은 변경하지 않는다.

## Android 프로젝트에서 확인한 이력

대상 저장소:

- 경로: `/Users/seungjunlee/Workspace/Projects/inavi-navigation-demo-android`
- 원격: `git@github.com:inavi-systems/inavi-navigation-demo-android.git`
- 현재 브랜치: `master`

문서화 관련 주요 커밋:

- `e30484f` `gh-workflow 및 vitepress 설정 추가`
  - `.github/workflows/deploy-docs.yml`
  - `docs/.vitepress/config.mts`
  - `docs/index.md`
  - `package.json`
  - `package-lock.json`
  - `.gitignore`
  - `README.md`
- `f56f8f6` `불필요 문서 제거`
  - 문서 계획/참고 파일 정리
- `9fb19c2` `개발자가이드 문서 업데이트`
  - `docs/index.md` 본문 확장
  - VitePress 설정 조정
- `5976739` `개발자가이드 문서 이미지 추가 및 내용 수정`
  - `docs/public/images/*` 추가
  - README 배포 문서 링크 추가
- `c3db63c` `base url 변경`
  - VitePress `base`
  - package name
  - lockfile 갱신

## Android 프로젝트의 최종 구성

현재 Android 프로젝트에서 최종적으로 남아 있는 문서 관련 파일은 다음과 같다.

```text
package.json
package-lock.json
.github/
  workflows/
    deploy-docs.yml
docs/
  index.md
  .vitepress/
    config.mts
  public/
    images/
      bg_tbt.png
      extendview_horizontal.png
      extendview_vertical.png
README.md
.gitignore
```

`package.json` 구성:

```json
{
  "name": "inavi-navigation-android-developer-guide",
  "private": true,
  "scripts": {
    "docs:dev": "vitepress dev docs",
    "docs:build": "vitepress build docs",
    "docs:preview": "vitepress preview docs"
  },
  "devDependencies": {
    "vitepress": "^1.6.4"
  }
}
```

`docs/.vitepress/config.mts`의 핵심 설정:

- `title`: `iNavi Navigation SDK for Android`
- `description`: `iNavi Android Navigation SDK Developer Guide`
- `base`: `/inavi-navigation-android-developer-guide/`
- `srcExclude`: `plans/**`
- GitHub 링크: `https://github.com/inavi-systems/inavi-navigation-demo-android`

GitHub Actions 구성:

- 파일: `.github/workflows/deploy-docs.yml`
- 트리거: `master` 브랜치 push, `workflow_dispatch`
- Node.js: 20
- 설치: `npm ci`
- 빌드: `npm run docs:build`
- Pages artifact: `docs/.vitepress/dist`
- 배포: `actions/deploy-pages@v4`

`.gitignore`에 추가된 문서 관련 항목:

```gitignore
node_modules
docs/plans
docs/.vitepress/cache
docs/.vitepress/dist
```

## iOS 프로젝트 현재 상태

대상 저장소:

- 경로: `/Users/seungjunlee/Workspace/Projects/inavi-navigation-demo-ios`
- 원격: `git@github.com:inavi-systems/inavi-navigation-demo-ios.git`
- 현재 브랜치: `master`
- 현재 작업 트리: clean

확인한 현재 파일:

```text
.gitignore
Podfile
Podfile.lock
naviSDKSample.xcodeproj/
naviSDKSample.xcworkspace/
naviSDKSample/
```

현재 없는 파일/구성:

- 루트 `README.md`
- 루트 `package.json`
- 루트 `package-lock.json`
- `docs/`
- `.github/workflows/deploy-docs.yml`

iOS 샘플의 SDK 연동 단서:

- `Podfile`
  - target: `naviSDKSample`
  - pod: `inavi-navigation-sdk`
- `naviSDKSample/Info.plist`
  - `INaviAppKey`
  - 위치 권한 문구
  - `NSAppTransportSecurity`의 `NSAllowsArbitraryLoads`
  - `UIBackgroundModes`: `audio`, `location`

## 적용 방향

### 1. 문서 사이트는 iOS 저장소 내부에 구성

Android와 동일하게 샘플 프로젝트 루트에 Node/VitePress 설정을 둔다.

권장 구조:

```text
README.md
package.json
package-lock.json
.github/
  workflows/
    deploy-docs.yml
docs/
  index.md
  .vitepress/
    config.mts
  public/
    images/
```

### 2. README와 VitePress 본문 역할 분리

Android 최종 상태는 `docs/index.md`가 독립적인 개발 가이드 본문을 갖고, `README.md`는 저장소 첫 화면용 요약과 배포 문서 링크를 제공한다.

iOS도 같은 방식으로 구성한다.

- `README.md`
  - 저장소 개요
  - 배포 문서 링크
  - 최소 실행 방법
  - 주요 샘플 코드 위치
  - License
- `docs/index.md`
  - iOS SDK 개발 가이드 본문
  - AppKey 발급
  - 개발 환경
  - CocoaPods 설정
  - `Info.plist` 설정
  - SDK 초기화/지도 표시/검색/경로/주행 관련 예시
  - API reference 또는 현재 제공 가능한 범위의 인터페이스 설명

초기 적용 시 iOS SDK 전체 API 문서가 준비되지 않았다면, `docs/index.md`는 샘플 프로젝트 기준의 설치/실행/초기화 가이드부터 작성하고 이후 API reference를 확장한다.

### 3. VitePress 설정

`docs/.vitepress/config.mts`를 추가한다.

예상 설정:

```ts
import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'iNavi Navigation SDK for iOS',
  description: 'iNavi iOS Navigation SDK Developer Guide',
  base: '/inavi-navigation-demo-ios/',
  srcExclude: [
    'plans/**'
  ],
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' }
    ],
    outline: {
      level: 2
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/inavi-systems/inavi-navigation-demo-ios' }
    ]
  }
})
```

`base`는 GitHub Pages 기본 URL이 `https://inavi-systems.github.io/inavi-navigation-demo-ios/`일 때 필요한 값이다.

주의:

- Android 최종 설정의 `base`는 `/inavi-navigation-android-developer-guide/`로 변경되어 있다.
- iOS 저장소가 별도 Pages repository나 커스텀 도메인을 쓰지 않는다면 iOS는 `/inavi-navigation-demo-ios/`가 자연스럽다.
- 만약 iOS도 별도 문서용 repository name으로 배포할 계획이면 해당 repository name으로 `base`를 바꿔야 한다.

### 4. Node 패키지 설정

루트 `package.json`을 추가한다.

예상 구성:

```json
{
  "name": "inavi-navigation-ios-developer-guide",
  "private": true,
  "scripts": {
    "docs:dev": "vitepress dev docs",
    "docs:build": "vitepress build docs",
    "docs:preview": "vitepress preview docs"
  },
  "devDependencies": {
    "vitepress": "^1.6.4"
  }
}
```

`npm install`로 `package-lock.json`을 생성하고 함께 커밋한다.

### 5. GitHub Actions 배포 설정

`.github/workflows/deploy-docs.yml`을 추가한다.

Android와 동일한 워크플로를 사용한다.

```yaml
name: Deploy VitePress site to Pages

on:
  push:
    branches: [master]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Build with VitePress
        run: npm run docs:build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: docs/.vitepress/dist

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 6. `.gitignore` 갱신

iOS 저장소의 기존 `.gitignore`에 문서 빌드 산출물을 추가한다.

```gitignore
node_modules
docs/plans
docs/.vitepress/cache
docs/.vitepress/dist
```

`docs/plans`는 작업 계획/내부 메모용으로 유지하고 Pages 빌드에서는 `srcExclude: ['plans/**']`로 제외한다.

### 7. 이미지 자산 정책

Android에서는 VitePress 정적 이미지 자산을 `docs/public/images` 아래에 둔다.

iOS도 같은 정책을 사용한다.

```text
docs/public/images/
```

Markdown에서는 다음처럼 참조한다.

```md
![이미지 설명](/images/example.png)
```

VitePress `base`가 설정되어 있어도 `docs/public`의 정적 파일은 이 방식으로 처리된다.

## iOS 개발 가이드 초안 구성

`docs/index.md`의 첫 적용 범위는 다음 정도가 적절하다.

```md
---
title: iNavi Navigation SDK for iOS
---

# iNavi SDK iOS 개발 가이드

## 개요
## AppKey 발급
## 개발 환경
## SDK 세팅 방법
### 1. CocoaPods 설정
### 2. SDK 의존성 설치
### 3. Info.plist 설정
### 4. Background Modes 설정
## 샘플 앱 실행
## 주요 샘플 코드
## SDK 초기화
## 지도 표시
## 검색
## 경로 탐색
## 주행 안내
## 코드 표
```

현재 iOS 샘플에서 바로 근거를 뽑을 수 있는 항목:

- `Podfile`의 `pod 'inavi-navigation-sdk'`
- `naviSDKSample/Info.plist`의 `INaviAppKey`
- 위치 권한 문구
- ATS 허용 설정
- `UIBackgroundModes`의 `audio`, `location`
- 주요 샘플 파일
  - `naviSDKSample/AppDelegate.swift`
  - `naviSDKSample/SceneDelegate.swift`
  - `naviSDKSample/ViewController.swift`
  - `naviSDKSample/Sample/MapControllCollectionViewCell.swift`
  - `naviSDKSample/Sample/SearchCollectionViewCell.swift`
  - `naviSDKSample/Sample/RouteSearchCollectionViewCell.swift`
  - `naviSDKSample/Sample/SampleExtenstion.swift`

## 작업 순서

1. iOS 저장소에서 작업 브랜치 생성
   - 예: `feature/add-vitepress-docs`
2. 루트 `README.md` 작성
   - 프로젝트 개요
   - 배포 문서 링크: `https://inavi-systems.github.io/inavi-navigation-demo-ios/`
   - 샘플 실행 방법
   - 주요 코드 위치
3. `docs/index.md` 작성
   - iOS SDK 개발 가이드 본문
   - 현재 샘플 코드와 `Info.plist`, `Podfile` 기준으로 검증 가능한 내용부터 작성
4. `docs/.vitepress/config.mts` 추가
   - `base: '/inavi-navigation-demo-ios/'`
   - GitHub 링크는 iOS 저장소로 설정
   - `srcExclude: ['plans/**']`
5. `package.json` 추가
   - Android와 동일한 VitePress scripts 사용
6. `npm install` 실행
   - `package-lock.json` 생성
7. `.github/workflows/deploy-docs.yml` 추가
   - `master` push 및 수동 실행 배포
   - `npm ci`
   - `npm run docs:build`
8. `.gitignore` 갱신
   - `node_modules`
   - `docs/plans`
   - `docs/.vitepress/cache`
   - `docs/.vitepress/dist`
9. 로컬 빌드 검증
   - `npm run docs:build`
10. 필요 시 로컬 미리보기
   - `npm run docs:preview`
11. GitHub 저장소 Pages 설정
   - Settings > Pages
   - Build and deployment > Source: `GitHub Actions`
12. `master` 병합 후 Actions 배포 결과 확인

## 검증 항목

- `npm run docs:build` 성공
- `docs/.vitepress/dist` 생성
- VitePress 빌드 중 Markdown/HTML 렌더링 오류 없음
- GitHub Actions에서 `npm ci` 성공
- GitHub Actions에서 Pages artifact 업로드 성공
- `https://inavi-systems.github.io/inavi-navigation-demo-ios/` 접근 성공
- VitePress `base` 경로에서 CSS/JS asset 404 없음
- README의 배포 문서 링크가 실제 Pages URL과 일치
- iOS 샘플의 Xcode/CocoaPods 설정과 문서 내용 불일치 없음

## 주의 사항

- iOS 저장소에는 현재 루트 `README.md`가 없으므로 새로 작성해야 한다.
- Android처럼 `docs/index.md`에 전체 개발 가이드 본문을 둘지, README include 방식으로 둘지는 초기에 결정해야 한다. Android 최종 상태와 맞추려면 `docs/index.md` 독립 본문 방식이 적합하다.
- iOS SDK API reference는 현재 샘플 코드와 framework header에서 확인 가능한 범위만 문서화하고, 미확인 동작은 추정해서 쓰지 않는다.
- `docs/plans`를 만들 경우 `.gitignore`와 VitePress `srcExclude`를 같이 설정한다.
- GitHub Pages Source를 `GitHub Actions`로 바꾸지 않으면 workflow가 성공해도 Pages에 노출되지 않을 수 있다.
- 저장소명이 변경되거나 별도 문서용 repository를 사용하면 VitePress `base`와 README 배포 링크를 함께 변경해야 한다.
