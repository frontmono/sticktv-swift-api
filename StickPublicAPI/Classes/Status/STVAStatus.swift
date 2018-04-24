//
//  STVAStatus.swift
//  Pods-StickTVMaster-SWF
//
//  Created by Hak Kim on 4/21/18.
//

import UIKit
import HSCryptoUtil


public class STVAStatus: NSObject {
    
    let saveAESKEY = "686A69918F22F4479D8DEA6E45587360"
    let saveAESIV = "3816227195CEBE78D5700E30319773BD"
    
    
    public private(set) var accessToken:String?
    
    private private(set) var serviceName:String?
    private private(set) var serviceKey:String?
    
    
    public var userIdx:String?
    public var userEmail:String?
    public var groupIdx:String?
    
    static var shared:STVAStatus!
    
    @objc public static func Ins() -> STVAStatus {
        if(shared == nil){
            shared = STVAStatus();
        }
        return shared;
    }
    override init() {
        super.init()
        dataLoad()
    }
    
    public func isUserLogined() -> Bool {
        if self.userEmail != nil && self.userIdx != nil {
            return true;
        }
        return false
    }
    private func dataSave() -> Void{
        if self.accessToken != nil && self.serviceName != nil && self.serviceKey != nil {
            var dicInfo: Dictionary<String, String> = [:]
            dicInfo["token"] = self.accessToken
            dicInfo["srvName"] = self.serviceName
            dicInfo["srvKey"] = self.serviceKey
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: dicInfo, options: JSONSerialization.WritingOptions(rawValue: 0))
                let jsonString = String.init(data: jsonData, encoding: .utf8)
                let aes128 = HSAES128CFBNode()
                let cryptText = aes128.testCryptoCFB8(withKey: saveAESKEY, ivHex: saveAESIV, text: jsonString, isEncrypt: true)
                let defaults = UserDefaults.standard
                defaults.set(cryptText, forKey: "lib.stick.api.swift")
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
    }
    private func dataLoad() -> Void{
        
        do{
            let defaults = UserDefaults.standard
            if let cryptText = defaults.string(forKey: "lib.stick.api.swift") {
                let aes128 = HSAES128CFBNode()
                let jsonString = aes128.testCryptoCFB8(withKey: saveAESKEY, ivHex: saveAESIV, text: cryptText, isEncrypt: false)
                let data =  jsonString?.data(using: .utf8)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                    if let token = jsonResult["token"] as? String
                        , let srvName = jsonResult["srvName"] as? String
                        , let srvKey = jsonResult["srvKey"] as? String{
                        self.accessToken = token
                        self.serviceName = srvName
                        self.serviceKey = srvKey
                        
                    }
                    
                }
            }
            
        }catch{
            debugPrint(error.localizedDescription)
        }
        
        
       
        
    }
    private func getAccessToken(serviceName: String, serviceKey: String, prevToken:String?, completionHandler: @escaping (String?, Error?) -> Swift.Void){
        if let token = prevToken {
            STVAHttpRequest.requestAPI(URL: STVAURL.Ins().urlAccountStatus, isGET: true, dicParams:[STVASTR.SSID.rawValue: token]) { (result: STVACallResult) in
                if result.error != nil {
                    completionHandler(nil, result.error)
                }else{
                    if let dicResult = result.data as? Dictionary<String, Any> {
                        if let token = dicResult["token"] as? String,
                            let dicSession = dicResult["info"] as? Dictionary<String, Any>,
                            let prefix = dicSession["prefix"] as? String{
                            
                            if prefix != serviceName {
                                completionHandler(nil, NSError(domain: "service name is not defined ", code: 0, userInfo: nil))
                            }else{
                                self.userIdx = dicSession["usr_idx"] as? String
                                self.userEmail = dicSession["usr_email"] as? String
                                self.groupIdx = dicSession["gr_idx"] as? String
                                
                                completionHandler(token, nil)
                            }
                            
                            
                        }else{
                            completionHandler(nil, NSError(domain: "Invalid result format", code: 0, userInfo: nil))
                        }
                    }else{
                        completionHandler(nil, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                    }
                    
                }
            }//STVAHttpRequest.requestAPI
        }else{
            STVAHttpRequest.requestAPI(URL: STVAURL.Ins().urlAccountServiceLogin, isGET: true, dicParams: [STVASTR.name.rawValue:serviceName, STVASTR.key.rawValue:serviceKey]) { (result: STVACallResult) in
                if result.error != nil {
                    completionHandler(nil, result.error)
                }else{
                    if let dicResult = result.data as? Dictionary<String, String> {
                        if let token = dicResult["token"] {
                            completionHandler(token, nil)
                        }
                    }else{
                        completionHandler(nil, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                    }
                    
                }
            }//STVAHttpRequest.requestAPI
        }//  if prevToken != nil {
    }
    //Make sure ony one time
    public func Init(serviceName: String, serviceKey: String, completionHandler: @escaping (String?, Error?) -> Swift.Void){
        
        if serviceName == self.serviceName && serviceKey == self.serviceKey {
            
        }else{
            //If different, just set access token as nil
            self.accessToken = nil
        }
        let prevToken = self.accessToken
        //make sure after call access token is null
        self.accessToken = nil
            
        self.getAccessToken(serviceName: serviceName, serviceKey: serviceKey, prevToken: prevToken) { (token: String?, error: Error?) in
            if token != nil {
                self.accessToken = token
                self.serviceName = serviceName
                self.serviceKey = serviceKey
                self.dataSave()
                completionHandler(token, error)
            }else{
                if prevToken != nil {
                    //retry one more time
                    self.getAccessToken(serviceName: serviceName, serviceKey: serviceKey, prevToken:nil, completionHandler: { (token, error) in
                        if token != nil {
                            self.accessToken = token
                            self.serviceName = serviceName
                            self.serviceKey = serviceKey
                            self.dataSave()
                        }
                        completionHandler(token, error)
                    })
                }else{
                    completionHandler(token, error)
                }
            }
            
        }
        
        
 
    }
}
