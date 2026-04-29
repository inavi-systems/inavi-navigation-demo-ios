# iNavi SDK iOS 개발 가이드 — 아이나비 에어

## 개정이력

### v0.0.1 — 2020-12-07
- 인증 업데이트 추가

### v0.0.2 — 2020-12-18
- 기능 현행화 (기본 폰트 변경 등)

### v0.0.3 — 2020-12-24
- 상단 TBT 레이아웃 오류 개선
- 상단 SafeArea 적용 I/F 추가

### v0.0.4 — 2023-06-27
- xcframework 적용
- 지도 미표출 오류 수정

### v0.0.5 — 2024-04-11
- 트럭향 옵션 I/F 추가
- 확대도 표출 I/F 추가
- 경유지 도착 프로토콜 추가
- 좌우 SafeArea 적용 I/F 추가
- TBT 컬러 변경 I/F 추가
- 고속모드 표출 사양 추가
- 다중 경유지 설정 추가

### v0.0.6 — 2024-09-02
- 지도 경로선 표출 개선
- 초기 인증 후 비정상 종료 이슈 수정

### v0.0.7 — 2025-03-12
- iMPS 내제화에 따른 인증 서버 전환

---

## 개요

본 문서는 iOS 기반 플랫폼에서 구동되는 **아이나비 내비게이션 SDK**(이하 SDK) 연동에 대한 기술 문서입니다.

## Appkey 발급

SDK를 사용하기 위해서는 우선 Appkey 발급이 필요합니다. (규격서 제공 제휴 사업 담당자를 통해 별도 요청 필요)

## 개발 환경

- 개발 도구: Xcode
- 개발 언어: Objective-C, Swift
- SDK 지원 범위
  - iOS Deployment Target: iOS 13

## SDK 배포 형식

- CocoaPods

## SDK 적용 방법

### 1. Podfile 구성

CocoaPods를 통해 배포되므로, 프로젝트의 `Podfile`에 아래와 같이 의존성을 추가합니다.

```ruby
target 'naviSDKSample' do
  pod 'inavi-navigation-sdk'
end
```

### 2. SDK 설치

의존성 설정 후 Terminal에서 프로젝트 경로로 이동한 다음 아래 명령어를 실행합니다.

```bash
$ pod install --repo-update
```

CocoaPods 캐시 삭제가 필요한 경우:

```bash
$ pod cache clean inavi-navigation-sdk
$ pod update inavi-navigation-sdk
```

---

## SDK 필수 권한

### Background Mode 설정

- Audio, Airplay and picture in picture
- Location updates

### 프로젝트 plist 설정

- App Transport Security Settings — http 허용
- 인증을 위한 `INaviAppKey` 설정
- 위치 권한 문구 설정

```xml
<plist version="1.0">
<dict>
    ...
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>

    <key>INaviAppKey</key>
    <string>YOUR_APP_KEY</string>

    <key>NSLocationTemporaryUsageDescriptionDictionary</key>
    <dict>
        <key>NaviSDKTemporary</key>
        <string>길 안내를 위해 정확한 GPS를 설정해주세요.</string>
    </dict>

    <key>NSLocationWhenInUseUsageDescription</key>
    <string>길 안내를 위해 GPS를 ON 하시겠습니까?</string>
    ...
</dict>
</plist>
```

---

## SDK Layout 추가

### ViewController에서 지도 추가

