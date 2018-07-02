//
//  NFCReaderViewController.swift
//  NFCReader
//
//  Created by Leo Salmaso on 29/06/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit

class NFCReaderViewController: UIViewController {
   
    @IBOutlet weak var nfcButton: UIButton!
    
    lazy var nfcHandler: NFCHandler = {
        let handler = NFCHandler(invalidateAfterFirstRead: true)
        handler.delegate = self
        return handler
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startNFCReadingAction(_ sender: Any) {
        nfcHandler.startNFCScan()
    }
    
    func processMessages(_ messages: [NFCMessage]) {
        
        //With Amount
        // Sample URL: melinfc://processNFCPayment?userId=999&amount=20,80
        
        //Without amount
        // Sample URL: melinfc://processNFCPayment?userId=999
        
        if let messageToProcess = messages.first, let mpUrl = messageToProcess.payload {
        
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

