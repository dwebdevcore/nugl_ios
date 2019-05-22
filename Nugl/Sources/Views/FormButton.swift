//
//  FormButton.swift
//  Nugl
//
//  Created by Diego Pais on 4/29/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

public class FormButton: UIButton {
    
    fileprivate lazy var activityIndicatorView: NVActivityIndicatorView = {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)), type: .circleStrokeSpin, color: self.titleLabel?.textColor, padding: nil)
        return activityIndicatorView
    }()
    
    fileprivate var normalStateTitle: String?
    fileprivate var normalStateImage: UIImage?
    fileprivate var focusedBackgroundColor: UIColor!
    
    public var roundCorners = false
    
    public func startLoading() {
        showActivityIndicatorView = true
    }
    
    public func stopLoading() {
        showActivityIndicatorView = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if roundCorners {
            layer.masksToBounds = true
            layer.cornerRadius = frame.height / 2.0
        }
    }
    
    private var showActivityIndicatorView: Bool = false {
        didSet {
            
            if showActivityIndicatorView == oldValue {
                return
            }
            
            if showActivityIndicatorView {
                
                if activityIndicatorView.superview == nil {
                    
                    self.addSubview(activityIndicatorView)
                    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
                    activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                    activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                }
                
                isEnabled = false
                normalStateTitle = title(for: .normal)
                normalStateImage = image(for: .normal)
                setTitle("", for: .normal)
                setImage(nil, for: .normal)
                activityIndicatorView.startAnimating()
            } else {
                isEnabled = true
                setTitle(normalStateTitle, for: .normal)
                setImage(normalStateImage, for: .normal)
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1 : 0.3
        }
    }
    
}
