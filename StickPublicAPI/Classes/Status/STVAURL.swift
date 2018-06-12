//
//  STVAURL.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 4/23/18.
//

import UIKit
public enum STVASTR :String {
    case all, attachExt, audio
    case caInfo, category, ch_idx, cid, comment, count
    case desc, dummy
    case email, extra
    case filter
    case gr_idx, group
    case image
    case joined
    case key
    case musicfolio // music folio
    case name, nextToken, nickname, normal
    case own
    case page, pass
    case range
    case search, sing, SSID
    case talk, target, text, title, token, type
    case uid, ukey, user, user_idx
    case video
    case YouTube
    
    
    
    
}
public class STVAURL: NSObject {
    public enum RELEASE_TYPE {
        case LOCAL
        case DEV
        case RELEASE
    }

    
    
    static var shared:STVAURL!
    
    static public private(set) var isDeveloping = false
    public private(set) var releaseType: RELEASE_TYPE!
    public private(set) var domainAPI: String!
    public private(set) var domainApp: String!
    public private(set) var domainImageCache: String!
    public private(set) var urlAccountServiceLogin:String!
    public private(set) var urlAccountStatus:String!
    public private(set) var urlAccountUserFBLogin:String!
    public private(set) var urlAccountUserKakaoLogin:String!
    public private(set) var urlAccountUserLogin:String!
    public private(set) var urlAccountUserLogout:String!
    public private(set) var urlAccountUserInfo:String!
    public private(set) var urlAccountUserJoin:String!
    
    public private(set) var urlListContentSNS:String!
    public private(set) var urlListGroupJoined:String!
    public private(set) var urlListContentHome:String!
    public private(set) var urlListGroupCategoryChannel:String!
    
    
    public private(set) var urlCommentList:String!
    public private(set) var urlCommentAdd:String!
    public private(set) var urlCommentRemove:String!
    public private(set) var urlLikeAction:String!
    
    
    public private(set) var urlUploadAddContent:String!
    public private(set) var urlUploadDumyFile:String!
    public private(set) var urlUpdateImage:String!
    public private(set) var urlUpdateSoicalContent:String!
    
    public private(set) var urlSampleAdPoster:String!
    
    public private(set) var appMakeFandom:String!
    
    @objc public static func Ins() -> STVAURL {
        if(shared == nil){
            shared = STVAURL(type: .LOCAL);
            //shared = STVAURL(type: .DEV);
        }
        return shared;
    }
    
    private init(type: RELEASE_TYPE){
        self.releaseType = type
        let localIP = "192.168.106.109"
        
        switch type {
        case .DEV:
            self.domainApp = "http://developer.stick.tv/app/?api=dev"
            self.domainAPI = "https://dev.api.stick.tv:8301"
            self.domainImageCache = "https://dev.images.stick.tv:9091/img/"
        case .LOCAL:
            STVAURL.isDeveloping = true
            //self.domainAPI = "http://localhost:8300"
            self.domainAPI = "http://" + localIP + ":8300"
            self.domainImageCache = "https://dev.images.stick.tv:9091/img/"
            self.domainApp = "http://" + localIP + ":3000/?api=local"
            
        case .RELEASE:
            self.domainAPI = "https://api.wetribe.io"
            self.domainImageCache = "https://images.stick.tv/img/"
            self.domainApp = "http://developer.stick.tv/app/?api=rel"
        }
        self.urlAccountServiceLogin = self.domainAPI + "/1.0.0/account/serviceLogin"
        self.urlAccountStatus = self.domainAPI + "/1.0.0/account/status"
        self.urlAccountUserLogin = self.domainAPI + "/1.0.0/account/userLogin"
        self.urlAccountUserLogout = self.domainAPI + "/1.0.0/account/userLogout"
        self.urlAccountUserInfo = self.domainAPI + "/1.0.0/account/userInfo"
        self.urlAccountUserJoin = self.domainAPI + "/1.0.0/account/userJoin"
        self.urlAccountUserFBLogin = self.domainAPI + "/1.0.0/account/loginFacebook"
        self.urlAccountUserKakaoLogin = self.domainAPI + "/1.0.0/account/loginKakao"
        
        
        self.urlListContentSNS = self.domainAPI + "/1.0.0/list/content/sns"
        self.urlListContentHome = self.domainAPI + "/1.0.0/list/content/home"
        self.urlListGroupJoined = self.domainAPI + "/1.0.0/list/group"
        self.urlListGroupCategoryChannel = self.domainAPI + "/1.0.0/list/channel/groupCategory"
        
        self.urlUploadAddContent = self.domainAPI + "/1.0.0/upload/addContent"
        self.urlUploadDumyFile = self.domainAPI + "/1.0.0/upload/file"
        self.urlUpdateImage = self.domainAPI + "/1.0.0/update/image"
        self.urlUpdateSoicalContent = self.domainAPI + "/1.0.0/upload/importSocial"
        
        
        self.urlCommentList = self.domainAPI + "/1.0.0/comment/list"
        self.urlCommentAdd = self.domainAPI + "/1.0.0/comment/add"
        self.urlCommentRemove = self.domainAPI + "/1.0.0/comment/remove"
        
        self.urlLikeAction = self.domainAPI + "/1.0.0/like/action"
        
        
        
        self.urlSampleAdPoster = self.domainAPI + "/1.0.0/sample/poster"
        
        
        
        
        
        self.appMakeFandom = self.domainApp + "&page=makeAppWeGroup"
        
        
        
    }
    
}
