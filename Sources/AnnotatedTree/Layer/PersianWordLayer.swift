//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class PersianWordLayer : TargetLanguageWordLayer{
    
    override init(layerValue: String){
        super.init(layerValue: layerValue)
        layerName = "persian"
    }
}
