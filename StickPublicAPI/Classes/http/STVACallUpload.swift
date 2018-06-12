//
//  STVACallUpload.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/7/18.
//

import UIKit


public class STVACallUpload : NSObject {
    @objc  public static func uploadDumy(filename: String,
                                         fileData: Data,
                                         mimeType: String,
                                         type: String,
                                         completionHandler: @escaping (STVAModelUploadInfo?, Error?) -> Swift.Void) {
        let dicFile = ["filename": filename, "mimetype":mimeType, "data":fileData] as [String : Any]
        let dicParam = [STVASTR.type.rawValue:type]
        
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlUploadDumyFile, isGET: false, dicParams: dicParam, dicData: ["file":dicFile]) { (result) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                do{
                    let info = try STVAModelUploadInfo(jsonData: result.data)
                    completionHandler(info, nil)
                }catch{
                    debugPrint(error.localizedDescription)
                    completionHandler(nil, error)
                }
                
            }
            
        }
    }
    @objc  public static func imageUploadAndUpdate(imageData: Data,
                                          type: String,
                                          target: String,
                                         completionHandler: @escaping (String?, Error?) -> Swift.Void) {
        uploadDumy(filename: "image.png", fileData: imageData, mimeType: "image/jpeg", type: STVASTR.image.rawValue) { (uploadInfo, err) in
            if let uploadInfo = uploadInfo {
                imageUpdate(type: type, target: target, key: uploadInfo.keyInfo, completionHandler: completionHandler)
            }else{
                completionHandler(nil, err)
            }
        }
    }
    @objc  public static func imageUpdate(type: String,
                                         target: String,
                                         key: String,
                                         completionHandler: @escaping (String?, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.type.rawValue] = type
        dicParam[STVASTR.target.rawValue] = target
        dicParam[STVASTR.key.rawValue] = key
        
        
        
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlUpdateImage, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> ,
                    let url = dicResult["url"]{
                    completionHandler(url, nil);
                }else{
                    completionHandler(nil, NSError(domain: "no url in result", code: 0, userInfo: nil))
                }
            }
            
        }//STVAHttpRequest.requestAPI
    }
    @objc  public static func addContent(title: String?,
                                         desc: String?,
                                         type: String,
                                         attach_ext: String,
                                         gr_idx: String?,
                                         extra: String?,
                                         completionHandler: @escaping (String?, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.type.rawValue] = type
        dicParam[STVASTR.attachExt.rawValue] = attach_ext
        if let title = title {dicParam[STVASTR.title.rawValue] = title}
        if let desc = desc {dicParam[STVASTR.desc.rawValue] = desc}
        if let extra = extra {dicParam[STVASTR.extra.rawValue] = extra}
        if let gr_idx = gr_idx {dicParam[STVASTR.gr_idx.rawValue] = gr_idx}
        
        
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlUploadAddContent, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> ,
                    let cid = dicResult["cid"]{
                    completionHandler(cid, nil);
                }else{
                    completionHandler(nil, NSError(domain: "no cid in result", code: 0, userInfo: nil))
                }
            }
            
        }//STVAHttpRequest.requestAPI
    }
    @objc  public static func importContent(ukey: String, gr_idx: String,
                                         completionHandler: @escaping (String?, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.gr_idx.rawValue] = gr_idx
        dicParam[STVASTR.ukey.rawValue] = ukey
        
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlUpdateSoicalContent, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, String> ,
                    let cid = dicResult["cid"]{
                    completionHandler(cid, nil);
                }else{
                    completionHandler(nil, NSError(domain: "no cid in result", code: 0, userInfo: nil))
                }
            }
            
        }//STVAHttpRequest.requestAPI
    }
    
}

