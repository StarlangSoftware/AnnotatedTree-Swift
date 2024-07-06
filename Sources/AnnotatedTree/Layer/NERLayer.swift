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
    
    /// Constructor for the named entity layer. Sets single named entity information for multiple words in
    /// the node.
    /// - Parameter layerValue: Layer value for the named entity information. Consists of single named entity information of multiple words.
    init(layerValue: String){
        super.init()
        layerName = "namedEntity"
        setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the layer value for Named Entity layer. Converts the string form to a named entity.
    /// - Parameter layerValue: New value for Named Entity layer.
    public override func setLayerValue(layerValue: String?) {
        self.layerValue = layerValue!
        namedEntity = NamedEntityTypeStatic.getNamedEntityType(entityType: layerValue!)
    }
    
    /// Get the string form of the named entity value. Converts named entity type to string form.
    /// - Returns: String form of the named entity value.
    public override func getLayerValue() -> String {
        return NamedEntityTypeStatic.getNamedEntityString(namedEntityType: namedEntity!)
    }
}
