//
//  NFCHandler.swift
//  NFCReader
//
//  Created by Leo Salmaso on 27/06/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit
import CoreNFC

protocol NFCHandlerDelegate {
    func didReceiveMessages(_ messages: [[NFCMessage]])
    func didInvalidate(_ error: Error?)
}

final class NFCHandler: NSObject {
    
    private var nfcSession: NFCNDEFReaderSession!
    var delegate: NFCHandlerDelegate?
    
    func startNFCScan(invalidateAfterFirstRead: Bool, userMessage: String) {
        resetSession(invalidateAfterFirstRead: invalidateAfterFirstRead, userMessage: userMessage)
        nfcSession.begin()
    }
    
    func stopNFCScan() {
        nfcSession.invalidate()
    }
    
    func resetSession(invalidateAfterFirstRead: Bool, userMessage: String) {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue:  DispatchQueue.main, invalidateAfterFirstRead: invalidateAfterFirstRead)
        nfcSession.alertMessage = userMessage
    }
}

extension NFCHandler : NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFCReader - Error: \(error.localizedDescription)")
        delegate?.didInvalidate(error)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var response = [[NFCMessage]]()
        
        for message in messages {
            let processedMessages = message.records.map({ record in
                return NFCMessage(record)
            })
            
            response.append(processedMessages)
        }
        
        delegate?.didReceiveMessages(response)
    }
}
