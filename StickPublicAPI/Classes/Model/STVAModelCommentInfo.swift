//
//  STVAModelCommentInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 6/5/18.
//

import UIKit

public class STVAModelCommentInfo: NSObject {
    
    @objc public var idx:String!
    @objc public var comment:String!
    @objc public var user_idx:String!
    @objc public var user_thumb:String!
    @objc public var user_nickname:String!
    
    
    public override init() {
        super.init()
        
        self.idx = ""
        self.comment = ""
        self.user_idx = ""
        self.user_thumb = ""
        self.user_nickname = ""
        
        
        
    }
    
    public init(jsonData: Any?) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, Any> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        self.idx = dictionary["idx"] as! String
        self.comment = dictionary["comment"] as! String
        let dicUser = dictionary["user"] as! Dictionary<String, String>
        self.user_idx = dicUser["idx"]
        self.user_thumb = dicUser["thumb"]
        self.user_nickname = dicUser["nickname"]
        
        
        
    }
}
