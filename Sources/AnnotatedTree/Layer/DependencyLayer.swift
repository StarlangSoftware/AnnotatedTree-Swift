//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class DependencyLayer : SingleWordLayer<String>{
    
    /// Constructor for the dependency layer. Dependency layer stores the dependency information of a node.
    /// - Parameter layerValue: Value of the dependency layer.
    init(layerValue: String) {
        super.init()
        self.layerName = "dependency"
        self.setLayerValue(layerValue: layerValue)
    }
}
