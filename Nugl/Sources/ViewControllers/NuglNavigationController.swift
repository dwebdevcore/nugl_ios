//
//  NuglNavigationController.swift
//  Nugl
//
//  Created by Diego Pais on 4/29/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import UIKit

class NuglNavigationController: UINavigationController, CAAnimationDelegate {

    private var gradientSet: [[CGColor]] = []
    private let gradientLayer = CAGradientLayer()
    private var currentGradient = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = .black
        navigationBar.tintColor = .white
        // Hack to remove all back buttons titles
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-500, 0), for:UIBarMetrics.default)

        setupGradients()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateGradient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        
        gradientLayer.frame = CGRect(x: 0, y: -statusBarFrame.height, width: navigationBar.frame.width, height: navigationBar.frame.height + statusBarFrame.height)
    }
    
//    MARK - CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = gradientSet[currentGradient]
        animateGradient()
    }
    
    private func setupGradients() {
        
        let color1 = Color(named: .green).cgColor
        let color2 = Color(named: .blue).cgColor
        let color3 = Color(named: .pink).cgColor

        gradientSet.append([color1, color2])
        gradientSet.append([color2, color3])
        gradientSet.append([color3, color1])
     
        gradientLayer.colors = gradientSet[currentGradient]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.drawsAsynchronously = true

        navigationBar.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    private func animateGradient() {
        
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
    }
}
