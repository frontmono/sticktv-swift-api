//
//  STVAUINavigationViewController.swift
//  Pods-StickTVMaster-SWF
//
//  Created by Hak Kim on 4/20/18.
//

import UIKit


var stvProgressExtention: String = "gv stvProgressExtention"

public extension UINavigationController {
    
    private(set) var stvaProgressViewer: UIProgressView? {
        get {
            guard let value = objc_getAssociatedObject(self, &stvProgressExtention) as? UIProgressView else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &stvProgressExtention, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func stva_ProgressShowHide(isShow: Bool){
        self.stvaProgressViewer?.isHidden = !isShow
    }
    func stva_ProgressShowPercent(percent: Float){
        if self.stvaProgressViewer == nil {
            //let progViewer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let progViewer = UIProgressView(progressViewStyle: .bar)
            let naviBar = self.navigationBar
            naviBar.addSubview(progViewer)
            self.stvaProgressViewer = progViewer
            
            // create constraints
            // NOTE: bottom constraint has 1 as constant value instead of 0; this way the progress bar will look like the one in Safari
            let bottomConstraint = NSLayoutConstraint(item: naviBar, attribute: .bottom, relatedBy: .equal, toItem: progViewer, attribute: .bottom, multiplier: 1, constant: 1)
            
            let leftConstraint = NSLayoutConstraint(item: naviBar, attribute: .leading, relatedBy: .equal, toItem: progViewer, attribute: .leading, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: naviBar, attribute: .trailing, relatedBy: .equal, toItem: progViewer, attribute: .trailing, multiplier: 1, constant: 0)
            
            // add constraints
            progViewer.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints([bottomConstraint, leftConstraint, rightConstraint])
            self.stvaProgressViewer = progViewer;
            
        }
        self.stvaProgressViewer?.progress = percent
        
        
    }
}
