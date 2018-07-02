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
    
    var delegate: NFCHandlerDelegate?
    private var nfcSession: NFCNDEFReaderSession!

    
    init(invalidateAfterFirstRead: Bool) {
        super.init()
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: invalidateAfterFirstRead)
    }
    
    func startNFCScan() {
        nfcSession.begin()
    }
    
    func stopNFCScan() {
        nfcSession.invalidate()
    }
}

extension NFCHandler : NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC-Session invalidated: \(error.localizedDescription)")
        delegate?.didInvalidate(error)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("Messages read: (\(messages.count))")
        
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
