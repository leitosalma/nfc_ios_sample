//
//  NFCMessage.swift
//  NFCReader
//
//  Created by Leo Salmaso on 28/06/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import Foundation
import CoreNFC

extension NFCTypeNameFormat {
    func toString() -> String {
        switch self {
        case .empty:
            return "Empty"
        case .nfcWellKnown:
            return "NFC Well Known"
        case .media:
            return "Media"
        case .absoluteURI:
            return "Absolute URI"
        case .nfcExternal:
            return "NFC External"
        case .unchanged:
            return "Unchanged"
        default:
            return "Unknown"
        }
    }
}

enum PayloadType: String {
    case uriRecord = "U"
    
    init(rawValue: String) {
        switch rawValue {
        case PayloadType.uriRecord.rawValue:
            self = .uriRecord
        default:
            self = .uriRecord
        }
    }
    
    init?(_ payloadType: Data) {
        let rawValue = String(data: payloadType, encoding: .utf8) ?? ""
        self.init(rawValue: rawValue)
    }
}

struct NFCMessage {
    let tnf: String?
    let payload: String?
    let payloadId: String?
    let payloadType: PayloadType?
    
    init(_ tnf: String?, payloadType: String?, payloadId: String?, payload: String?) {
        self.tnf = tnf
        self.payloadType = PayloadType(rawValue: payloadType ?? "")
        self.payloadId = payloadId
        self.payload = payload
    }
    
    init(_ message: NFCNDEFPayload) {
        self.tnf = message.typeNameFormat.toString()
        self.payload = String(data: message.payload, encoding: .utf8)?.replacingOccurrences(of: "\0", with: "")
        self.payloadType = PayloadType(message.type)
        self.payloadId = String(data: message.identifier, encoding: .utf8) ?? ""
    }
}
