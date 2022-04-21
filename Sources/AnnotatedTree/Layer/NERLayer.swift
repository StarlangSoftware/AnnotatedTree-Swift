//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation
import NamedEntityRecognition

public class NERLayer : SingleWordLayer<NamedEntityType>{
    
    private var namedEntity : NamedEntityType? = nil
    
    init(layerValue: String){
        super.init()
        layerName = "namedEntity"
        setLayerValue(layerValue: layerValue)
    }
    
    public override func setLayerValue(layerValue: String?) {
        self.layerValue = layerValue!
        namedEntity = NamedEntityTypeStatic.getNamedEntityType(entityType: layerValue!)
    }
    
    public override func getLayerValue() -> String {
        return NamedEntityTypeStatic.getNamedEntityString(namedEntityType: namedEntity!)
    }
}
