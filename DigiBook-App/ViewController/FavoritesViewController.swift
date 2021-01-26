//
//  FavoritesViewController.swift
//  DigiBook-App
//
//  Created by 123 on 12/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Photos
import LazyImage


class FavoritesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var data:JSON?
    var arrayformat = [JSON]()
    
    @IBOutlet var fav_table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayformat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let contentview = cell?.contentView
        
        let notifimage = contentview?.viewWithTag(1) as! LazyImageView
        let labelname = contentview?.viewWithTag(2) as! UILabel
        let labelaction = contentview?.viewWithTag(3) as! UILabel
        
        let labelfav = contentview?.viewWithTag(10) as! UILabel
        let butfav = contentview?.viewWithTag(11) as! UIButton
        let labellike = contentview?.viewWithTag(12) as! UILabel
        let butlike = contentview?.viewWithTag(13) as! UIButton
        
        labelname.text = arrayformat[indexPath.row]["bookname"].stringValue
        labelaction.text = arrayformat[indexPath.row]["bookauthor"].stringValue
        notifimage.imageURL = arrayformat[indexPath.row]["bookcover"].stringValue
        labelfav.text = String(arrayformat[indexPath.row]["favlist"].array!.count)
        labelfav.textColor = UIColor.red
        butfav.tintColor = UIColor.red
        labellike.text = String(arrayformat[indexPath.row]["upvotelist"].array!.count)
        labellike.textColor = UIColor.blue
        butlike.tintColor = UIColor.blue
        //print(arrayformat[indexPath.row]["name"].stringValue)

              return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myapiurl = "http://127.0.0.1:6000/api/user/profile/allfavbooks/"+LoginViewController.currentUserEmail
        AF.request(myapiurl, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data: myresponse.data!)
                
                let resultArray = myresult!
                self.arrayformat = resultArray.array!
                self.data = resultArray
                //print(self.arrayformat)
                self.fav_table.reloadData()
                //print(self.data!)


                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }
        
    }
    



}
