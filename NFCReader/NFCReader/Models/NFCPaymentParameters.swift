//
//  NFCPaymentParameters.swift
//  NFCReader
//
//  Created by Leo Salmaso on 02/07/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit

struct NFCPaymentParameters {
    let userId: String
    let amount: Double
    
    init(userId: String, amount: Double = 0.0) {
        self.userId = userId
        self.amount = amount
    }
    
    init?(fromUrl url: URL) {
        guard let parameters = url.getParameters, let userId = parameters["userId"] else { return nil }
    
        self.userId = userId
        
        if let amountParam = parameters["amount"], let amount = Double(amountParam) {
            self.amount = amount
        } else {
            amount = 0.0
        }
        
    }
}

extension URL {
    
    public var getParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

