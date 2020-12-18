//
//  SearchCollectionViewCell.swift
//  naviSDKSample
//
//  Created by DAECHEOL KIM on 2020/09/23.
//  Copyright © 2020 DAECHEOL KIM. All rights reserved.
//

import UIKit
import iNaviNavigationSdk

class SearchTableCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var subTitleLb: UILabel!
    @IBOutlet weak var goalBt: UIButton!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.backgroundColor = UIColor.INVCellHighlighted
        }else {
            self.backgroundColor = UIColor.white
        }
    }
    
}

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate:INaviSampleProtocol?
    
    var bRecommendMode = false
    
    var recommendItems:[INaviRecommendWord] = []
    var searchItems:[INaviSearchItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func recommendRequest(_ query:String){
        INaviController.sharedInstance().runRecommendWord(query) {[weak self] (resultAry) in
            self?.recommendItems.removeAll()
            self?.searchItems.removeAll()
            if let resultAry = resultAry as? [INaviRecommendWord] {
                for item in resultAry {
                    self?.recommendItems.append(item)
                }
            }
            if self?.bRecommendMode ?? false {
                self?.tableView.reloadData()
            }
        } failHandler: { (code, msg) in
            
        }
    }
    
    func searchRequest(_ query:String) {
        
        bRecommendMode = false
        
        let curPositon = INaviController.sharedInstance().getCurrentPosition()
        
        INaviController.sharedInstance().runSearch(query, lat: curPositon.lat, lng: curPositon.lng) { [weak self] (resultItem) in
            self?.recommendItems.removeAll()
            self?.searchItems.removeAll()
            if let resultItem = resultItem {
                for item in resultItem.items {
                    self?.searchItems.append(item)
                }
            }

            self?.tableView.reloadData()
        } failHandler: {[weak self]  (code, msg) in
            self?.bRecommendMode = true
            self?.tableView.reloadData()
        }

    }
    @IBAction func onClickGoalButton(_ sender: UIButton) {
        let item = self.searchItems[sender.tag]
        self.delegate?.onClickGoalSetting(item)
    }
    
}

extension SearchCollectionViewCell: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bRecommendMode = true
        //update
        self.recommendRequest(searchText)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchRequest(searchBar.text ?? "")
    }
}

extension SearchCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bRecommendMode ? recommendItems.count : searchItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "통합 검색"
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: bRecommendMode ? "recommendCell" : "searchCell", for: indexPath)
        
        if bRecommendMode {
            let item = self.recommendItems[indexPath.row]
            cell.textLabel?.text = item.recommendWord
        }else {
            if let cell = cell as? SearchTableCell {
                let item = self.searchItems[indexPath.row]
                cell.titleLb?.text = "\(item.isSubItem ? "ㄴ " : "")\(item.mainTitle)"
                cell.subTitleLb?.text = "\(item.addrRoad)\n\(item.addrJibun)"
                cell.goalBt.tag = indexPath.row
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bRecommendMode {
            if self.recommendItems.count > indexPath.row {
                self.searchBar.text = self.recommendItems[indexPath.row].recommendWord
                self.recommendRequest(self.searchBar.text ?? "")
            }
        } else {
            if self.searchItems.count > indexPath.row {
                let item = self.searchItems[indexPath.row]
                self.delegate?.onClickSearchItem(item)
            }
        }
    }
}
