//
//  NFCReaderViewController.swift
//  NFCReader
//
//  Created by Leo Salmaso on 29/06/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NFCReaderViewController: UIViewController {
    @IBOutlet weak var nfcButton: UIButton!
    var parametersToSend: NFCPaymentParameters?
    
    lazy var nfcHandler: NFCHandler = {
        let handler = NFCHandler()
        handler.delegate = self
        return handler
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func startNFCReadingAction(_ sender: Any) {
       startNFCReading()
    }
    
    func startNFCReading() {
        nfcHandler.startNFCScan(invalidateAfterFirstRead: true, userMessage: "Acercá tu teléfono al del vendedor para terminar la transacción")
    }
    
    func processMessages(_ messages: [NFCMessage]) {
        if let messageToProcess = messages.first, let mpUrl = messageToProcess.payload, let url = URL(string: mpUrl), let nfcParameters = NFCPaymentParameters(fromUrl: url) {
            
            parametersToSend = nfcParameters
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if nfcParameters.amount > 0 {
                    self.performSegue(withIdentifier: "confirmPayment", sender: self)
                } else {
                    self.performSegue(withIdentifier: "addAmount", sender: self)
                }
            }
            
        } else {
            print("Error parsing the url")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPayment", let vc = segue.destination as? ConfirmationViewController {
            vc.parametersToShow = parametersToSend
        } else if segue.identifier == "addAmount", let vc = segue.destination as? AddAmountViewController {
            vc.parametersToShow = parametersToSend
        }
    }
}

extension NFCReaderViewController: NFCHandlerDelegate {
    
    func didReceiveMessages(_ messages: [[NFCMessage]]) {
        if messages.count == 1, let firstArray = messages.first {
            processMessages(firstArray)
        }
    }
    
    func didInvalidate(_ error: Error?) {
        if let error = error {
            print("NFC-Session invalidated: \(error.localizedDescription)")
        }
    }
}

