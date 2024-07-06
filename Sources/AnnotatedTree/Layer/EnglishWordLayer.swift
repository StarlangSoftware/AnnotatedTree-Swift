//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation

public class EnglishWordLayer : SourceLanguageWordLayer{
    
    /// Constructor for the word layer for English language. Sets the surface form.
    /// - Parameter layerValue: Value for the word layer.
    override init(layerValue: String){
        super.init(layerValue: layerValue)
        self.layerName = "english"
    }
}
