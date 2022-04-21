//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 12.04.2022.
//

import Foundation

public class EnglishSemanticLayer : SingleWordLayer<String>{
    
    init(layerValue: String) {
        super.init()
        self.layerName = "englishSemantics"
        setLayerValue(layerValue: layerValue)
    }
}
