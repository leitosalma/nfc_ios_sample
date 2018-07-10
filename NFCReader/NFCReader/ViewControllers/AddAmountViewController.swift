//
//  AddAmountViewController.swift
//  NFCReader
//
//  Created by Leo Salmaso on 02/07/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit

class AddAmountViewController: UIViewController {

    @IBOutlet weak var bottomConstraintStackView: NSLayoutConstraint!
    @IBOutlet weak var amountTextField: MoneyTextField!
    
    var parametersToShow: NFCPaymentParameters?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = amountTextField.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo,let keyboardFrame = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let frame = self.view.convert(keyboardFrame.cgRectValue, from: nil)
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.5
            
            var newHeight = frame.size.height
            if #available(iOS 11.0, *) {
                if let window = UIApplication.shared.keyWindow {
                    newHeight += window.safeAreaInsets.bottom + 10
                }
            }
            
            bottomConstraintStackView.constant = (-newHeight)
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        bottomConstraintStackView.constant = 0
    }

    @IBAction func payAction(_ sender: Any) {
        if let userId = self.parametersToShow?.userId {
            parametersToShow = NFCPaymentParameters(userId: userId, amount: amountTextField.amount)
            performSegue(withIdentifier: "confirmAmount", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmAmount", let vc = segue.destination as? ConfirmationViewController {
            vc.parametersToShow = parametersToShow
            vc.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
}
