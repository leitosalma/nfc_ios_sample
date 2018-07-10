//
//  BorderView.swift
//  NFCReader
//
//  Created by Leo Salmaso on 02/07/2018.
//  Copyright © 2018 Leo Salmaso. All rights reserved.
//

import UIKit

@IBDesignable
class BorderView: UIView {    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

