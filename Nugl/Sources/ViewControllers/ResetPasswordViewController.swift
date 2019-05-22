//
//  ResetPasswordViewController.swift
//  Nugl
//
//  Created by Diego Pais on 4/30/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftValidator
import UPKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetPasswordMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var submitButton: FormButton!
    
    private let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupValidationRules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }

//    MARK: - Actions
    
    @IBAction func handleSubmitAction(_ sender: FormButton) {
        
        resetErrors()
        validator.validate { (errors: [(Validatable, ValidationError)]) in
            
            if errors.count > 0 {
                for (_, error) in errors {
                    error.errorLabel?.text = error.errorMessage
                }
            }else {
                sender.startLoading()
                SessionManager.shared.resetPassword(for: emailTextField.text!, onCompletion: { (error: Error?) in
                    sender.stopLoading()
                    if let error = error {
                        Utils.showAlert(withTitle: L10n.Generic.Alert.Error.title, message: error.localizedDescription, fromViewController: self)
                    }else {
                        Utils.showAlert(withTitle: L10n.Resetpassword.Alert.Success.title, message: L10n.Resetpassword.Alert.Success.body, fromViewController: self)
                    }
                })
            }
        }
    }
    
    
//    MARK: - Private
    
    private func setupUI() {
        
        title = L10n.Resetpassword.title
        
        resetPasswordMessageLabel.text = L10n.Resetpassword.Label.message
        emailTextField.placeholder = L10n.Resetpassword.Field.email
        
        submitButton.setTitle(L10n.Resetpassword.Button.submit, for: .normal)
    }
    
    private func setupValidationRules() {
        validator.registerField(emailTextField, errorLabel: emailTextField.errorLabel, rules: [RequiredRule(), EmailRule()])
    }
    
    private func resetErrors() {
        emailTextField.error = nil
    }
}
