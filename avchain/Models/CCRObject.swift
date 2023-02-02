//
//  CCRObject.swift
//  AvatarBeans
//

import UIKit
//import EXBinder

class CCRObject: EXModel {
    var avatarId            = EXProperty(String.self)
    var avatarTypeCode      = EXProperty(String.self)
    var created             = EXProperty(String.self)
    var creator             = EXProperty(String.self)
    var departmentCode      = EXProperty(String.self)
    var downloadFlag        = EXProperty(String.self)
    var fileCreateDate      = EXProperty(String.self)
    var fileName            = EXProperty(String.self)
    var hospitalCode        = EXProperty(String.self)
    var pushFlag            = EXProperty(String.self)
    var seq                 = EXProperty(Int.self)
    var updated             = EXProperty(String.self)
    var updater             = EXProperty(String.self)
    var xnetUserId          = EXProperty(String.self)
    var xnetUserName        = EXProperty(String.self)
}
