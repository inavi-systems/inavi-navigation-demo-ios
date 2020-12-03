//
//  RouteSearchCollectionViewCell.swift
//  naviSDKSample
//
//  Created by DAECHEOL KIM on 2020/09/25.
//  Copyright © 2020 DAECHEOL KIM. All rights reserved.
//

import UIKit
import iNaviNavigationSdk

class RouteSearchHeaderCell:UITableViewCell {
    @IBOutlet weak var sNameLb: UILabel!
    @IBOutlet weak var gNameLb: UILabel!
    
}

class RouteSearchInfoCell:UITableViewCell {
    @IBOutlet weak var f_infoTitleLb: UILabel!
    @IBOutlet weak var f_infoDistanceLb: UILabel!
    @IBOutlet weak var f_infoRemainTimeLb: UILabel!
    @IBOutlet weak var f_infoFeelb: UILabel!
    @IBOutlet weak var f_button: UIButton!
    
    @IBOutlet weak var s_infoTitleLb: UILabel!
    @IBOutlet weak var s_infoDistanceLb: UILabel!
    @IBOutlet weak var s_infoRemainTimeLb: UILabel!
    @IBOutlet weak var s_infoFeelb: UILabel!
    @IBOutlet weak var s_button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.f_button.setBackgroundColor(UIColor.white, for: .normal)
        self.f_button.setBackgroundColor(UIColor.INVGray, for: .highlighted)
        self.f_button.setBackgroundColor(UIColor.INVGray, for: .selected)
        
        self.s_button.setBackgroundColor(UIColor.white, for: .normal)
        self.s_button.setBackgroundColor(UIColor.INVGray, for: .highlighted)
        self.s_button.setBackgroundColor(UIColor.INVGray, for: .selected)
    }
    
    
}

class RouteSearchMenuCell:UITableViewCell {
}
class RouteSearchCancelCell:UITableViewCell {
    @IBOutlet weak var cancelBt: UIButton!
}

class RouteSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate:INaviSampleProtocol?
    var goal_item:INaviSearchItem?
    var routeIdList:[String] = []
    var selectedIndex = 0
    var isLoading = false
    
    lazy var controller = INaviController.sharedInstance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onRoureSearch(_ sender: Any) {
        
        guard let item = goal_item , isLoading == false else { return }
                
        let ptItem = INaviRoutePtItem()
        ptItem.name = item.mainTitle
        ptItem.dpPosition = INaviPosition(lat: item.dpPosition.lat, lng: item.dpPosition.lng)
        ptItem.rpPosition = INaviPosition(lat: item.rpPosition.lat, lng: item.rpPosition.lng)
        
        selectedIndex = 0
        
        isLoading = true
        self.tableView.reloadData()
        
        controller.runRoute(nil, goalItem: ptItem, successHandler: {[weak self] (dataAry, isSame) in
//            controller.runGuidance(withRouteID: dataAry?.firstObject as? String ?? "")
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.routeIdList.removeAll()
                self?.routeIdList.append(contentsOf: dataAry as? [String] ?? [])
                self?.tableView.reloadData()
                self?.setRouteZoomMap()
            }
            
        }) { (code, msg) in
            
            print("code \(code) , msg = \(msg ?? "")")
        }
    }
    @IBAction func onGuideStart(_ sender: Any) {
        controller.runGuidance(withRouteID: self.routeIdList[selectedIndex])
        self.routeIdList.removeAll()
        self.tableView.reloadData()
    }
    @IBAction func onGuideCancel(_ sender: Any) {
        if controller.isSimulation() {
            controller.finishSimulation()
        }else {
            controller.cancelRoute()
        }
        self.routeIdList.removeAll()
        self.tableView.reloadData()
    }
    @IBAction func onSimulStart(_ sender: Any) {
        controller.startSimulation(withRouteID: self.routeIdList[selectedIndex])
        self.routeIdList.removeAll()
        self.tableView.reloadData()
    }
    @IBAction func onInfoSetected(_ sender: UIButton) {
        selectedIndex = sender.tag
        tableView.reloadData()
        self.setRouteZoomMap()
    }
    
    func setRouteZoomMap() {
        if self.routeIdList.count > selectedIndex {
            INaviController.sharedInstance().routeZoomMap(withRouteIdList: self.routeIdList, selectedRID: self.routeIdList[selectedIndex])
        }
    }
    
}

extension RouteSearchCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if controller.isGuidance() || controller.isSimulation() { return 1 }
        return routeIdList.count == 0 ? 1 : 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "경로 탐색"
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
        
        var cellIdentifier = "RouteSearchHeaderCell"
        if controller.isGuidance() || controller.isSimulation() {
            cellIdentifier = "RouteSearchCancelCell"
        }else{
            if indexPath.row == 1 {
                cellIdentifier = "RouteSearchInfoCell"
            } else if indexPath.row == 2 {
                cellIdentifier = "RouteSearchMenuCell"
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let controller = INaviController.sharedInstance()
        
        if let cell = cell as? RouteSearchHeaderCell {
            if self.isLoading {
                cell.sNameLb.text = "경로 탐색 진행 중 입니다."
                cell.gNameLb.text = "경로 탐색 진행 중 입니다."
            }else {
                cell.sNameLb.text = "출발지 : \(controller.getJibunAddr(controller.getCurrentPosition()) ?? "")"
                cell.gNameLb.text = "목적지 : \(goal_item?.mainTitle ?? "")"
            }
        } else if let cell = cell as? RouteSearchInfoCell {
            if self.routeIdList.count >= 2 {
                let f_suminfo = controller.makeRouteSumInfo(withRouteID: self.routeIdList[0])
                let s_suminfo = controller.makeRouteSumInfo(withRouteID: self.routeIdList[1])
                cell.f_infoTitleLb.text = f_suminfo.optionName
                cell.f_infoDistanceLb.text = f_suminfo.dist
                cell.f_infoRemainTimeLb.text = f_suminfo.time
                cell.f_infoFeelb.text = f_suminfo.fee
                
                cell.s_infoTitleLb.text = s_suminfo.optionName
                cell.s_infoDistanceLb.text = s_suminfo.dist
                cell.s_infoRemainTimeLb.text = s_suminfo.time
                cell.s_infoFeelb.text = s_suminfo.fee
                
                cell.f_button.isSelected = selectedIndex == 0
                cell.s_button.isSelected = selectedIndex == 1
                cell.s_button.isEnabled = true
            }else if self.routeIdList.count == 1 {
                let f_suminfo = controller.makeRouteSumInfo(withRouteID: self.routeIdList[0])
                cell.f_infoTitleLb.text = f_suminfo.optionName
                cell.f_infoDistanceLb.text = f_suminfo.dist
                cell.f_infoRemainTimeLb.text = f_suminfo.time
                cell.f_infoFeelb.text = f_suminfo.fee
                
                cell.s_infoTitleLb.text = ""
                cell.s_infoDistanceLb.text = ""
                cell.s_infoRemainTimeLb.text = ""
                cell.s_infoFeelb.text = ""
                
                cell.f_button.isSelected = true
                cell.s_button.isEnabled = false
            }
        } else if let cell = cell as? RouteSearchCancelCell {
            cell.cancelBt.setTitle(controller.isSimulation() ? "모의주행종료":"경로취소", for: .normal)
        }
        
        return cell
    }
}

