//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation
import PropBank

public class EnglishPropbankLayer : SingleWordMultiItemLayer<Argument>{
    
    /// Constructor for the propbank layer for English language.
    /// - Parameter layerValue: Value for the English propbank layer.
    init(layerValue: String) {
        super.init()
        self.layerName = "englishPropbank"
        self.setLayerValue(layerValue: layerValue)
    }
    
    /// Sets the value for the propbank layer in a node. Value may consist of multiple propbank information separated via
    /// '#' character. Each propbank value consists of argumentType and id info separated via '$' character.
    /// - Parameter layerValue: New layer info
    public override func setLayerValue(layerValue: String?) {
        self.layerValue = layerValue!
        if layerValue != nil{
            let splitWords = layerValue?.split(separator: "#").map(String.init)
            for word in splitWords! {
                self.items.append(Argument(argument: word))
            }
        }
    }
}
