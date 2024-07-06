//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation
import PropBank

public class TurkishPropbankLayer : SingleWordLayer<Argument>{
    
    private var propbank : Argument? = nil
    
    /// Constructor for the Turkish propbank layer. Sets single semantic role information for multiple words in
    /// the node.
    /// - Parameter layerValue: Layer value for the propbank information. Consists of semantic role information
    ///                   of multiple words.
    init(layerValue: String) {
        super.init()
        layerName = "propBank"
        setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the layer value for Turkish propbank layer. Converts the string form to an Argument.
    /// - Parameter layerValue: New value for Turkish propbank layer.
    public override func setLayerValue(layerValue: String) {
        self.layerValue = layerValue
        propbank = Argument(argument: layerValue)
    }
    
    /// Accessor for the propbank field.
    /// - Returns: Propbank field.
    public func getArgument() -> Argument?{
        return propbank
    }
    
    /// Another accessor for the propbank field.
    /// - Returns: String form of the propbank field.
    public override func getLayerValue() -> String {
        return propbank!.getArgumentType() + "$" + propbank!.getId()
    }
}
