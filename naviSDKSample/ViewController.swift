//
//  ViewController.swift
//  naviSDKSample
//
//  Created by DAECHEOL KIM on 2020/03/09.
//  Copyright © 2020 DAECHEOL KIM. All rights reserved.
//

import UIKit
import iNaviNavigationSdk

@objc public protocol INaviSampleProtocol {
    func onClickSearchItem(_ item:INaviSearchItem)
    func onClickGoalSetting(_ item:INaviSearchItem)
}

class ViewController: UIViewController {
    
    lazy var overlay = INaviMapOverlay.create()
    var pre_icon:INaviMapIcon?
    var goal_item:INaviSearchItem?
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectioViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth_Land: NSLayoutConstraint!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    var showMenuView = true
    var keyboardHeight:CGFloat = 0
    var keyboardShown = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.addObservers()
        let controller = INaviController.sharedInstance()
        controller.initalizeNavi("01012348520", target: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateCollectionViewLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { (context) in
        } completion: {[weak self] (context) in
            self?.view.layoutIfNeeded()
            self?.updateCollectionViewLayout()
        }
    }
    
    func updateCollectionViewLayout() {
        if collectioViewHeight.isActive {
            collectioViewHeight.constant = showMenuView ? self.contentsView.frame.size.height/2 : 0
        }
        if collectionViewWidth_Land.isActive {
            collectionViewWidth_Land.constant = showMenuView ? self.contentsView.frame.size.width/2 : 0
        }
        self.collectionView.sizeToFit()
    }
    
    func setGoal(_ item:INaviSearchItem){
        
        self.goal_item = item
        
        //icon setting
        let position = item.dpPosition
        let image = UIImage(named: "inv_map_route_pin_goal")
        if let img = image{
            let invImg = INaviImage(image: img)
            let icon = INaviMapIcon.createMapIcon(withPostion: position, nomalImage: invImg, anchor: .centerTop)
            if let pre_icon = pre_icon {
                INaviController.sharedInstance().removeMapIcon(with: overlay, mapIcon: pre_icon)
            }
            pre_icon = icon
            
            INaviController.sharedInstance().addMapIcon(with: overlay, mapIcon: icon)
            
            INaviController.sharedInstance().setMapPosition(position)
        }
        
    }

}

extension ViewController : INaviControllerDelegate {
    
    func authResultCode(_ resultCode: Int, message: String?) {
        if resultCode != 0 {
            let alert = UIAlertController(title: "인증 실패", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didLongTap(_ mapView: INaviMapView, position: INaviPosition?) {
        guard let position = position else { return }
        let item = INaviSearchItem()
        item.mainTitle = INaviController.sharedInstance().getJibunAddr(position) ?? ""
        item.dpPosition = position
        item.rpPosition = position
        self.setGoal(item)
        self.collectionView.reloadData()
    }
    
    func mapView(_ mapView: INaviMapView, menuTouch eventType: INVNaviEvent) {
        if eventType == .eventMulti {
            showMenuView = !showMenuView
            self.updateCollectionViewLayout()
        }
    }

    func mapView(_ mapView: INaviMapView, didChanged mapMoveMode: INVMapMoveMode) {
        print("mapmove = \(mapMoveMode.rawValue)")
    }
    
    func mapView(_ mapView: INaviMapView, didChanged rid: String?) {
        print("didRouteChangedRouteID = \(rid ?? "nil")")
    }
    
    
    func mapView(_ mapView: INaviMapView, didChanged drivingStatus: INVDrivingStatus) {
        print("didChangedDrivingStatus = \(drivingStatus.rawValue)")
    }
    func mapView(_ mapView: INaviMapView, carSpeed: Int) {
//        print("carSpeed = \(carSpeed)")
    }
    
}

extension ViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseId = "MapControllCollectionViewCell"
        if indexPath.row == 1 {
            reuseId = "SearchCollectionViewCell"
        }else if indexPath.row == 2 {
            reuseId = "RouteSearchCollectionViewCell"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        
        if let cell = cell as? SearchCollectionViewCell {
            cell.delegate = self
        } else if let cell = cell as? RouteSearchCollectionViewCell {
            cell.delegate = self
            cell.goal_item = self.goal_item
            cell.tableView.reloadData()
        }
        
        return cell
    }
}


//MARK: keyboard observer
extension ViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),
                                                         name: UIDevice.orientationDidChangeNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name: UIResponder.keyboardWillShowNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name: UIResponder.keyboardWillHideNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillChangeFrame),
                                                         name: UIResponder.keyboardWillChangeFrameNotification,
                                                         object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardShown = true
        updateCenterLayout()
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardShown = false
        updateCenterLayout()
    }
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardRect = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardRect.cgRectValue.height
    }
    @objc func orientationChanged(_ notification: Notification) {
        updateCenterLayout()
    }
    
    func updateCenterLayout() {
        var yCenter =  keyboardShown ? keyboardHeight / -2 : 0
        if UIDevice.current.orientation.isLandscape {
            yCenter = 0
        }
        centerYConstraint.constant = yCenter
    }
}

extension ViewController : INaviSampleProtocol {
    func onClickSearchItem(_ item: INaviSearchItem) {
        self.setGoal(item)
    }
    func onClickGoalSetting(_ item:INaviSearchItem) {
        self.setGoal(item)
        self.collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: true)
        self.collectionView.reloadData()
    }
}
