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
                    }else{
                        completionHandler(NSError(domain: "no user idx and email", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler( NSError(domain: "data is not dic format", code: 0, userInfo: nil))
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
