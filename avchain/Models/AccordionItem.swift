//
//  AccordionItem.swift
//  avchain
//

import Foundation


struct AccordionItem {
    let title: String
    let number: String?
    let subTitle: [String]?
    let content: [String]?
}


typealias AccordionList = [AccordionItem]
