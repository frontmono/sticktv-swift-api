//
//  STVAPosterAddInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/22/18.
//

import UIKit

public class STVAPosterAddInfo: NSObject {
    public private(set) var title: String!
    public private(set) var url: String!
    public private(set) var type: String?
    @objc public private(set) var meta:Dictionary<String, Any> = [:]
    
    public init(jsonData: Any?) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, Any> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        guard let title = dictionary["title"] as? String,
               let url = dictionary["url"] as? String else {
            throw ParsingError.InvalidResult(reason: "no title or url")
        }
        self.title = title
        self.url = url
        self.type = dictionary["type"] as? String
    
        if let dicMeta = dictionary["meta"] as? Dictionary<String, Any> {
            for (key, data) in dicMeta {
                meta[key] = data
            }
        }
        
        
        
        
    }
}
