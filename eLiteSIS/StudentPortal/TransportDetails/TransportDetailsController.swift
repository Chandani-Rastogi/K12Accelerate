//
//  TransportDetailsController.swift
//  eLiteSIS
//
//  Created by Apar256 on 20/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit
import Foundation

class TransportDetailsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var transportRouteDetail: TransportResponseRootClass? = nil
    @IBOutlet weak var transportDetailTableView: UITableView!
    @IBOutlet weak var stopList: UITableView!
    var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width:self.view.frame.width, height: self.view.frame.height + 1400)
      //  self.transportDetailTableView.frame = CGRect(x:0, y: 10, width: self.view.frame.size.width, height:750)
        self.transportDetailTableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        self.transportDetailTableView.separatorStyle = .none
        self.transportDetailTableView.bounces = true
        self.transportDetailTableView.delegate = nil
        self.transportDetailTableView.dataSource = nil
        
        self.stopList.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
               self.stopList.separatorStyle = .none
               self.stopList.bounces = true
               self.stopList.delegate = nil
               self.stopList.dataSource = nil
        self.getTransportDetail()
    }

    // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == transportDetailTableView {
           return 1
        }
        if tableView == stopList {
            return ((self.transportRouteDetail?.stopList.count)! - 1)
        }
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == transportDetailTableView{
          return 850
        }
        
        if tableView == stopList{
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == transportDetailTableView {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransportTableViewCell") as! TransportTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.vehicleNumberLabel.text = transportRouteDetail?.transportDetail.vehicalNo
            cell.stopNameLabel.text = transportRouteDetail?.transportDetail.stopageName
            cell.vehicleTypeLabel.text = transportRouteDetail?.transportDetail.vehicalType
            cell.routeNoLabel.text = transportRouteDetail?.transportDetail.routeName
            cell.dropTimeLabel.text = transportRouteDetail?.transportDetail.dropoffTime
            cell.coordinatorNameLabel.text = transportRouteDetail?.transportDetail.inchargeName
            cell.CoMobileNoLabel.text = transportRouteDetail?.transportDetail.inchargeMobile
            cell.helperNameLabel.text = transportRouteDetail?.transportDetail.helperName
            cell.helperNoLabel.text = transportRouteDetail?.transportDetail.helperMobile
            cell.driverNameLabel.text = transportRouteDetail?.transportDetail.driverName
            cell.driverNumberLabel.text = transportRouteDetail?.transportDetail.driverMobile
            return cell
        }
        if tableView == stopList {
            var cell = tableView.dequeueReusableCell(withIdentifier: "StopRouteTableViewCell") as! StopRouteTableViewCell
           // cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.routeNme.text = transportRouteDetail?.stopList[indexPath.row].stopName
            if transportRouteDetail?.transportDetail.stopageName == transportRouteDetail?.stopList[indexPath.row].stopName
            {
                index = indexPath.row
                print(indexPath.row)
                cell.routeImage.image = #imageLiteral(resourceName: "Ellipse 125")
                cell.routeNme.textColor = .red
            }
            else if indexPath.row > index {
                 cell.routeImage.image = #imageLiteral(resourceName: "Path 1116")
                cell.routeImage.setImageColor(color: UIColor.lightGray)
                cell.routeNme.textColor = .lightGray
            }
                //else if
            else {
              cell.routeImage.image = #imageLiteral(resourceName: "Path 1116")
              cell.routeNme.textColor = .black
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func getTransportDetail() {
        ProgressLoader.shared.showLoader(withText: "Loadingg Transport Details .....")
        WebService.shared.GetTransportDetail(studentID:(UserDefaults.standard.object(forKey:"userID") as? String)!, completion:{(response, error) in
            if error == nil , let responseDict = response {
                self.transportRouteDetail = responseDict
                if self.transportRouteDetail != nil {
                    Singleton.setUpTableViewDisplay(self.transportDetailTableView, headerView: "", "TransportTableViewCell")
                    self.transportDetailTableView.delegate = self
                    self.transportDetailTableView.dataSource = self
                    
                    Singleton.setUpTableViewDisplay(self.stopList, headerView: "", "StopRouteTableViewCell")
                    self.stopList.delegate = self
                    self.stopList.dataSource = self
                }
                ProgressLoader.shared.hideLoader()
            }
            else{
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: "Error!", message: "Somthing went wrong")
                debugPrint(error?.localizedDescription ?? "Invalid User")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
