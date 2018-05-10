//
//  STVAModelUploadInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/8/18.
//

import UIKit

public class STVAModelUploadInfo: NSObject {
    public private(set) var dataURL: String!
    public private(set) var size: String!
    public private(set) var thumbURL: String?
    public private(set) var keyInfo: String!
    
    public init(jsonData: Any?) throws {
        super.init()
        guard let dictionary = jsonData as? Dictionary<String, String> else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        guard let dataURL = dictionary["url"],
            let keyInfo = dictionary["key"],
            let size = dictionary["amount"] else{
                throw ParsingError.NoItem(itemname: "url size etc")
        }
        self.dataURL  = dataURL
        self.keyInfo = keyInfo
        self.size = size
        self.thumbURL = dictionary["thumb"]
       
        
    }
}
