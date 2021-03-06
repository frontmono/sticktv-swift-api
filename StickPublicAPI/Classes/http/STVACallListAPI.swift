//
//  STVACallListAPI.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 5/2/18.
//

import UIKit

public class STVACallListAPI : NSObject {
    @objc  public static func groupList(range: String,
                                        caInfo: String?,
                                        user_idx: String?,
                                        page: String?,
                                        count: String?,
                                        completionHandler: @escaping (Array<STVAModelGroupInfo>?, Int, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.range.rawValue] = range
        if let user_idx = user_idx {
            dicParam[STVASTR.user_idx.rawValue] = user_idx
        }
        if let caInfo = caInfo {
            dicParam[STVASTR.caInfo.rawValue] = caInfo
        }
        if let page = page {
            dicParam[STVASTR.page.rawValue] = page
        }
        if let count = count {
            dicParam[STVASTR.count.rawValue] = count
        }
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlListGroupJoined, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, 0, result.error)}
            else{
                do{
                    if let dicResult = result.data as? Dictionary<String, Any> {
                        if let total = dicResult["total"] as? String,
                            let items = dicResult["list"] as? Array<Any>{
                            if let cnt = Int(total) {
                                var arrContent:Array<STVAModelGroupInfo> = []
                                
                                for item in items {
                                    let ctInfo = try STVAModelGroupInfo(jsonData: item)
                                    arrContent.append(ctInfo)
                                }
                                completionHandler(arrContent, cnt, nil)
                            }else{
                                completionHandler(nil, 0, NSError(domain: "total is not int type", code: 0, userInfo: nil))
                            }
                            
                        }else{
                            completionHandler(nil, 0, NSError(domain: "data is not total, list format", code: 0, userInfo: nil))
                        }
                    }else{
                        completionHandler(nil, 0, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                    }
                    
                }catch{
                    completionHandler(nil, 0, error)
                }
            }
            
        }//STVAHttpRequest.requestAPI
        
    }
    //
    @objc  public static func contentListHome(page: String,
                                              count: String,
                                              type:String,
                                              filter: String?,
                                              gr_idx:String?,
                                              user_idx:String?,
                                              completionHandler: @escaping (Array<STVAModelContentInfo>?, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.page.rawValue] = page
        dicParam[STVASTR.count.rawValue] = count
        dicParam[STVASTR.type.rawValue] = type
        if let tmp = gr_idx {
            dicParam[STVASTR.gr_idx.rawValue] = tmp
        }
        if let tmp = filter {
            dicParam[STVASTR.filter.rawValue] = tmp
        }
        if let tmp = user_idx {
            dicParam[STVASTR.user_idx.rawValue] = tmp
        }
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlListContentHome, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                guard let arrResult = result.data as? Array<Any> else{
                    completionHandler(nil, NSError(domain: "data us not array", code: 0, userInfo: nil))
                    return
                }
                var arrContent:Array<STVAModelContentInfo> = []
                do{
                    for item in arrResult {
                        let ctInfo = try STVAModelContentInfo(jsonData: item, type: .Uploaded)
                        arrContent.append(ctInfo)
                    }
                    completionHandler(arrContent, nil)
                }catch{
                    completionHandler(nil, error)
                }
            }
        }//STVAHttpRequest.requestAPI\
    }
    @objc  public static func getSocialChannelInGroup(gr_idx:String, category:String, completionHandler: @escaping (Array<STVAModelChannelInfo>?, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.gr_idx.rawValue] = gr_idx
        dicParam[STVASTR.category.rawValue] = category
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlListGroupCategoryChannel, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                guard let arrResult = result.data as? Array<Any> else{
                    completionHandler(nil, NSError(domain: "data us not array", code: 0, userInfo: nil))
                    return
                }
                var arrContent:Array<STVAModelChannelInfo> = []
                do{
                    for item in arrResult {
                        let ctInfo = try STVAModelChannelInfo(jsonData: item)
                        arrContent.append(ctInfo)
                    }
                    completionHandler(arrContent, nil)
                }catch{
                    completionHandler(nil, error)
                }
            }
        }//STVAHttpRequest.requestAPI\
    }
    
    
    @objc  public static func getAdPosterList(url: String, completionHandler: @escaping (Array<STVAPosterAddInfo>?, Error?) -> Swift.Void) {
        STVAHttpRequest.requestAPI(URL: url, isGET: true, dicParams: [:], dicData: nil) { (result) in
            if result.error != nil {completionHandler(nil, result.error)}
            else{
                do{
                    if let items = result.data as? Array<Any> {
                        var arrContent:Array<STVAPosterAddInfo> = []
                        
                        for item in items {
                            let ctInfo = try STVAPosterAddInfo(jsonData: item)
                            arrContent.append(ctInfo)
                        }
                        if (arrContent.count == 0){
                            completionHandler(nil, NSError(domain: "result is empty", code: 0, userInfo: nil))
                        }else{
                            completionHandler(arrContent, nil)
                        }
                        
                    }else{
                        completionHandler(nil, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                    }
                    
                }catch{
                    completionHandler(nil, error)
                }
            }
            
        }//STVAHttpRequest.requestAPI
        
    }
    @objc  public static func contentListSNS(ch_idx: String, page:String?, count:String?, nextToken: String?, completionHandler: @escaping (Array<STVAModelContentInfo>?, String?, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.ch_idx.rawValue] = ch_idx
        if let nToken = nextToken {
            dicParam[STVASTR.nextToken.rawValue] = nToken
        }
        if let page = page {
            dicParam[STVASTR.page.rawValue] = page
        }
        if let count = count {
            dicParam[STVASTR.count.rawValue] = count
        }
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlListContentSNS, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, nil, result.error)}
            else{
                do{
                    if let dicResult = result.data as? Dictionary<String, Any> {
                        if let type = dicResult["type"] as? String,
                            let items = dicResult["items"] as? Array<Any>,
                            let nextToken = dicResult["nextToken"] as? String{
                            var ctType:ContentType_ = .Unknown
                            
                            if type == STVASTR.YouTube.rawValue {
                                ctType = .YouTube
                            }else{
                                completionHandler(nil, nil, NSError(domain: "unkonwn content type " + type, code: 0, userInfo: nil))
                                return;
                            }
                            var arrContent:Array<STVAModelContentInfo> = []
                            
                            for item in items {
                                let ctInfo = try STVAModelContentInfo(jsonData: item, type: ctType)
                                arrContent.append(ctInfo)
                            }
                            completionHandler(arrContent, nextToken, nil)
                        }else{
                            completionHandler(nil, nil, NSError(domain: "data is not type, items,nexttoken format", code: 0, userInfo: nil))
                        }
                    }else{
                        completionHandler(nil, nil, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                    }
                    
                }catch{
                    completionHandler(nil, nil, error)
                }
            }
            
        }//STVAHttpRequest.requestAPI
        
        
    }//@objc  public static func content
    
}
