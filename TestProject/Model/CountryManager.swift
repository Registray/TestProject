//
//  CountryManager.swift
//  TestProject
//
//  Created by mac on 11/26/20.
//

import UIKit

class CountryManager: NSObject, UITableViewDelegate , UITableViewDataSource {
    
    let countryView = UIView()
    let countryTableView = UITableView()
    let arrayOfCountry = ["us", "ua", "ve", "za", "nz", "fr", "gr","rs"]
    var myMainVC: TestTableViewController?
    
    public func openCountry() {
        if let window = UIApplication.shared.keyWindow {
            countryView.frame = window.frame
            countryView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            countryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissCountryMenu)))
            
            let height: CGFloat = 250
            
            let y = window.frame.height - height
            
            countryTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            window.addSubview(countryView)
            window.addSubview(countryTableView)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.countryView.alpha = 1
                self.countryTableView.frame.origin.y = y
            })
        }
    }
    
    @objc public func dismissCountryMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.countryView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.countryTableView.frame.origin.y = window.frame.height
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as UITableViewCell
        cell.textLabel?.text = arrayOfCountry[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = myMainVC  {
             
            vc.source = arrayOfCountry[indexPath.item].lowercased()
            vc.fetchArticles(fromSource: arrayOfCountry[indexPath.item].lowercased())
            dismissCountryMenu()
            
        }
    }
    
    override init() {
        super.init()
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
         
        countryTableView.isScrollEnabled = false
        countryTableView.bounces = false
        
        countryTableView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellid")
        
    }
    
    
}
