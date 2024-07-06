//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class LeafToPersian : LeafToLanguageConverter{
    
    /// Constructor for LeafToPersian. Sets viewLayerType to PERSIAN.
    public override init(){
        super.init()
        viewLayerType = .PERSIAN_WORD
    }
}
