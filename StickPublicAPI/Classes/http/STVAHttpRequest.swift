//
//  STVAHttpRequest.swift
//  Pods-StickTVMaster-SWF
//
//  Created by Hak Kim on 4/21/18.
//

import UIKit

enum ParsingError: Error {
    case NoItem(itemname: String)
    case InvalidURL(reason: String)
    case InvalidResult(reason: String)
    
}




public class STVACallResult: NSObject {
    public private(set) var error:Error?
    public private(set) var data:Any?
    public init(err: Error?) {
        super.init()
        self.error = err
    }
    public init(jsonObj: Any?, err: Error?) {
        super.init()
        if err != nil {
            self.error = err
        }else{
            if let jsonResult = jsonObj as? Dictionary<String, Any> {
                guard let code = jsonResult["code"] as? String else{
                        self.error = NSError(domain: "result is not code", code: 0, userInfo: nil)
                        return
                }
                if code == "000" {
                    if let jsonData = jsonResult["data"] {
                        self.data = jsonData
                    }else{
                        self.error = NSError(domain: "result is not code/msg/data", code: 0, userInfo: nil)
                    }
                   
                }else{
                    if let msg = jsonResult["msg"] as? String,
                        let detail = jsonResult["detail"] as? String{
                        self.error = NSError(domain: code + ":" + msg + "[" + detail + "]", code: 0, userInfo: nil)
                    }else{
                        self.error = NSError(domain: code, code: 0, userInfo: nil)
                    }
                    
                }
                
                
                
            }else{
                self.error = NSError(domain: "result is result json format", code: 0, userInfo: nil)
            }
            
        }
    }
}

public class STVAHttpRequest: NSObject {
    
    @objc  public static func requestAPIAfterToken(URL url:String,
                                                   isGET: Bool,
                                                   dicParams:Dictionary<String, String>!,
                                                   completionHandler: @escaping (_ result: STVACallResult) -> Swift.Void) -> Void {
        self.requestAPIAfterToken(URL: url, isGET: isGET, dicParams: dicParams, dicData:nil, completionHandler: completionHandler)
        
        
    }
    @objc  public static func requestAPIAfterToken(URL url:String,
                                                   isGET: Bool,
                                                   dicParams:Dictionary<String, String>!,
                                                   dicData:Dictionary<String, Any>?,
                                                   completionHandler: @escaping (_ result: STVACallResult) -> Swift.Void) -> Void {
        
        func procMe(depth: Int){
            let deadlineTime = DispatchTime.now() + .seconds(1)
            if let token = STVAStatus.Ins().accessToken  {
                //let httpURL = url + "?" + STVASTR.SSID. + "=" + STVAStatus.Ins().accessToken!
                var httpURL = url
                if url.contains("?") {
                    httpURL += httpURL + "&"
                }else{
                    httpURL += "?"
                }
                httpURL += STVASTR.SSID.rawValue + "=" + token
                requestAPI(URL: httpURL, isGET: isGET, dicParams: dicParams, dicData: dicData, completionHandler: completionHandler)
                return
            }
            if(depth >= 10) {
                //no access token in 10 seconds
                let result = STVACallResult(err: NSError(domain: "no access token", code: 0, userInfo: nil))
                completionHandler(result)
                
                
                return
            }
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                procMe(depth: depth + 1)
            }
        }
        procMe(depth: 0)
        
    }
    @objc  public static func requestAPI(URL url:String,
                                         isGET: Bool,
                                         dicParams:Dictionary<String, String>!,
                                         dicData:Dictionary<String, Any>?,
                                         completionHandler: @escaping (_ result: STVACallResult) -> Swift.Void) -> Void {
        requestHTTP(URL: url, isGET: isGET, dicParams: dicParams, dicData: dicData) { (jsonObj, error) in
            DispatchQueue.main.async {
                let result = STVACallResult(jsonObj: jsonObj, err: error)
                completionHandler(result)
            }
            
        }
        
    }
    @objc  public static func requestHTTP(URL url:String,
                                          isGET: Bool,
                                          dicParams:Dictionary<String, String>!,
                                          dicData:Dictionary<String, Any>?,
                                          completionHandler: @escaping (Any?, Error?) -> Swift.Void) -> Void {
        var reqURLStr = url;
        var strParam:String!;
        if(dicParams != nil){
            for (k, v) in dicParams {
                if let urlValue=v.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    if(strParam == nil){
                        strParam = k + "=" + urlValue
                    }else{
                        strParam = strParam + "&" + k + "=" + urlValue
                    }
                }
                
            }
        }
        
        
        
        if(isGET ){
            if(url.contains("?")){
                reqURLStr += "&";
            }else{
                reqURLStr += "?"
            }
            reqURLStr += "t=" + String(NSDate().timeIntervalSince1970)
            if(strParam != nil) {
                reqURLStr += "&" + strParam
            }
            
        }
       
        if let httpURL = URL(string: reqURLStr) {
            var request = URLRequest(url: httpURL)
            if(isGET){
                request.httpMethod = "GET";
            }else{
                request.httpMethod = "POST";
                let boundary = "Boundary-\(NSUUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let body = NSMutableData();
                //if(strParam != nil){
                //    request.httpBody = strParam.data(using: .utf8)
                //}
                for (key, value) in dicParams {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
                if let dicData = dicData {
                    
                    for (key, postInfo) in dicData{
                        if let dicFileInfo = postInfo as? Dictionary<String, Any>{
                            if let filename = dicFileInfo["filename"] as? String,
                                let mimetype = dicFileInfo["mimetype"] as? String,
                                let data = dicFileInfo["data"] as? Data{
                                body.appendString(string: "--\(boundary)\r\n")
                                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                                body.append(data)
                                body.appendString(string: "\r\n")
                            }
                        }
                        
                        
                    }
                }
                body.appendString(string: "--\(boundary)\r\n")
                let data = body as Data
                request.httpBody = data
            }
            debugPrint("HTTP Request: ", httpURL )
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    completionHandler(nil, error)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    debugPrint("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(String(describing: response))")
                    let err = NSError(domain: "status code is not 200", code: httpStatus.statusCode, userInfo: ["response": String(describing: response)])
                    completionHandler(nil, err)
                    return
                    
                    
                    
                    
                }
                do{
                    debugPrint(String(data: data, encoding: .utf8) ?? "no data")
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        completionHandler(jsonResult, nil)
                    }else{
                        completionHandler(nil, NSError(domain: "Result Json Parsing Failed", code: 0, userInfo: ["response text":String(data: data, encoding: .utf8) ?? "Error Default"]))
                    }
                }catch{
                    completionHandler(nil, error)
                }
                //let responseString = String(data: data, encoding: .utf8)
                //print("responseString = \(String(describing: responseString))")
                
                
            }
            task.resume()
        }else{
            let err = NSError(domain: "URL parsing failed", code: 0, userInfo: nil)
            completionHandler(nil, err)
            return
            
        }
        
        
        
        
    } //@objc  public static func requ
}

extension NSMutableData {
    
    func appendString(string: String) {
        //let data = string.data(usingusing: NSUTF8StringEncoding, allowLossyConversion: true)
        //let data = String.da
        //append(data!)
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}


