//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public protocol NodeDrawableCondition{
    
    func satisfies(parseNode: ParseNodeDrawable) -> Bool
}