`ViewController`에 `INaviMapView`를 서브 뷰로 추가하여 지도를 표출합니다.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let mapView = INaviMapView(frame: view.bounds)
    view.addSubview(mapView)
}
```

### Interface Builder에서 지도 추가

XIB 또는 Storyboard 등 Interface Builder를 통해서도 지도를 표출할 수 있습니다. `UIView`를 추가하고 Custom Class를 `INaviMapView`로 설정하면 됩니다.

---

## SDK Interface

1. **AIR SDK**는 `INaviController` 클래스를 통해 SDK의 모든 기능을 활용합니다.
   - `INaviController`는 Singleton 객체로 어디에서든 호출 가능
   - SDK에서 제공하는 Delegate와 Block을 추가하여 SDK 연동 및 이벤트 감지

2. **좌표계**
   - SDK 호출 시 위경도 좌표를 사용
   - DD(십진수 도) 방식 사용
   - 예) 서울역 — 위도: 37.553173, 경도: 126.972471

---

## INaviController Reference

### 초기화

#### `initalizeNavi`

```swift
func initalizeNavi(_ uniqueID: String, target: INaviControllerDelegate)
```

SDK 엔진을 초기화합니다.

- 초기화 결과가 성공인 경우에만 SDK가 정상 동작

| 파라미터 | 설명 |
|---|---|
| `uniqueID` | 유일 식별자 (필수, 20자 이하 Alphanumeric) |
| `target` | `INaviControllerDelegate` — 초기화 성공 여부 Callback |
| **Return** | void |

---

### 지도 컨트롤

#### `didLongTap`

```swift
func didLongTap(_ mapView: INaviMapView, position: INaviPosition?)
```

`INaviControllerDelegate` Protocol — 지도 롱클릭 이벤트를 수신합니다.

| 파라미터 | 설명 |
|---|---|
| `mapView` | `INaviMapView` 객체 |
| `position` | 롱 탭한 위경도 좌표 |
| **Return** | void |

---

#### `setCarCurrentPosition`

```swift
func setCarCurrentPosition()
```

지도를 GPS 위치로 이동합니다.

---

#### `setCarPosition`

```swift
func setCarPosition(_ position: INaviPosition)
```

지도와 자차를 특정 위치로 이동합니다.

| 파라미터 | 설명 |
|---|---|
| `position` | `INaviPosition` 객체 |
| **Return** | void |

---

#### `setMapPosition`

```swift
func setMapPosition(_ position: INaviPosition)
```

지도를 특정 위치로 이동합니다.

| 파라미터 | 설명 |
|---|---|
| `position` | `INaviPosition` 객체 |
| **Return** | void |

---

#### `zoomIn`

```swift
func zoomIn()
```

현재 레벨 기준으로 한 단계 확대합니다.

---

#### `zoomOut`

```swift
func zoomOut()
```

현재 레벨 기준으로 한 단계 축소합니다.

---

#### `mapViewMode`

```swift
var mapViewMode: INVMapViewMode
```

지도 뷰 모드를 반환하거나 변경합니다.

| | |
|---|---|
| **Value** | `INVMapViewMode` — Define Ref. 참고 |

---

#### `visibleTrafficLine`

```swift
func visibleTrafficLine(_ show: Bool)
```

지도에 교통정보 라인 표출 여부를 설정합니다.

| 파라미터 | 설명 |
|---|---|
| `show` | `true`: 표출 / `false`: 미표출 |
| **Return** | void |

---

#### `INaviMapOverlay.create`

```swift
class func create() -> INaviMapOverlay
```

지도 아이콘을 관리하는 overlay를 생성하고 반환합니다.

| | |
|---|---|
| **Return** | `INaviMapOverlay` |

---

#### `INaviMapIcon.createMapIcon`

```swift
class func createMapIcon(
    withPostion position: INaviPosition,
    nomalImage: INaviImage,
    selectedImage: INaviImage,
    anchor: INVIconAnchor,
    minLevel: Int,
    maxLevel: Int,
    clickable: Bool
) -> INaviMapIcon
```

지도 아이콘을 생성하고 반환합니다.

| 파라미터 | 설명 |
|---|---|
| `position` | `INaviPosition` 객체 |
| `nomalImage` | 기본 `INaviImage` 이미지 |
| `selectedImage` | 선택 상태 이미지 |
| `anchor` | 아이콘 표출 위치 (Define Ref. 참고) |
| `minLevel` | 표출될 최소 지도 레벨 |
| `maxLevel` | 표출될 최대 지도 레벨 |
| `clickable` | 클릭 이벤트 동작 여부 |
| **Return** | `INaviMapIcon` |

**간략형:**

```swift
class func createMapIcon(
    withPostion position: INaviPosition,
    nomalImage: INaviImage,
    anchor: INVIconAnchor
) -> INaviMapIcon
```

---

#### `addMapIcon`

```swift
func addMapIcon(with mapOverlay: INaviMapOverlay, mapIcon: INaviMapIcon)
```

overlay에 지도 아이콘을 추가합니다.

| 파라미터 | 설명 |
|---|---|
| `mapOverlay` | 아이콘이 추가될 overlay |
| `mapIcon` | 추가할 지도 아이콘 |
| **Return** | void |

---

#### `removeMapIcon`

```swift
func removeMapIcon(with mapOverlay: INaviMapOverlay, mapIcon: INaviMapIcon)
```

overlay에서 지도 아이콘을 제거합니다.

---

#### `removeMapIconAll`

```swift
func removeMapIconAll(with mapOverlay: INaviMapOverlay)
```

overlay에 포함된 모든 지도 아이콘을 제거합니다.

---

#### `routeZoomMap`

```swift
func routeZoomMap(withRouteIdList ridList: [String], selectedRID: String)
```

탐색 경로 비율에 맞게 지도 스케일을 조절합니다.

| 파라미터 | 설명 |
|---|---|
| `ridList` | 탐색결과 경로 ID 배열 (`runRoute()`, `runSingleRoute()` 에서 획득) |
| `selectedRID` | 활성화할 경로 ID |
| **Return** | void |

---

#### `mapLevel`

```swift
var mapLevel: Int
```

지도 레벨을 반환하거나 변경합니다. (유효 범위: 1 ~ 13)

---

#### `mapFontType`

```swift
var mapFontType: INVMapFontType
```

지도 주기 폰트 사이즈 타입을 반환하거나 변경합니다.

| | |
|---|---|
| **Value** | `INVMapFontType` — Define Ref. 참고 |

---

#### `mapDayNightMode`

```swift
var mapDayNightMode: INVMapDayNightMode
```

지도 주/야 타입을 반환하거나 변경합니다.

---

#### `setMapEnableRotate`

```swift
func setMapEnableRotate(_ enable: Bool)
```

지도 회전 가능 여부를 설정합니다.

| 파라미터 | 설명 |
|---|---|
| `enable` | `true`: 회전 가능 / `false`: 회전 불가 |
| **Return** | void |

---

#### `mapMoveMode`

```swift
func mapView(_ mapView: INaviMapView, didChanged mapMoveMode: INVMapMoveMode)
```

`INaviControllerDelegate` Protocol — 지도 제스처를 통한 지도이동 Callback입니다.

| 파라미터 | 설명 |
|---|---|
| `mapMoveMode` | 지도이동 시작/종료 |
| **Return** | void |

---

#### `forceHideMapComponent`

```swift
func forceHideMapComponent(_ componentID: INVMapComponent, hide: Bool)
```

지도 컴포넌트를 강제로 숨기거나 표출합니다.

| 파라미터 | 설명 |
|---|---|
| `componentID` | 지도 컴포넌트 타입 (Define Ref. 참고) |
| `hide` | `true`: 미표출 / `false`: 표출 |
| **Return** | void |

---

### 통합 검색

#### `runSearch`

```swift
func runSearch(
    _ query: String,
    lat: Double,
    lng: Double,
    successHandler: @escaping INaviSearchSuccessHandler,
    failHandler: @escaping INaviFailHandler
)
```

통합검색 결과를 반환합니다.

| 파라미터 | 설명 |
|---|---|
| `query` | 검색어 |
| `lat` | 기준 좌표 위도 |
| `lng` | 기준 좌표 경도 |
| `successHandler` | 검색 성공 Handler |
| `failHandler` | 검색 실패 Handler (코드 표 참고) |
| **Return** | void |

---

#### `runRecommendWord`

```swift
func runRecommendWord(
    _ query: String,
    successHandler: @escaping INaviRecommendSearchSuccessHandler,
    failHandler: @escaping INaviFailHandler
)
```

검색 추천어를 반환합니다.

---

#### `getJibunAddr`

```swift
func getJibunAddr(_ position: INaviPosition) -> String?
```

축약형 지번 주소를 반환합니다.

| 파라미터 | 설명 |
|---|---|
| `position` | `INaviPosition` 객체 |
| **Return** | `String?` — 축약형 지번 주소 |

---

### 길 찾기

#### `runRoute`

```swift
func runRoute(
    _ startItem: INaviRoutePtItem?,
    goalItem: INaviRoutePtItem,
    viaList: [INaviRoutePtItem]?,
    successHandler: @escaping INaviRouteMultiSuccessHandler,
    failHandler: @escaping INaviFailHandler
)
```

멀티 경로를 탐색합니다.

| 파라미터 | 설명 |
|---|---|
| `startItem` | 출발지 정보 (`nil` 이면 현위치 기반 탐색) |
| `goalItem` | 목적지 정보 |
| `viaList` | 경유지 리스트 (최대 100개) |
| `successHandler` | 탐색 성공 Handler |
| `failHandler` | 탐색 실패 Handler (코드 표 참고) |
| **Return** | void |

---

#### `runSingleRoute`

```swift
func runSingleRoute(
    _ startItem: INaviRoutePtItem?,
    goalItem: INaviRoutePtItem,
    viaList: [INaviRoutePtItem]?,
    routeOption opt: INVRouteOptionType,
    successHandler: @escaping INaviRouteSingleSuccessHandler,
    failHandler: @escaping INaviFailHandler
)
```

단일 경로를 탐색합니다.

| 파라미터 | 설명 |
|---|---|
| `startItem` | 출발지 정보 (`nil` 이면 현위치 기반 탐색) |
| `goalItem` | 목적지 정보 |
| `viaList` | 경유지 리스트 (최대 100개) |
| `opt` | 탐색 옵션 (Define Ref. 참고) |
| `successHandler` | 탐색 성공 Handler |
| `failHandler` | 탐색 실패 Handler |
| **Return** | void |

---

#### `makeRouteSumInfo`

```swift
func makeRouteSumInfo(withRouteID rid: String) -> INaviRouteSumInfo
```

경로의 간단한 요약 정보를 반환합니다.

| 파라미터 | 설명 |
|---|---|
| `rid` | 경로 ID |
| **Return** | `INaviRouteSumInfo` — Structure Ref. 참고 |

---

#### `getRoutePtInfo`

```swift
func getRoutePtInfo(withRouteID rid: String, routePtType type: INVRoutePtType) -> INaviRoutePtItem
```

경로의 출발지 / 목적지 정보를 반환합니다.

| 파라미터 | 설명 |
|---|---|
| `rid` | 경로 ID |
| `type` | 지점 타입 (Define Ref. 참고) |
| **Return** | `INaviRoutePtItem` — Structure Ref. 참고 |

---

#### `getRouteLinePoints`

```swift
func getRouteLinePoints(withRouteID rid: String) -> String
```

경로 Line 좌표열을 반환합니다.

| 파라미터 | 설명 |
|---|---|
| `rid` | 경로 ID |
| **Return** | `String` — 경로 Line JSON 형태 좌표 문자열 |

---

#### `cancelRoute`

```swift
func cancelRoute()
```

경로를 취소합니다.

---

#### `fOptionType`

```swift
var fOptionType: INVRouteOptionType
```

첫 번째 탐색 옵션 타입 (Default: 빠른길)

---

#### `sOptionType`

```swift
var sOptionType: INVRouteOptionType
```

두 번째 탐색 옵션 타입 (Default: 추천길)

---

### 주행

#### `runGuidance`

```swift
func runGuidance(withRouteID rid: String) -> Int
```

주행을 시작합니다.

- 선택된 경로 ID를 제외한 나머지 경로는 삭제됨

| 파라미터 | 설명 |
|---|---|
| `rid` | 경로 ID |
| **Return** | `Int` — `0`: 성공 / 그 외: 실패 |

---

#### `isSimulation`

```swift
func isSimulation() -> Bool
```

모의 주행 여부를 반환합니다.

---

#### `startSimulation`

```swift
func startSimulation(withRouteID rid: String) -> Int
```

모의 주행을 시작합니다.

---

#### `finishSimulation`

```swift
func finishSimulation() -> Int
```

모의 주행을 종료합니다.

---

#### `getRemainRouteInfo`

```swift
func getRemainRouteInfo() -> INaviRouteRemainInfo
```

주행 중 남은 거리/시간 정보를 반환합니다.

| | |
|---|---|
| **Return** | `INaviRouteRemainInfo` — Structure Ref. 참고 |

---

### 기타

#### `NaviSDKVersionNumber`

```swift
var NaviSDKVersionNumber: Double
```

SDK 버전 번호를 반환합니다.

---

#### `naviVolume`

```swift
var naviVolume: Float
```

내비게이션 볼륨을 반환하거나 설정합니다. (단말기 미디어 볼륨과 별개, 범위: `0.0 ~ 1.0`)

---

#### `getCurrentPosition`

```swift
func getCurrentPosition() -> INaviPosition
```

현재 위치를 반환합니다.

| | |
|---|---|
| **Return** | `INaviPosition` — Structure Ref. 참고 |

---

#### `menuTouch`

```swift
func mapView(_ mapView: INaviMapView, menuTouch eventType: INVNaviEvent)
```

`INaviControllerDelegate` Protocol — 아이나비 버튼 클릭 시 호출됩니다.

| 파라미터 | 설명 |
|---|---|
| `mapView` | `INaviMapView` 객체 |
| `eventType` | 클릭 메뉴 타입 (Define Ref. 참고) |
| **Return** | void |

---

#### `route change`

```swift
func mapView(_ mapView: INaviMapView, didChanged rid: String?)
```

`INaviControllerDelegate` Protocol — 주행 재탐색 성공 시 호출됩니다.

| 파라미터 | 설명 |
|---|---|
| `mapView` | `INaviMapView` 객체 |
| `rid` | 재탐색 성공 시 RouteID 전달 |
| **Return** | void |

---

#### `drivingStatus change`

```swift
func mapView(_ mapView: INaviMapView, didChanged drivingStatus: INVDrivingStatus)
```

`INaviControllerDelegate` Protocol — 주행 시작/도착 시 호출됩니다.

| 파라미터 | 설명 |
|---|---|
| `mapView` | `INaviMapView` 객체 |
| `drivingStatus` | 주행 시작/종료 타입 (Define Ref. 참고) |
| **Return** | void |

---

#### `carSpeed`

```swift
func mapView(_ mapView: INaviMapView, carSpeed: Int)
```

`INaviControllerDelegate` Protocol — 차량 속도를 전달합니다.

---

#### `layoutTopSafeArea`

```swift
var layoutTopSafeArea: Bool
```

Top SafeArea 영역을 지도 컴포넌트에 적용합니다.

| | |
|---|---|
| **Value** | `true`: 상단 SafeArea 적용 / `false`: 미적용 (Default) |

---

#### `layoutLeftRightSafeArea`

```swift
var layoutLeftRightSafeArea: Bool
```

좌우 SafeArea 영역을 지도 컴포넌트에 적용합니다.

| | |
|---|---|
| **Value** | `true`: 좌우 SafeArea 적용 / `false`: 미적용 (Default) |

---

#### `carType`

```swift
var carType: INVCarType
```

차종을 설정합니다.

| | |
|---|---|
| **Value** | `INVCarType` — Define Ref. 참고 |

---

#### `carHeight`

```swift
var carHeight: Int
```

차량 높이를 설정합니다. (0 ~ 1000cm)

설정 시 높이제한구역 회피 안내가 적용됩니다.

---

#### `carWeight`

```swift
var carWeight: Int
```

차량 중량을 설정합니다. (0 ~ 60000kg)

설정 시 중량제한구역 회피 안내가 적용됩니다.

---

#### `nAvoidUturn`

```swift
var nAvoidUturn: Int
```

왕복 n차선 이하 유턴 회피를 설정합니다.

---

#### `nAvoidNarrowRoad`

```swift
var nAvoidNarrowRoad: Int
```

왕복 n차선 이하 도로 회피 여부를 설정합니다.

---

#### `bTruckType`

```swift
var bTruckType: Bool
```

화물차 여부를 설정합니다.

---

#### `tbtColor`

```swift
var tbtColor: UIColor
```

차기 TBT 색상을 설정합니다.

---

#### `nextTbtColor`

```swift
var nextTbtColor: UIColor
```

차차기 TBT 색상을 설정합니다.

---

## SDK Structure Reference

### `INaviPosition`

```swift
class INaviPosition {
    private(set) var lat: Double    // 위도 (도 단위)
    private(set) var lng: Double    // 경도 (도 단위)
    private(set) var angle: Double  // 각도
    private(set) var speed: Double  // 속도
}
```

### `INaviSearchResult`

```swift
class INaviSearchResult {
    var query: String              // 검색에 사용된 검색어
    var items: [INaviSearchItem]   // 검색 결과 리스트
}
```

### `INaviSearchItem`

```swift
class INaviSearchItem {
    var dpPosition: INaviPosition  // 지도 위치보기 좌표
    var rpPosition: INaviPosition  // 길 찾기 좌표
    var mainTitle: String          // 검색 결과 타이틀
    var addrJibun: String          // 지번 주소
    var addrRoad: String           // 도로명 주소
    var distance: Int              // 기준좌표와의 거리
    var isSubItem: Bool            // 하위 결과 여부
}
```

### `INaviRecommendWord`

```swift
class INaviRecommendWord {
    var recommendWord: String?  // 추천어
    var frequency = 0           // 추천어 조회 빈도 수
}
```

### `INaviRoutePtItem`

```swift
class INaviRoutePtItem {
    var name: String              // 지점 명칭
    var dpPosition: INaviPosition // 지도 위치보기 좌표
    var rpPosition: INaviPosition // 길 찾기 좌표
}
```

### `INaviRouteSumInfo`

```swift
class INaviRouteSumInfo {
    var optionName: String  // 길 찾기 시 사용된 옵션 명칭
    var dist: String        // 경로 총 거리
    var time: String        // 목적지 도착 예정 시간
    var fee: String         // 톨게이트 총 요금
}
```

### `INaviRouteRemainInfo`

```swift
class INaviRouteRemainInfo {
    var remainTime: Int  // 남은 시간 (초 단위)
    var remainDist: Int  // 남은 거리 (m 단위)
    var remainFee: Int   // 남은 요금 (원 단위), 계산 실패 시 -1
}
```

### `INaviTruckInfo`

```swift
class INaviTruckInfo {
    var type: INVTruckInfoType  // 유턴/좁은길 안내 타입
    var dist: NSInteger         // 거리
    var x: Double               // 경도
    var y: Double               // 위도
}
```

---

## SDK Define Reference

### `INVMapViewMode`

```swift
enum INVMapViewMode: Int {
    case mode3D    // 3D 뷰
    case mode2D    // 2D 회전 뷰 (자차가 정북 고정)
    case mode2DFIX // 2D 고정 뷰 (지도가 정북 고정)
}
```

### `INVIconAnchor`

```swift
enum INVIconAnchor: Int {
    case center      // 이미지 정중앙이 MapIcon 좌표 위치
    case centerTop   // 이미지 정중앙 하단이 MapIcon 좌표 위치 (이미지 상단 이동)
    case leftTop     // 이미지 우측 하단이 MapIcon 좌표 위치 (이미지 좌측 상단 이동)
    case rightTop    // 이미지 좌측 하단이 MapIcon 좌표 위치 (이미지 우측 상단 이동)
    case leftBottom  // 이미지 우측 상단이 MapIcon 좌표 위치 (이미지 좌측 하단 이동)
    case rightBottom // 이미지 좌측 상단이 MapIcon 좌표 위치 (이미지 우측 하단 이동)
}
```

### `INVMapFontType`

```swift
enum INVMapFontType: Int {
    case invMapFontNomal  // 기본 사이즈
    case invMapFontLarge  // 확대 사이즈
}
```

### `INVMapDayNightMode`

```swift
enum INVMapDayNightMode: Int {
    case auto        // 시간대별 주/야 자동 변경
    case alwaysDay   // 항상 주간
    case alwaysNight // 항상 야간
}
```

### `INVRoutePtType`

```swift
enum INVRoutePtType: Int {
    case invRoutePtStart // 출발지
    case invRoutePtGoal  // 목적지
}
```

### `INVNaviEvent`

```swift
enum INVNaviEvent: Int {
    case eventMain        // 하단바 좌측 메인 메뉴 버튼
    case eventMulti       // 하단바 우측 멀티 메뉴 버튼
    case evenGuideCancel  // 목적지 도착 하단바 안내종료 버튼
    case evenVolume       // 지도이동 시 볼륨 버튼
}
```

### `INVDrivingStatus`

```swift
enum INVDrivingStatus: Int {
    case start    // 주행 시작
    case nearGoal // 목적지 근처 (~100m)
    case arrival  // 주행 완료
}
```

### `INVRouteOptionType`

```swift
enum INVRouteOptionType: Int {
    case timePrioty        // 빠른길
    case recommend         // 추천길
    case freeRoad          // 무료길
    case beginner          // 편한길
    case motorcycle        // 이륜차
    case highwayPrioty     // 고속도로우선
    case distancePrioty    // 최단거리
    case truck             // 실시간 만차
    case truckFreeRoad     // 실시간 만차(무료)
    case truck2            // 실시간 공차
    case truck2FreeRoad    // 실시간 공차(무료)
    case truckNationalWay  // 국도 만차
    case truck2NationalWay // 국도 공차
}
```

### `INVMapComponent`

```swift
enum INVMapComponent: Int {
    case ALL_COMPONENT             // 모든 지도 컴포넌트
    case ANGLE_BTN                 // 나침반 버튼
    case CUR_ON_BTN                // 현위치로 버튼
    case ZOOM_IN_OUT_BTN           // 확대/축소 버튼
    case BOTTOM_NORMAL_VIEW        // 지도 하단 뷰 (경로 없는 경우)
    case BOTTOM_DRIVING_VIEW       // 지도 하단 뷰 (경로 존재하는 경우)
    case TOP_ARRIVAL_VIEW          // 목적지 도착 상단 뷰
    case BOTTOM_ARRIVAL_VIEW       // 목적지 도착 하단 뷰
    case ROUTE_TRAFFIC_STATUS_BAR  // 주행 중 우측 교통정보 바
}
```

### `INVCarType`

```swift
enum INVCarType: Int {
    case CarType_1 // 1종(소형차) — 일반승용, 승합16인 이하, 화물2.5톤 미만
    case CarType_2 // 2종(중형차) — 승합32인 이하, 화물5.5톤 이하
    case CarType_3 // 3종(대형차) — 승합33인 이상, 화물10톤 미만
    case CarType_4 // 4종(대형화물차) — 화물20톤 미만
    case CarType_5 // 5종(특수화물차) — 화물20톤 이상
    case CarType_6 // 경차 — 1종: 통행료 할인 적용
    case CarType_7 // 이륜차
}
```

### `INVTruckInfoType`

```swift
enum INVTruckInfoType: Int {
    case UNKNOWN // 알 수 없음
    case NARROW  // 좁은길
    case UTURN   // 유턴
}
```

---

## 시나리오별 예시 (Swift)

### 1. SDK 초기화

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    let mapView = INaviMapView(frame: view.bounds)
    view.addSubview(mapView)

    let controller = INaviController.sharedInstance()
    controller.initalizeNavi("01012348520", target: self)
}

// INaviControllerDelegate
// 인증 성공 후 SDK 모든 기능이 동작합니다.
func authResultCode(_ resultCode: Int, message: String?) {
    if resultCode == 0 {
        // 인증 성공
    } else {
        // 인증 실패
    }
}
```

