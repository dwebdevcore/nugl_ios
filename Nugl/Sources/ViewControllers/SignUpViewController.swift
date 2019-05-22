//
//  SignUpViewController.swift
//  Nugl
//
//  Created by Diego Pais on 4/29/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftValidator
import UPKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    @IBOutlet weak var agreeTermsButton: UIButton!
    @IBOutlet weak var signUpButton: FormButton!
    @IBOutlet weak var termsErrorLabel: UILabel!
    
    @IBOutlet weak var openTermsButton: UIButton!
    
    private let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupValidationRules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: - Actions
    
    @IBAction func handleSignUpAction(_ sender: FormButton) {
        
        resetErrors()
        validator.validate { (errors: [(Validatable, ValidationError)]) in

            if errors.count > 0 {
                for (_, error) in errors {
                    error.errorLabel?.text = error.errorMessage
                }
            }else {
                guard agreeTermsButton.isSelected else {
                    self.termsErrorLabel.text = L10n.Signup.Errors.mustAgreeTerms
                    return
                }
                
                sender.startLoading()
                SessionManager.shared.signUp(with: emailTextField.text!, password: passwordTextField.text!, onCompletion: { (_, error: Error?) in
                    sender.stopLoading()
                    if let error = error {
                        Utils.showAlert(withTitle: L10n.Generic.Alert.Error.title, message: error.localizedDescription, fromViewController: self)
                    }
                })
            }
        }
    }
    
    @IBAction func handleOpenTerms(_ sender: UIButton) {
        Utils.showAlert(withTitle: L10n.Signup.Alert.Terms.title, message: L10n.Signup.Alert.Terms.body, fromViewController: self)
    }
    
    @IBAction func handleAgreeTerms(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            termsErrorLabel.text = nil
        }
    }
    
    
//    MARK: - Private
    
    private func setupUI() {
        
        title = L10n.Signup.title
        
        emailTextField.placeholder = L10n.Signup.Field.email
        passwordTextField.placeholder = L10n.Signup.Field.password
        confirmPasswordTextField.placeholder = L10n.Signup.Field.confirmPassword
        
        agreeTermsButton.setTitle(" \(L10n.Signup.Button.agreeTerms)", for: .normal)
        openTermsButton.setTitle(L10n.Signup.Button.openTerms, for: .normal)
        
        signUpButton.setTitle(L10n.Signup.Button.signUp, for: .normal)
    }
    
    private func setupValidationRules() {
        
        validator.registerField(emailTextField, errorLabel: emailTextField.errorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordTextField, errorLabel: passwordTextField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 6)])
        validator.registerField(confirmPasswordTextField, errorLabel: confirmPasswordTextField.errorLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: passwordTextField, message: L10n.Signup.Errors.passwordsNotMatch)])
        
    }
    
    private func resetErrors() {
        emailTextField.error = nil
        passwordTextField.error = nil
        confirmPasswordTextField.error = nil
        
        termsErrorLabel.text = nil
    }
}
