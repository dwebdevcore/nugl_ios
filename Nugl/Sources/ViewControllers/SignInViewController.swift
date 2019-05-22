//
//  SignInViewController.swift
//  Nugl
//
//  Created by Diego Pais on 4/25/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftValidator
import FirebaseAuth
import UPKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var signInButton: FormButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet var fields: [HoshiTextField]!
    
    private let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupValidationRules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    MARK: Actions
    
    @IBAction func handleSignInAction(_ sender: FormButton) {
        
        validator.validate { (errors: [(Validatable, ValidationError)]) in
            
            if errors.count > 0 {
                
                for (_, error) in errors {
                    error.errorLabel?.text = error.errorMessage
                }
            }else {
                resetErrors()
                sender.startLoading()
                SessionManager.shared.signIn(with: emailTextField.text!, password: passwordTextField.text!, onCompltion: { (user: User?, error: Error?) in
                    sender.stopLoading()
                    if let error = error {

                        Utils.showAlert(withTitle: L10n.Generic.Alert.Error.title, message: error.localizedDescription, fromViewController: self)
                    }
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            sender.stopLoading()
        }
    }
    
    @IBAction func handleSignUpAction(_ sender: Any) {
        perform(segue: StoryboardSegue.Login.showSignUpViewController)
    }
    
    
//    MARK: - Private
    
    private func setupUI() {
        
        emailTextField.placeholder = L10n.Signin.Fields.email
        passwordTextField.placeholder = L10n.Signin.Fields.password
        
        signInButton.setTitle(L10n.Signin.Buttons.signin, for: .normal)
        
        forgotPasswordLabel.text = L10n.Signin.Labels.forgotpassword
        forgotPasswordButton.setTitle(L10n.Signin.Buttons.recoverPassword, for: .normal)
        
        noAccountLabel.text = L10n.Signin.Labels.noaccount
        signUpButton.setTitle(L10n.Signin.Buttons.signup, for: .normal)
    }
    
    private func setupValidationRules() {
        
        validator.registerField(emailTextField, errorLabel: emailTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(passwordTextField, errorLabel: passwordTextField.errorLabel, rules: [RequiredRule()])
    }
    
    private func resetErrors() {
        for field in fields {
            field.error = nil
        }
    }

}
