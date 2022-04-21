//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class LeafToEnglish : LeafToLanguageConverter{
    
    public override init(){
        super.init()
        viewLayerType = .ENGLISH_WORD
    }
}