### 2. 지도 아이콘 표출 및 제거

```swift
// 지도 overlay 생성
let overlayMap = INaviMapOverlay.create()

// 지도 아이콘 생성
let mapIcon = INaviMapIcon.createMapIcon(
    withPostion: INaviPosition(lat: 37.0000, lng: 127.0000),
    nomalImage: INaviImage(image: UIImage("testImage")),
    anchor: .centerTop
)

// overlay에 지도 아이콘 추가
INaviController.sharedInstance().addMapIcon(with: overlayMap, mapIcon: mapIcon)

// 지도 아이콘 제거
INaviController.sharedInstance().removeMapIcon(with: overlayMap, mapIcon: mapIcon)
```

### 3. 검색

```swift
let query = "검색어"
let curPosition = INaviController.sharedInstance().getCurrentPosition()

INaviController.sharedInstance().runSearch(
    query,
    lat: curPosition.lat,
    lng: curPosition.lng
) { [weak self] resultItem in
    // 검색 성공 처리
} failHandler: { [weak self] code, msg in
    // 검색 실패 처리
}
```

### 4. 길 찾기 및 안내 시작

```swift
let controller = INaviController.sharedInstance()

// 출발지 (nil이면 현위치 기반 탐색)
let startPoint: INaviRoutePtItem? = nil

// 목적지
let goalPoint = INaviRoutePtItem()
goalPoint.name = "목적지"
goalPoint.dpPosition = INaviPosition(lat: 37.0, lng: 127.0)
goalPoint.rpPosition = INaviPosition(lat: 37.0, lng: 127.0)

var routeId = ""

// 탐색 옵션 설정 (미설정 시 기본 빠른길, 추천길 탐색)
controller.fOptionType = .timePrioty
controller.sOptionType = .truck

// 길 찾기 시작
controller.runRoute(startPoint, goalItem: goalPoint, successHandler: { [weak self] dataAry, isSame in
    let ary = dataAry as? [String] ?? []
    routeId = ary.first ?? ""
    controller.routeZoomMap(withRouteIdList: ary, selectedRID: routeId)
}) { code, msg in
    // 길 찾기 실패 처리
}

// ...

// 주행 안내 시작
controller.runGuidance(withRouteID: routeId)

// 모의 주행 시작
controller.startSimulation(withRouteID: routeId)
```

