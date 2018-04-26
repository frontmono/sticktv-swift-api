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
    case nickname
    case email
    case uid
    case user_idx
    case pass
    case SSID
    case token
    
    
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
    public private(set) var domainImageCache: String!
    public private(set) var urlAccountServiceLogin:String!
    public private(set) var urlAccountStatus:String!
    public private(set) var urlAccountUserFBLogin:String!
    public private(set) var urlAccountUserLogin:String!
    public private(set) var urlAccountUserLogout:String!
    public private(set) var urlAccountUserInfo:String!
    public private(set) var urlAccountUserJoin:String!
    
    
    @objc public static func Ins() -> STVAURL {
        if(shared == nil){
            //shared = STVAURL(type: .LOCAL);
            shared = STVAURL(type: .DEV);
        }
        return shared;
    }
    
    private init(type: RELEASE_TYPE){
        self.releaseType = type
        
        switch type {
        case .DEV:
            self.domainAPI = "https://dev.api.stick.tv:8301"
            self.domainImageCache = "https://dev.images.stick.tv:9091/img/"
        case .LOCAL:
            //self.domainAPI = "http://localhost:8300"
            self.domainAPI = "http://192.168.106.101:8300"
            self.domainImageCache = "https://dev.images.stick.tv:9091/img/"
        case .RELEASE:
            self.domainAPI = "https://api.wetribe.io"
            self.domainImageCache = "https://images.stick.tv/img/"
        }
        self.urlAccountServiceLogin = self.domainAPI + "/1.0.0/account/serviceLogin"
        self.urlAccountStatus = self.domainAPI + "/1.0.0/account/status"
        self.urlAccountUserLogin = self.domainAPI + "/1.0.0/account/userLogin"
        self.urlAccountUserLogout = self.domainAPI + "/1.0.0/account/userLogout"
        self.urlAccountUserInfo = self.domainAPI + "/1.0.0/account/userInfo"
        self.urlAccountUserJoin = self.domainAPI + "/1.0.0/account/userJoin"
        self.urlAccountUserFBLogin = self.domainAPI + "/1.0.0/account/loginFacebook"
        
    }
    
}
