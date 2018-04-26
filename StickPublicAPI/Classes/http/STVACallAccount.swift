//
//  STVACallAcoount.swift
//  Pods-StickTVMaster-SWF
//
//  Created by Hak Kim on 4/21/18.
//

import UIKit

public class STVACallAccount: NSObject {
    
    
    @objc  public static func userLogin(userID: String, password: String, completionHandler: @escaping (Error?) -> Swift.Void) {
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlAccountUserLogin, isGET: true, dicParams: [STVASTR.uid.rawValue:userID, STVASTR.pass.rawValue:password]) { (result: STVACallResult) in
            if result.error != nil {completionHandler(result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> {
                    if let user_idx = dicResult["user_idx"],
                        let user_email = dicResult["user_email"] {
                        STVAStatus.Ins().userIdx = user_idx
                        STVAStatus.Ins().userEmail = user_email
                        completionHandler(nil)
                    }else{
                        completionHandler(NSError(domain: "no user idx and email", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler( NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                }
            }
            
        }
        
    
    }
    @objc  public static func userFacebookLogin(token: String, completionHandler: @escaping (Error?) -> Swift.Void) {
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlAccountUserFBLogin, isGET: true, dicParams: [STVASTR.token.rawValue:token]) { (result: STVACallResult) in
            if result.error != nil {completionHandler(result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> {
                    if let user_idx = dicResult["user_idx"],
                        let user_email = dicResult["user_email"] {
                        STVAStatus.Ins().userIdx = user_idx
                        STVAStatus.Ins().userEmail = user_email
                        completionHandler(nil)
                    }else{
                        completionHandler(NSError(domain: "no user idx and email", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler( NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                }
            }
            
        }
        
        
    }
    
    @objc  public static func userJoin(userID: String,
                                       password: String,
                                       nickname: String,
                                       email: String,
                                       completionHandler: @escaping (Error?) -> Swift.Void) {
        
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlAccountUserJoin, isGET: true, dicParams:[
            STVASTR.uid.rawValue:userID,
            STVASTR.pass.rawValue: password,
            STVASTR.nickname.rawValue: nickname,
            STVASTR.email.rawValue: email
        ]) { (result: STVACallResult) in
            if result.error != nil {completionHandler(result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> {
                    if let _ = dicResult["user_idx"]{
                        completionHandler(nil)
                    }else{
                        completionHandler(NSError(domain: "no user idx and email", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler( NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                }
            }
            
        }
        
        
    }
    @objc  public static func userInfo(userIDX: String, completionHandler: @escaping (STVAModelUserInfo?, Error?) -> Swift.Void) {
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlAccountUserInfo, isGET: true, dicParams: [STVASTR.user_idx.rawValue:userIDX]) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                do{
                    let userInfo = try STVAModelUserInfo(jsonData: result.data);
                    completionHandler(userInfo, nil)
                }catch{
                    completionHandler(nil, error)
                }
            }
            
        }
        
        
    }
    
    
    @objc  public static func userLogout(completionHandler: @escaping (String?,  Error?) -> Swift.Void) {
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlAccountUserLogout, isGET: true, dicParams:nil) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> {
                    if let user_idx = dicResult["user_idx"] {
                        STVAStatus.Ins().userIdx = nil
                        STVAStatus.Ins().userEmail = nil
                        completionHandler(user_idx, nil)
                    }else{
                        completionHandler(nil, NSError(domain: "no user idx and email", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler(nil, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                }
            }
            
        }
        
        
    }
    
}
