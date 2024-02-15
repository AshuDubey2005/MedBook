//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import UIKit

class BaseViewController <T: BaseViewModel>: UIViewController {
    
    var viewModel: T!
    var headerTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addListener() {
        
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
            // Create an alert controller
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add an action (button) to the alert
            let okAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
            alertController.addAction(okAction)

            // Present the alert
            present(alertController, animated: true, completion: nil)
        }
    
    
}
