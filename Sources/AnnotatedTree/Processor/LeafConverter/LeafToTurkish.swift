//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class LeafToTurkish : LeafToLanguageConverter{
    
    /// Constructor for LeafToPersian. Sets viewLayerType to TURKISH.
    public override init(){
        super.init()
        viewLayerType = .TURKISH_WORD
    }
}
