//
//  UIControlExtension.swift
//  EXBinder
//

import Foundation
import UIKit

extension UIControl {
    open override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        self.bindingUpdater()
        return super.awakeAfter(using: aDecoder)
    }
    
    @objc func bindingUpdater() {
        self.addTarget(self, action: #selector(updateValue), for: UIControl.Event.valueChanged)
        
        // TODO: have to change for text editing logic.
        //      when using over two binding interface, will be shown wrong way
        self.addTarget(self, action: #selector(updateValue), for: UIControl.Event.editingChanged)
    }
    
    @objc func updateValue() {
        let interfaceKey = "\(self.hash)"
        let key = Notification.Name(rawValue: interfaceKey)
        NotificationCenter.default.post(name: key, object: self)
    }
}
