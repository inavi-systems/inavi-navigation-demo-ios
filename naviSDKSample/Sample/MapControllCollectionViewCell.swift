//
//  MapControllCollectionViewCell.swift
//  naviSDKSample
//
//  Created by DAECHEOL KIM on 2020/09/22.
//  Copyright © 2020 DAECHEOL KIM. All rights reserved.
//

import UIKit
import iNaviNavigationSdk
class MapControllCollectionViewCell: UICollectionViewCell {
    
    enum menuType:Int, CaseIterable {
        case CURRENTON = 0,VIEWMODE,FONTSIZE,DAYNIGHT,ZOOMIN,ZOOMOUT,ADDMAPICON,REMOVEMAPICON,TRAFFICON,ENABLEROTATE
        func toString() -> String {
            switch self{
            case .CURRENTON : return "지도 현위치 이동"
            case .VIEWMODE : return "지도 모드 변경"
            case .FONTSIZE : return "글자크기"
            case .DAYNIGHT : return "주/야간설정"
            case .ZOOMIN : return "지도 확대"
            case .ZOOMOUT : return "지도 축소"
            case .ADDMAPICON : return "지도 아이콘 추가"
            case .REMOVEMAPICON : return "지도 아이콘 제거"
            case .TRAFFICON : return "교통정보 라인 표출"
            case .ENABLEROTATE : return "지도 회전 세팅"
            }
            
        }
    }
    
    var menuItems = menuType.allCases.map { $0.toString() }
    
    var pre_icon:INaviMapIcon?
    lazy var overlay = INaviMapOverlay.create()
    var mTrafficOn = false
    var mEnableRotate = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension MapControllCollectionViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "지도 컨트롤"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.contentView.backgroundColor = UIColor.INVGray
            view.textLabel?.textAlignment = .center
            view.textLabel?.textColor = UIColor.INVGrayText
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 29
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "naviCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = INaviController.sharedInstance()
        
        let type:menuType? = menuType(rawValue: indexPath.row)
        if let type = type {
            
            let titleStr = type.toString()
            var subStr = ""
            
            switch type {
            case .CURRENTON :
                
                controller.setCarCurrentPosition()
            case .VIEWMODE :
                controller.mapViewMode = INVMapViewMode(rawValue: (controller.mapViewMode.rawValue + 1) % 3) ?? .mode3D
                
                if controller.mapViewMode == .mode3D {
                    subStr = "3D뷰"
                }else if controller.mapViewMode == .mode2D {
                    subStr = "2D 회전뷰"
                } else if controller.mapViewMode == .mode2DFIX {
                    subStr = "2D 고정뷰"
                }
                
            case .FONTSIZE :
                controller.mapFontType = INVMapFontType(rawValue: (controller.mapFontType.rawValue + 1) % 2) ?? .nomal
                
                if controller.mapFontType == .nomal {
                    subStr = "기본"
                }else if controller.mapFontType == .large {
                    subStr = "크게"
                }
                
            case .DAYNIGHT :
                controller.mapDayNightMode = INVMapDayNightMode(rawValue: (controller.mapDayNightMode.rawValue + 1) % 3) ?? .auto
                
                if controller.mapDayNightMode == .auto {
                    subStr = "시간대별 자동"
                }else if controller.mapDayNightMode == .alwaysDay {
                    subStr = "항상 주간"
                } else if controller.mapDayNightMode == .alwaysNight {
                    subStr = "항상 야간"
                }
                
            case .ZOOMIN :
                controller.zoomIn()
            case .ZOOMOUT :
                controller.zoomOut()
            case .ADDMAPICON :
                let position = INaviPosition(lat: 37.402333, lng: 127.110589)
                let image = UIImage(named: "inv_map_group_pin09")
                print("hash = \(image.hashValue)")
                if let img = image {
                    let invImg = INaviImage(image: img)
                    let icon = INaviMapIcon.createMapIcon(withPostion: position, nomalImage: invImg, anchor: .centerTop)
                    if let pre_icon = pre_icon {
                        controller.removeMapIcon(with: overlay, mapIcon: pre_icon)
                    }
                    pre_icon = icon
                    
                    controller.addMapIcon(with: overlay, mapIcon: icon)
                    controller.setMapPosition(position)
                }
            case .REMOVEMAPICON :
                if let pre_icon = pre_icon {
                    controller.removeMapIcon(with: overlay, mapIcon: pre_icon)
                }
            case .TRAFFICON :
                mTrafficOn = !mTrafficOn
                controller.visibleTrafficLine(mTrafficOn)
            case .ENABLEROTATE :
                mEnableRotate = !mEnableRotate
                controller.setMapEnableRotate(mEnableRotate)
                subStr = mEnableRotate ? "회전 가능" : "회전 불가"
            }
            
            if subStr.count != 0 {
                menuItems[indexPath.row] = "\(titleStr) : \(subStr)"
            } else {
                menuItems[indexPath.row] = titleStr
            }
            
            tableView.reloadData()
        }
    }
}
