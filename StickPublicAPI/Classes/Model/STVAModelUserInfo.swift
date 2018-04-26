//
//  STVAUserInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 4/23/18.
//

import UIKit


public class STVAModelUserInfo: NSObject {
    
    
    
    @objc public private(set) var user_idx:String?
    @objc public private(set) var nickname:String?
    @objc public private(set) var desc:String?
    @objc public private(set) var thumb_url:String?
    
    
    
    
    
    public init(jsonData: Any?) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, Any> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        self.user_idx = dictionary["usr_idx"] as? String
        self.nickname = dictionary["nickname"] as? String
        self.desc = dictionary["desc"] as? String
        self.thumb_url = dictionary["thumbnail"] as? String
        
        
    
    }
    deinit {
        debugPrint("deinited")
    }
}
