//
//  EXBinder.swift
//  EXBinder
//

import UIKit

open class EXBinder<PropertyType: Equatable, UserInterfaceType> : NSObject, EXAccessProperty {
    public typealias translaterTypeAlias = (EXProperty<PropertyType>, UserInterfaceType) -> Void
    
    var observingKey    : String!
    var interfaceKey    : String!
    var property        : EXProperty<PropertyType>!
    var userInterface   : UserInterfaceType!
    var propertyToInterface      : translaterTypeAlias!
    var interfaceToProperty      : translaterTypeAlias!
    
    /// add observer using object memory reference
    private func enableObserver() {
        let propertyKey = NSNotification.Name(observingKey)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateValue(notification:)), name: propertyKey, object: nil)
        
        let interfaceKey = NSNotification.Name(self.interfaceKey)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI(notification:)), name: interfaceKey, object: nil)
    }
    
    /// remove observer using object memory reference
    private func disableObserver() {
        let propertyKey = NSNotification.Name(observingKey)
        NotificationCenter.default.removeObserver(self, name: propertyKey, object: nil)
        
        let interfaceKey = NSNotification.Name(self.interfaceKey)
        NotificationCenter.default.removeObserver(self, name: interfaceKey, object: nil)
    }
    
    /// notification hander from observer
    @objc func updateValue(notification: NSNotification) {
        DispatchQueue.main.async {
            let interface: UserInterfaceType = self.userInterface!
            let newProperty = notification.object as! EXProperty<PropertyType>
            self.propertyToInterface!(newProperty, interface)
        }
    }
    
    @objc func updateUI(notification: NSNotification) {
        DispatchQueue.main.async {
            let interface: UserInterfaceType = notification.object as! UserInterfaceType
            let property = self.property!
            self.interfaceToProperty(property, interface)
            //TODO:
        }
    }
    
    @objc func releaseObserver(notification: NSNotification) {
        DispatchQueue.main.async {
            self.disableObserver()
        }
    }
    
    
    /**
     - Parameters:
        - property: EXProperty 객체.
        - userInterface: EXProperty 객체와 묶으려 하는 사용자 인터페이스 객체 (ex: UILabel, UITextField..)
        - propertyToInterface: property -> interface. EXProperty 객체의 제네릭 타입과 인터페이스에서 사용할 값의 형태가 다른 경우, 형 변환을 위한 closure
        - interfaceToProperty: interface -> property. EXProperty 객체의 제네릭 타입과 인터페이스에서 사용할 값의 형태가 다른 경우, 형 변환을 위한 closure
     */
    func bind(property: EXProperty<PropertyType>, userInterface: UserInterfaceType, propertyToInterface: @escaping translaterTypeAlias, interfaceToProperty: @escaping translaterTypeAlias) {
        self.property = property
        self.userInterface = userInterface
        self.propertyToInterface = propertyToInterface
        self.interfaceToProperty = interfaceToProperty
        self.observingKey = property.observingKey
        self.interfaceKey = "\((userInterface as! NSObject).hash)"
        
        enableObserver()
        property.updateValue(property.value)
    }
    
    @objc public func releaseBind() {
        disableObserver()
    }
}
