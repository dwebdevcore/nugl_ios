//
//  ProfileViewController.swift
//  Nugl
//
//  Created by Diego Pais on 4/30/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: FormButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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

//    MARK: - Actions
    
    @IBAction func handleSignOutAction(_ sender: FormButton) {
        SessionManager.shared.signOut()
    }
    
    
//    MARK - Private
    
    private func setupUI() {
        
        signOutButton.setTitle(L10n.Profile.Button.signout, for: .normal)
    }
    
}
