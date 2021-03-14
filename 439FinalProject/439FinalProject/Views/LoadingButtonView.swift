//
//  LoadingButtonView.swift
//  439FinalProject
//
//  Created by Anamika Basu on 3/14/21.
//

import Foundation
import UIKit

class LoadingButtonView: UIButton {
    
    var activityIndicator: UIActivityIndicatorView!
    
    let activityIndicatorColor: UIColor = .white
    
    func loadIndicator(_ shouldShow: Bool) {
        if shouldShow {
            if (activityIndicator == nil) {
                activityIndicator = createActivityIndicator()
            }
            self.isEnabled = false
            self.alpha = 0.7
            self.setTitleColor(UIColor.systemBlue, for: .normal)
            showSpinning()
        } else {
            self.setTitleColor(UIColor.white, for: .normal)
            activityIndicator.stopAnimating()
            self.isEnabled = true
            self.alpha = 1.0
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        positionActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func positionActivityIndicatorInButton() {
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: activityIndicator,
                                                    attribute: .trailing,
                                                    multiplier: 1, constant: 30)
        self.addConstraint(trailingConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}
