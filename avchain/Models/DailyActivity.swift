//
//  DailyActivity.swift
//  avchain
//

import Foundation

// 자가입력 및 목표설정 Model
class DailyActivity: NSObject {
    public var idx: Int?
    public var saveDate: String?
    public var highBlood: Int?
    public var lowBlood: Int?
    public var weight: Int?
    public var bloodSugar: Int?
    public var calorie: Int?
    public var protein: Int?
    public var carbohydrate: Int?
    public var fat: Int?
    public var potassium: Int?
    public var phosphorus: Int?
    public var calcium: Int?
    public var sodium: Int?
    
    init(idx: Int, saveDate: String, highBlood: Int, lowBlood: Int, weight: Int, bloodSugar: Int, calorie: Int, protein: Int, carbohydrate: Int, fat: Int, potassium: Int, phosphorus: Int, calcium: Int, sodium: Int) {
        self.idx = idx
        self.saveDate = saveDate
        self.highBlood = highBlood
        self.lowBlood = lowBlood
        self.weight = weight
        self.bloodSugar = bloodSugar
        self.calorie = calorie
        self.protein = protein
        self.carbohydrate = carbohydrate
        self.fat = fat
        self.potassium = potassium
        self.phosphorus = phosphorus
        self.calcium = calcium
        self.sodium = sodium
    }
    
    override init() {
        super.init()
    }
}


// =============정보입력===============

struct SelfdialogElement: Codable {
    let category: String
    let created: String
    let input: String

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case created = "created"
        case input = "input"
    }
}

typealias Selfdialog = [SelfdialogElement]

// ============================================
