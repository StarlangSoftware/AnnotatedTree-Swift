//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public class TurkishSemanticLayer : MultiWordLayer<String>{
    
    /// Constructor for the Turkish semantic layer. Sets semantic information for each word in
    /// the node.
    /// - Parameter layerValue: Layer value for the Turkish semantic information. Consists of semantic (Turkish synset id)
    ///                   information for every word.
    init(layerValue: String){
        super.init()
        layerName = "semantics"
        setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the value for the Turkish semantic layer in a node. Value may consist of multiple sense information
    /// separated via '$' character. Each sense value is a string representing the synset id of the sense.
    /// - Parameter layerValue: New layer info
    public func setLayerValue(layerValue: String?){
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitMeanings = layerValue?.split(separator: "$").map(String.init)
            items.append(contentsOf: splitMeanings!)
        }
    }
}
