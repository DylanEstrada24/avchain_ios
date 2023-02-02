// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let selfInput = try? JSONDecoder().decode(SelfInput.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSelfInputElement { response in
//     if let selfInputElement = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - SelfInputElement
struct SelfInputElement: Codable {
    let category: String
    let created: String
    let input: String

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case created = "created"
        case input = "input"
    }
}

typealias SelfInput = [SelfInputElement]
