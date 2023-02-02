//
//  EXProperty.swift
//  EXBinder
//

import UIKit

/// class description needed here
open class EXProperty <PropertyType: Equatable>: NSObject, EXAccessProperty {
    
    private var binderDic   : [String: AnyObject]      = [:]
    var observingKey: String!
    public var value       : PropertyType! {
        didSet {
            if oldValue != value {
                updateValue(value)
            }
        }
    }
    
    public init(_ type:PropertyType.Type) {
        super.init()
        observingKey = "\(self)"
    }
    
    /// send notification
    func updateValue(_ value: PropertyType) {
        let key = Notification.Name(rawValue: observingKey)
        NotificationCenter.default.post(name: key, object: self)
    }
    
    
    /// release all binding object
    @objc public func releaseAll() {
        let keys = Array(binderDic.keys)
        for key in keys {
            let binder = binderDic[key] as! NSObject
            binder.perform(Selector(("releaseBind")))
        }
    }
    
    public func release<UserInterfaceType> (userInterface: UserInterfaceType) {
        let keys = Array(binderDic.keys)
        for key in keys {
            guard let binder: EXBinder<PropertyType, UserInterfaceType> = binderDic[key] as? EXBinder<PropertyType, UserInterfaceType> else {
                continue
            }
            
            if "\((userInterface as! NSObject).hash)" == binder.interfaceKey {
                binder.releaseBind()
            }
        }
    }
}


// MARK: - bind
extension EXProperty {
    
    /**
     - Parameters:
     - property: EXProperty 객체.
     - userInterface: EXProperty 객체와 묶으려 하는 사용자 인터페이스 객체 (ex: UILabel, UITextField..)
     - propertyToInterface: property -> interface. EXProperty 객체의 제네릭 타입과 인터페이스에서 사용할 값의 형태가 다른 경우, 형 변환을 위한 closure
     - interfaceToProperty: interface -> property. EXProperty 객체의 제네릭 타입과 인터페이스에서 사용할 값의 형태가 다른 경우, 형 변환을 위한 closure
     */
    public func bind<UserInterfaceType> (userInterface: UserInterfaceType, propertyToInterface: @escaping (EXProperty<PropertyType>, UserInterfaceType) -> Void, interfaceToProperty: @escaping (EXProperty<PropertyType>, UserInterfaceType) -> Void) {
        let binder = EXBinder<PropertyType, UserInterfaceType>()
        binder.bind(property: self, userInterface: userInterface, propertyToInterface: propertyToInterface, interfaceToProperty: interfaceToProperty)
        
        binderDic.updateValue(binder, forKey: binder.interfaceKey)
    }
}
