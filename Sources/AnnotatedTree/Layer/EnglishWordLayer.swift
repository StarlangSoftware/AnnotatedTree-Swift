//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation

public class EnglishWordLayer : SourceLanguageWordLayer{
    
    override init(layerValue: String){
        super.init(layerValue: layerValue)
        self.layerName = "english"
    }
}
