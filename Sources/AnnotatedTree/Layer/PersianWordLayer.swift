//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class PersianWordLayer : TargetLanguageWordLayer{
    
    /// Constructor for the word layer for Persian language. Sets the surface form.
    /// - Parameter layerValue: Value for the word layer.
    override init(layerValue: String){
        super.init(layerValue: layerValue)
        layerName = "persian"
    }
}
