//
//  STVAWebContainerView.swift
//  Pods-StickTVMaster-SWF
//
//  Created by Hak Kim on 4/20/18.
//

import UIKit

public class STVAWebContainerView: UIView , UIWebViewDelegate {
    
    
    var webViewer: UIWebView!
    var refreshController:UIRefreshControl!
    var errViewer:UILabel!
    var loadingTimer: Timer!
    var jsCallbackPrefix: String?
    
    var loadCallbackHandler:((CallbackType, Any?) -> Swift.Void)?
    
    public enum CallbackType : Int {
        case LOADING_STARTED = 1
        case LOADING_SUCCESS = 2
        case LOADING_PROGRESS = 3
        case LOADING_ERROR = 4
        case JSCallback = 5
    }
    
    
    
    
    
    override init(frame: CGRect) { // for creating in code
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) { //for creating in IB(Story Board or XIB file
        super.init(coder: aDecoder)
        commonInit()
    }
    public func showError(message msg:String){
        self.webViewer.isHidden = true
        self.errViewer.isHidden = false
        self.errViewer.text = msg
    }
    public func loadURL(URL string: String, JSPrefix jsPre: String?, callbackHandler: @escaping (CallbackType, Any?) -> Swift.Void ) -> Void {
        
        guard let url = URL(string: string) else {
            callbackHandler(.LOADING_ERROR, NSError(domain: "invalid url string", code: 0, userInfo: nil))
            return
        }
        self.jsCallbackPrefix = jsPre
        self.webViewer.delegate = nil
        self.loadCallbackHandler = callbackHandler
        self.loadingTimer?.invalidate()
        
        let request = URLRequest(url: url)
        if self.webViewer.isLoading {
            self.webViewer.stopLoading()
        }
        self.webViewer.delegate = self
        self.webViewer.loadRequest(request)
        
        var count:Float = 0;
        self.loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (time : Timer) in
            count += 1
            var percent:Float = (count / 50.0); // 5초 정도까지
            if percent > 1.0 {
                percent = 1.0
            }
            self.loadCallbackHandler?(.LOADING_PROGRESS, percent * 0.8) // 5초 지나면 80프로로 보여준다.
        })
        
    }
    private func commonInit(){
        self.webViewer = UIWebView()
        //self.webViewer.backgroundColor = UIColor.red
        
        self.addSubview(self.webViewer)
        webViewer.stva_CoverSuperview()
        self.errViewer = UILabel()
        self.errViewer.text = "Hello World"
        self.errViewer.isHidden = true
        self.errViewer.numberOfLines = 0
        self.errViewer.textAlignment = .center
        self.addSubview(self.errViewer)
        self.errViewer.stva_CoverSuperview()
        
        addPullToRefreshToWebView()
        
        
        
    }
    private func addPullToRefreshToWebView(){
        webViewer.scrollView.bounces = true //DONT FORGET IT!!!
        
        refreshController = UIRefreshControl()
        
        refreshController.bounds = CGRect(x: 0, y: 10, width: refreshController.bounds.size.width, height: refreshController.bounds.size.height)
        refreshController.addTarget(self, action: #selector(self.refreshWebView(refresh:)) , for: UIControlEvents.valueChanged)
        refreshController.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        webViewer.scrollView.addSubview(refreshController)
        
    }
    
    @objc func refreshWebView(refresh:UIRefreshControl){
        webViewer.reload()
    }
    
    
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let prefix = self.jsCallbackPrefix {
            if let url = request.url?.absoluteString {
                if url.hasPrefix(prefix ) {
                    self.loadCallbackHandler?(.JSCallback, url)
                    return false
                }
            }
            
        }
       
        return true
    }
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.loadCallbackHandler?(.LOADING_STARTED, nil)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        self.loadingTimer?.invalidate()
        self.loadCallbackHandler?(.LOADING_ERROR, error)
        
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.loadingTimer?.invalidate()
        self.loadCallbackHandler?(.LOADING_SUCCESS, nil)
        if refreshController.isRefreshing{
            refreshController.endRefreshing()
        }
        
    }
    
}
