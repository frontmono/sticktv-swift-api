//
//  STVAString.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/2/18.
//

import UIKit

public class URLParseResult: NSObject {
    
    public private(set) var schema: String?
    public private(set) var host: String?
    public private(set) var param: Dictionary<String, String> = [:]
    
    public init(url: String) throws {
        super.init()
        var arrAll = url.components(separatedBy: "?")
        
        if arrAll.count > 0 {
            let strHostSchema = arrAll[0]
            var arrSchema = strHostSchema.components(separatedBy: "://")
            if arrSchema.count > 1 {
                self.schema = arrSchema[0]
                self.host = arrSchema[1]
            }else{
                self.host = arrSchema[0]
            }
        }
        if arrAll.count > 1{
            let arrParam = arrAll[1].components(separatedBy: "&")
            for element in arrParam {
                let arrEle = element.components(separatedBy: "=")
                if arrEle.count == 2 {
                    self.param[arrEle[0]] = arrEle[1]
                    
                }
            }
        }
        
    }
}
public extension String{
    func parseURL() -> URLParseResult? {
        do{
            let info = try URLParseResult(url: self)
            return info
        }catch{
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func parseDemention() -> CGSize? {
        var arrAll = self.components(separatedBy: "x")
        if(arrAll.count == 2){
            if let w = Int(arrAll[0]), let h = Int(arrAll[1]) {
                return CGSize(width: w, height: h)
            }
        }
        return nil
    }
}
