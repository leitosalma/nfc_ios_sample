//
//  ConfirmationViewController.swift
//  NFCReader
//
//  Created by Leo Salmaso on 02/07/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var amountTextField: MoneyTextField! {
        didSet {
            amountTextField.amount = parametersToShow?.amount ?? 0
        }
    }
    
    var parametersToShow: NFCPaymentParameters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func confirm(_ sender: Any) {
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.stopActivityIndicator()
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicatorContainer.isHidden = false
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicatorContainer.isHidden = true
    }
}
