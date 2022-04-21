//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation
import PropBank

public class EnglishPropbankLayer : SingleWordMultiItemLayer<Argument>{
    
    init(layerValue: String) {
        super.init()
        self.layerName = "englishPropbank"
        self.setLayerValue(layerValue: layerValue)
    }
    
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
