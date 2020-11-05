//
//  DetailRoomViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/17.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class DetailRoomViewController: UIViewController {

    
    @IBOutlet var imgBoard1: UIImageView!
    @IBOutlet var imgBoard2: UIImageView!
    @IBOutlet var imgBoard3: UIImageView!
    @IBOutlet var txtTitle: UILabel!
    @IBOutlet var txtLocation: UILabel!
    @IBOutlet var txtTotal: UILabel!
    @IBOutlet var txtTag: UILabel!
    
    
    
    
    var boardIdx:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self.boardIdx)")

        let url = Config.baseURL + "/api/boards/\(self.boardIdx!)"
        
        AF.request(url, method: .get,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(DetailBoardParsing.self, from: data)
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img1)!)
                            self.imgBoard1.image = UIImage(data: data)
                        }
                        catch{
                            self.imgBoard1.image = nil
                        }
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img2)!)
                            self.imgBoard2.image = UIImage(data: data)
                        }
                        catch{
                            self.imgBoard2.image = nil
                        }
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img3)!)
                            self.imgBoard3.image = UIImage(data: data)
                        }
                        catch{
                            self.imgBoard3.image = nil
                        }
                
                        self.txtTitle.text = jsonParsing.title
                        self.txtLocation.text = jsonParsing.location
                        self.txtTag.text = "#\(jsonParsing.tag1) #\(jsonParsing.tag2) #\(jsonParsing.tag3)"
                        self.txtTotal.text = jsonParsing.numType
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
                
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        let ud = UserDefaults.standard
        ud.set("false", forKey: "isClickedFilterButton")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRequestMeeting(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
