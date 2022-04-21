//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class TurkishWordLayer : TargetLanguageWordLayer{
    
    override init(layerValue: String) {
        super.init(layerValue: layerValue)
        layerName = "turkish"
    }
}
