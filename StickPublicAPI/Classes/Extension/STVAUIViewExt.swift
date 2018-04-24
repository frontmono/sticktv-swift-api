//
//  STVAUIViewExtension.swift
//  Pods-StickTVMaster-SWF
//
//  Created by Hak Kim on 4/20/18.
//

import UIKit

import UIKit


extension UIView {
    
    
    func stva_CoverSuperview() {
        
        guard let superview = self.superview else {
            assert(false, "Error! `superview` was nil – call `addSubview(_ view: UIView)` before calling `\(#function)` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        /*
         NSLayoutConstraint.activate([
         self.topAnchor.constraint(equalTo: superview.topAnchor)
         ])
         */
        ///*
        let multiplier = CGFloat(1.0)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: multiplier),
            self.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: multiplier),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            ])
        //*/
        
    }
}

