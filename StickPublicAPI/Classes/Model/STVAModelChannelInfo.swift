//
//  STVAModelChannelInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/25/18.
//
import UIKit

public class STVAModelChannelInfo: NSObject {
    public private(set) var ch_idx: String!
    public private(set) var thumbnail: String!
    public private(set) var title: String!
    public private(set) var type: String!
    @objc public private(set) var meta:Dictionary<String, Any> = [:]
    
    public init(jsonData: Any?) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, Any> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        guard let ch_idx = dictionary["ch_idx"] as? String,
            let thumbnail = dictionary["thumbnail"] as? String,
            let title = dictionary["title"] as? String,
            let type = dictionary["type"] as? String else {
                throw ParsingError.InvalidResult(reason: "no title or url")
        }
        self.ch_idx = ch_idx
        self.thumbnail = thumbnail
        self.title = title
        self.type = type
        
        if let dicMeta = dictionary["meta"] as? Dictionary<String, Any> {
            for (key, data) in dicMeta {
                meta[key] = data
            }
        }
        
        
        
        
    }
}
