// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   var memberInfo = try? JSONDecoder().decode(MemberInfo.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMemberInfo { response in
//     if var memberInfo = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MemberInfo
struct MemberInfo: Codable {
    var listAuthMemberDevice: [ListAuthMemberDevice]
    var created: String
    var password: String
    var count: Int
    var email: String
    var valid: String
    var membershipCode: String
    var organizationCode: String
    var id: String
    var creator: String
    var genderCode: String
    var updated: String
    var mobile: String
    var updater: String
    var cryptographicAlgorithm: String
    var listAuthMemberRole: [ListAuthMemberRole]
    var digested: Bool
    var name: String
    var departmentCode: String
    var birth: String
    var titleCode: String

    enum CodingKeys: String, CodingKey {
        case listAuthMemberDevice = "listAuthMemberDevice"
        case created = "created"
        case password = "password"
        case count = "count"
        case email = "email"
        case valid = "valid"
        case membershipCode = "membershipCode"
        case organizationCode = "organizationCode"
        case id = "id"
        case creator = "creator"
        case genderCode = "genderCode"
        case updated = "updated"
        case mobile = "mobile"
        case updater = "updater"
        case cryptographicAlgorithm = "cryptographicAlgorithm"
        case listAuthMemberRole = "listAuthMemberRole"
        case digested = "digested"
        case name = "name"
        case departmentCode = "departmentCode"
        case birth = "birth"
        case titleCode = "titleCode"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListAuthMemberDevice { response in
//     if var listAuthMemberDevice = response.result.value {
//       ...
//     }
//   }

// MARK: - ListAuthMemberDevice
struct ListAuthMemberDevice: Codable {
    var updater: String
    var id: String
    var systemTypeVersion: String?
    var valid: String
    var osCode: String?
    var deviceID: String
    var systemTypeCode: String?
    var systemCode: String
    var creator: String
    var seq: Int
    var mobile: String
    var updated: String
    var created: String

    enum CodingKeys: String, CodingKey {
        case updater = "updater"
        case id = "id"
        case systemTypeVersion = "systemTypeVersion"
        case valid = "valid"
        case osCode = "osCode"
        case deviceID = "deviceId"
        case systemTypeCode = "systemTypeCode"
        case systemCode = "systemCode"
        case creator = "creator"
        case seq = "seq"
        case mobile = "mobile"
        case updated = "updated"
        case created = "created"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListAuthMemberRole { response in
//     if var listAuthMemberRole = response.result.value {
//       ...
//     }
//   }

// MARK: - ListAuthMemberRole
struct ListAuthMemberRole: Codable {
    var id: String
    var systemCode: String
    var seq: Int
    var roleCode: String
    var creator: String
    var valid: String
    var updater: String
    var updated: String
    var created: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case systemCode = "systemCode"
        case seq = "seq"
        case roleCode = "roleCode"
        case creator = "creator"
        case valid = "valid"
        case updater = "updater"
        case updated = "updated"
        case created = "created"
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    var decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    var encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard var data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    @discardableResult
    func responseMemberInfo(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MemberInfo>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