### 5. 화물차 전용 옵션 적용

> 설정 값은 재실행 시에도 유지되며, 앱 삭제 시 초기화됩니다.
> 회피옵션이 설정되어 있어도 해당 경로가 유일한 경우에는 제한구역을 포함하는 경로로 안내될 수 있습니다.

```swift
let controller = INaviController.sharedInstance()

// 현재 설정값 조회
let nHeight: Int = controller.carHeight           // default: 0
let nWeight: Int = controller.carWeight           // default: 0
let nAvoidNarrow: Int = controller.nAvoidNarrowRoad // default: 0
let nAvoidUturn: Int = controller.nAvoidUturn     // default: 0
let bIsAvoidRestriction: Bool = controller.bIsAvoidRestriction // default: false

// 도로통과 높이 제한 설정 (cm, 0 ~ 1000)
controller.carHeight = 500

// 도로통과 중량 제한 설정 (kg, 0 ~ 60000)
controller.carWeight = 1500

// 왕복 n차선 이하 유턴 회피
controller.nAvoidUturn = 2

// 왕복 n차선 이하 도로 회피
controller.nAvoidNarrowRoad = 4

// 화물차 통행제한구간 회피
controller.bIsAvoidRestriction = true
```

---

## 코드 표

| 코드 값 | 설명 |
|---|---|
| 0 | 성공 |
| 1 | 탐색 실패 |
| 3 | 목적지가 물리적 섬 도로 |
| 32 | 탐색 가능 거리 초과 |
| 35 | 두 지점이 너무 가까운 경우 |
| 120 | 최적경로 (재탐색 성공했으나 더 좋은 경로가 없는 경우) |
| 121 | 목적지 부근으로 재탐색이 필요 없는 경우 |
| 901 | 인증 정보가 변경되어 앱 재시작 필요 |
| 903 | 조회결과 없음 |
| 1000 | 인증 데이터 오류 |
| 1002 | 유효하지 않은 형식으로 인증 요청 |
| 1003 | 인증 데이터가 존재하지 않음 |
| 1004 | 유효하지 않은 Unique Key (Null 또는 Empty) |
| 2000 | 처리되지 않은 예외 발생 |
| 2001 | 유효하지 않은 출발지 |
| 2003 | 유효하지 않은 목적지 |
| 2006 | 서버 응답 오류 |
| 3001 | 초기 지도 다운로드 실패 |
| 3006 | 안전운행 다운로드 실패 |
| 3007 | 인증 실패 |
| 4000 | 검색 결과 없음 |
| 4001 | 유효하지 않은 검색어 |
