//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public protocol LeafToStringConverter{
    
    func leafConverter(leafNode: ParseNodeDrawable) -> String
}
