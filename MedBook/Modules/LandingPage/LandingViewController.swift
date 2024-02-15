//
//  LandingViewController.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import UIKit

class LandingViewController: UIViewController {

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction func actionSignUp(_ sender: Any) {
        self.push(LoginAndSignUpViewController.getInstance(LoginAndSignUpViewModel(isForLogin: false)))
        
    }
    @IBAction func actionLogin(_ sender: Any) {
        self.push(LoginAndSignUpViewController.getInstance(LoginAndSignUpViewModel(isForLogin: true)))
    }
    
}
