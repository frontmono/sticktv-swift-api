//
//  STVACallComment.swift
//  StickPublicAPI
//
//  Created by Hak Kim on 6/5/18.
//

import UIKit

public class STVACallComment: NSObject {
    @objc  public static func getList(cts_idx: String, page:String?, count:String?, completionHandler: @escaping (Array<STVAModelCommentInfo>?, Int, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.cid.rawValue] = cts_idx
        
        if let page = page {
            dicParam[STVASTR.page.rawValue] = page
        }
        if let count = count {
            dicParam[STVASTR.count.rawValue] = count
        }
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlCommentList, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, 0, result.error)}
            else{
                do{
                    if let dicResult = result.data as? Dictionary<String, Any> {
                        if let total = dicResult["total"] as? String,
                            let items = dicResult["list"] as? Array<Any>{
                            if let cnt = Int(total) {
                                var arrContent:Array<STVAModelCommentInfo> = []
                                
                                for item in items {
                                    let ctInfo = try STVAModelCommentInfo(jsonData: item)
                                    arrContent.append(ctInfo)
                                }
                                completionHandler(arrContent, cnt, nil)
                            }else{
                                completionHandler(nil, 0, NSError(domain: "total is not int result", code: 0, userInfo: nil))
                            }
                        }else{
                            completionHandler(nil, 0, NSError(domain: "data is not type, items,nexttoken format", code: 0, userInfo: nil))
                        }
                    }else{
                        completionHandler(nil, 0, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                    }
                    
                }catch{
                    completionHandler(nil, 0, error)
                }
            }
            
        }//STVAHttpRequest.requestAPI
        
        
    }//@objc  public static func content
    
    @objc  public static func addComment(cts_idx: String, comment: String, completionHandler: @escaping (String?, Int, Error?) -> Swift.Void) {
        var dicParam:Dictionary<String, String> = [:]
        dicParam[STVASTR.cid.rawValue] = cts_idx
        dicParam[STVASTR.comment.rawValue] = comment
        
        
        STVAHttpRequest.requestAPIAfterToken(URL: STVAURL.Ins().urlCommentAdd, isGET: true, dicParams: dicParam) { (result: STVACallResult) in
            if result.error != nil {completionHandler(nil, 0, result.error)}
            else{
                if let dicResult = result.data as? Dictionary<String, Any> {
                    if let cmt_idx = dicResult["cmt_idx"] as? String,
                        let count = dicResult["count"] as? String{
                        if let count = Int(count) {
                            
                            completionHandler(cmt_idx, count, nil)
                        }else{
                            completionHandler(nil, 0, NSError(domain: "cmt_idx, count int casting failed", code: 0, userInfo: nil))
                        }
                    }else{
                        completionHandler(nil, 0, NSError(domain: "data is not type, cmt_idx, count format", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler(nil, 0, NSError(domain: "data is not dic format", code: 0, userInfo: nil))
                }
            }
            
        }//STVAHttpRequest.requestAPI
        
        
    }//@objc  public static func content
    
}
