//
//  STVAModelSNSContentInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/2/18.
//

import UIKit

@objc public  enum ContentType_ :Int {
    case Unknown
    case YouTube
    case Uploaded
}
public class STVAModelContentInfo: NSObject {
    @objc public private(set) var cid: String?
    @objc public private(set) var uKey: String!
    @objc public private(set) var title: String?
    @objc public private(set) var desc: String?
    @objc public private(set) var thumbnail: String?
    @objc public private(set) var type:ContentType_ = .Unknown
    @objc public var meta:Dictionary<String, Any> = [:]
    
    public init(jsonData: Any?, type:ContentType_) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, Any> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        guard let uniqueKey = dictionary["ukey"] as? String else {
            throw ParsingError.InvalidResult(reason: "no unique key")
        }
        self.uKey = uniqueKey
        self.cid = dictionary["cid"] as? String
        self.title = dictionary["title"] as? String
        self.desc = dictionary["description"] as? String
        self.thumbnail = dictionary["thumbnail"] as? String
        self.type = type
        
        if let dicMeta = dictionary["meta"] as? Dictionary<String, Any> {
            for (key, data) in dicMeta {
                meta[key] = data
            }
        }
        
        
        
        
    }
}
