//
//  NotificationViewController.swift
//  DigiBook-App
//
//  Created by 123 on 03/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import Photos
import LazyImage

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data:JSON?
    var arrayformat = [JSON]()
    
    
    @IBOutlet var table_notif: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayformat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let contentview = cell?.contentView
        
        let notifimage = contentview?.viewWithTag(10) as! LazyImageView
        let labelname = contentview?.viewWithTag(11) as! UILabel
        let labelaction = contentview?.viewWithTag(12) as! UILabel
        
        labelname.text = arrayformat[indexPath.row]["name"].stringValue
        labelaction.text = arrayformat[indexPath.row]["action"].stringValue
        notifimage.imageURL = "http://127.0.0.1:6000/"+arrayformat[indexPath.row]["picurl"].stringValue
        //print(arrayformat[indexPath.row]["name"].stringValue)

              return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification"
        
        let myapiurl = "http://127.0.0.1:6000/api/user/notifications/getallnotifications/"+LoginViewController.currentUserEmail
        AF.request(myapiurl, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data: myresponse.data!)
                
                
                let resultArray = myresult!
                
                
                self.arrayformat = resultArray.array!
                self.data = resultArray
                //print(self.arrayformat[0]["name"].stringValue)
                
                self.table_notif.reloadData()
                //print(self.arrayformat)
                //print(self.data!)
                //print(self.arrayformat.count)
                


                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }

    }
    
}
