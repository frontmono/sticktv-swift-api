//
//  STVAUserInfo.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 4/23/18.
//

import UIKit


public class STVAUserInfo: NSObject {
    
    @objc public enum TRIBE_STATUS_ : Int {
        case JOINED = 1 // tribe에 join한 경우
        case NONE = 2 // tribe와 상관 없는 경우
        case STANDBY = 3 // 대기를 기다리는 경우
    }

    
    
    @objc public class Giving: NSObject {
        @objc public private(set) var nextFreeEarn: Int = 0
        @objc public private(set) var pointPuchased: Int = 0
        @objc public private(set) var pointEarn: Int = 0
        public init(jsonData: Dictionary<String, String>?) throws {
            super.init()
            guard let dictionary = jsonData else {
                throw ParsingError.NoItem(itemname: "dictionary")
            }
            if let str = dictionary["next_point"], let iVaue = Int(str) {
                self.nextFreeEarn = iVaue
            }
            if let str = dictionary["member_point"], let iVaue = Int(str) {
                self.pointPuchased = iVaue
            }
            if let str = dictionary["earned_point"], let iVaue = Int(str) {
                self.pointEarn = iVaue
            }
            
        }
    }
    
    
    @objc public private(set) var user_idx:Int = 0
    @objc public private(set) var thumbnail:String?
    @objc public private(set) var sessionKey:String? //only available to logined user only
    @objc public private(set) var tribeStatus: TRIBE_STATUS_ = .NONE
    @objc public private(set) var tribeStatusStr: String! = "D"
    @objc public private(set) var giving:Giving?
    
    
    
    public init(jsonData: Dictionary<String, Any>?) throws {
        super.init()
        guard let dictionary = jsonData else {
            throw ParsingError.NoItem(itemname: "dictionary")
        }
        if let str = dictionary["usr_idx"] as? String, let iVaue = Int(str) {
            self.user_idx = iVaue
        }else{
            throw ParsingError.NoItem(itemname: "usr_idx")
        }
        
        if let thumb = dictionary["thumbnail"] as? String {
            self.thumbnail = thumb
        }else{
            throw ParsingError.NoItem(itemname: "thumbnail")
        }
        if let status = dictionary["tribe_status"] as? String {
            self.tribeStatusStr = status
            if status == "A" {
                self.tribeStatus = .JOINED
            }else if status == "S" {
                self.tribeStatus = .STANDBY
            }
        }
        
        self.sessionKey = dictionary["skey"] as? String
        
        if let dicGiving = dictionary["giving"] as? Dictionary<String, String> {
            do{
                self.giving = try Giving(jsonData: dicGiving)
            }
        }
    
    }
}
