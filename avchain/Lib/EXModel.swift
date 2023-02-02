//
//  EXModel.swift
//  EXBinder
//

import UIKit

open class EXModel: NSObject, EXAccessProperty {
    
    open func propertyList() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    
    /// set property using key-value dictionary object
    open func setData(_ dic: [AnyHashable: Any]) {
        let propertyNames = self.propertyList()
        let keys = dic.keys
        
        for key in keys {
            guard let key = key as? String else { continue }
            for propertyName in propertyNames {
                if key == propertyName {
                    let property = self[propertyName]
                    let value = dic[propertyName]
                    
                    switch property {
                    case is EXProperty<Int>:
                        let property = property as! EXProperty<Int>
                        property.value = value as? Int
                    case is EXProperty<Int32>:
                        let property = property as! EXProperty<Int32>
                        property.value = value as? Int32
                    case is EXProperty<Int64>:
                        let property = property as! EXProperty<Int64>
                        property.value = value as? Int64
                    case is EXProperty<String>:
                        let property = property as! EXProperty<String>
                        property.value = value as? String
                    case is EXProperty<Double>:
                        let property = property as! EXProperty<Double>
                        property.value = value as? Double
                    case is EXProperty<Float>:
                        let property = property as! EXProperty<Float>
                        property.value = value as? Float
                    case is EXProperty<Bool>:
                        let property = property as! EXProperty<Bool>
                        property.value = value as? Bool
                        
                    default: break
                    }
                }
            }
        }
    }
    
    open func getData() -> [AnyHashable: Any] {
        let propertyNames = self.propertyList()
        var returnDic: [AnyHashable: Any] = [:]
        
        for name in propertyNames {
            let property = self[name]
            var value: Any? = nil
            switch property {
            case is EXProperty<Int>:
                let property = property as! EXProperty<Int>
                value = property.value as Any
            case is EXProperty<String>:
                let property = property as! EXProperty<String>
                value = property.value as Any
            case is EXProperty<Double>:
                let property = property as! EXProperty<Double>
                value = property.value as Any
            case is EXProperty<Float>:
                let property = property as! EXProperty<Float>
                value = property.value as Any
            case is EXProperty<Bool>:
                let property = property as! EXProperty<Bool>
                value = property.value as Any
                
            default: break
            }
            
            returnDic.updateValue(value as Any, forKey: name)
        }
        
        return returnDic
    }
    
    
    func releaseAll() {
        let propertyName = propertyList()
        //TODO: make it sure to convert
        for name in propertyName {
            let property = self[name] as! NSObject
            property.perform(Selector(("releaseAll")))
        }
    }
    
    override open var description: String {
        get {
            let propertyNames = self.propertyList()
            var string = "########## \(type(of: self)) ##########\n"
            for name in propertyNames {
                let property = self[name]!
                
                let propertyName = "\t \(name) : "
                var propertyValue = ""
                
                switch property {
                case is EXProperty<Int>:
                    let property = property as! EXProperty<Int>
                    propertyValue = "\t\(String(describing: property.value ?? 0))\n"
                case is EXProperty<String>:
                    let property = property as! EXProperty<String>
                    propertyValue = "\t\(String(describing: property.value ?? ""))\n"
                case is EXProperty<Double>:
                    let property = property as! EXProperty<Double>
                    propertyValue = "\t\(String(describing: property.value ?? 0))\n"
                case is EXProperty<Float>:
                    let property = property as! EXProperty<Float>
                    propertyValue = "\t\(String(describing: property.value ?? 0))\n"
                case is EXProperty<Bool>:
                    let property = property as! EXProperty<Bool>
                    propertyValue = "\t\(String(describing: property.value ?? false))\n"
                    
                default:
                    continue
                }
                
                string += "\(propertyName)" + propertyValue
            }
            string += "########## -> end of model\n"
            return string
        }
    }
}
