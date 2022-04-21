//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class DependencyLayer : SingleWordLayer<String>{
    
    init(layerValue: String) {
        super.init()
        self.layerName = "dependency"
        self.setLayerValue(layerValue: layerValue)
    }
}
