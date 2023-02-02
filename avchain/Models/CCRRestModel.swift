// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ccrData = try? JSONDecoder().decode(CcrData.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCcrData { response in
//     if let ccrData = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - CcrRestData
struct CCRRestData: Codable {
    let dateOfBirth: String
    let syncCode: String
    let medications: [[String: [String]]]
    let problems: [[String: [String]]]
    let vitalsigns: [[String: [String]]]
    let results: [[String: [String]]]
    let patientNumber: String
    let procedures: [[String: [String]]]
    let patientSeq: Int
    let telephone: String
    let encounters: [[String: [String]]]
    let gender: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case dateOfBirth = "dateOfBirth"
        case syncCode = "syncCode"
        case medications = "medications"
        case problems = "problems"
        case vitalsigns = "vitalsigns"
        case results = "results"
        case patientNumber = "patientNumber"
        case procedures = "procedures"
        case patientSeq = "patientSeq"
        case telephone = "telephone"
        case encounters = "encounters"
        case gender = "gender"
        case name = "name"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseProcedure { response in
//     if let procedure = response.result.value {
//       ...
//     }
//   }

// MARK: - Procedure
struct Procedure: Codable {
    let codeValue: [String]
    let codeCodingSystem: [String]
    let actorID: [String]
    let actorRole: [String]
    let dateTimeValue: [String]
    let description: [String]
    let additionalDescription: [String]
    let objectID: [String]

    enum CodingKeys: String, CodingKey {
        case codeValue = "codeValue"
        case codeCodingSystem = "codeCodingSystem"
        case actorID = "actorID"
        case actorRole = "actorRole"
        case dateTimeValue = "dateTimeValue"
        case description = "description"
        case additionalDescription = "additionalDescription"
        case objectID = "objectID"
    }
}
