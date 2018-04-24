//
//  STVAURL.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 4/23/18.
//

import UIKit
public enum STVASTR :String {
    case name
    case key
    case uid
    case pass
    case SSID
    
}
public class STVAURL: NSObject {
    public enum RELEASE_TYPE {
        case LOCAL
        case DEV
        case RELEASE
    }

    
    
    static var shared:STVAURL!
    
    
    public private(set) var releaseType: RELEASE_TYPE!
    public private(set) var domainAPI: String!
    
    public private(set) var urlAccountServiceLogin:String!
    public private(set) var urlAccountStatus:String!
    public private(set) var urlAccountUserLogin:String!
    
    
    @objc public static func Ins() -> STVAURL {
        if(shared == nil){
            shared = STVAURL(type: .LOCAL);
        }
        return shared;
    }
    
    private init(type: RELEASE_TYPE){
        self.releaseType = type
        
        switch type {
        case .DEV:
            self.domainAPI = "https://dev.api.wetribe.io"
        case .LOCAL:
            self.domainAPI = "http://localhost:8300"
        case .RELEASE:
            self.domainAPI = "https://api.wetribe.io"
        }
        self.urlAccountServiceLogin = self.domainAPI + "/1.0.0/account/serviceLogin"
        self.urlAccountStatus = self.domainAPI + "/1.0.0/account/status"
        self.urlAccountUserLogin = self.domainAPI + "/1.0.0/account/userLogin"
        
    }
    
}
