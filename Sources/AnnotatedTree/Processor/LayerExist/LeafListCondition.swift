//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public protocol LeafListCondition{
    
    func satisfies(leafList: [ParseNodeDrawable]) -> Bool
}
