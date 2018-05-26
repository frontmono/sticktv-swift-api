//
//  STVAModelGroupInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/7/18.
//

import UIKit
public protocol GroupOperationProtocol : AnyObject{
    func onGroupInfoSelected(groupInfo: STVAModelGroupInfo)
    
}
public class STVAModelGroupInfo: NSObject , NSCoding{
    
    
    public enum JoinStatus : Int {
        case none, owner, joind, waiting
    }
    
    @objc public private(set) var idx:String!
    @objc public private(set) var name:String!
    @objc public private(set) var disp_name:String?
    @objc public private(set) var thumbnail:String?
    @objc public private(set) var category:String?
    @objc public private(set) var owner_userIdx:String?
    @objc public private(set) var owner_nickname:String?
    @objc public private(set) var cntHeart:String?
    @objc public private(set) var cntMember:String?
    public private(set) var joinStatus:JoinStatus = .none
    
    
    public init(jsonData: Any?) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, Any> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        self.idx = dictionary["gr_idx"] as! String
        self.name = dictionary["gr_nm"] as! String
        self.disp_name = dictionary["disp_name"] as? String
        self.thumbnail = dictionary["logo"] as? String
        self.category = dictionary["category"] as? String
        if let dicOwner = dictionary["owner"] as? Dictionary<String, String> {
            self.owner_userIdx = dicOwner["user_idx"]
            self.owner_nickname = dicOwner["nickname"]
        }
        if let dicCount = dictionary["count"] as? Dictionary<String, String> {
            self.cntHeart = dicCount["heart"]
            self.cntMember = dicCount["member"]
        }
        
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.idx = aDecoder.decodeObject(forKey: "idx") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.disp_name = aDecoder.decodeObject(forKey: "disp_name") as? String
        self.thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String
        
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.idx, forKey: "idx")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.disp_name, forKey: "disp_name")
        aCoder.encode(self.thumbnail, forKey: "thumbnail")
    }
    
    
    
    
    deinit {
        debugPrint("deinited")
    }
}
