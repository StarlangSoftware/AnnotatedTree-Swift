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
    
    init(layerValue: String) {
        super.init()
        layerName = "propBank"
        setLayerValue(layerValue: layerValue)
    }
    
    public override func setLayerValue(layerValue: String) {
        self.layerValue = layerValue
        propbank = Argument(argument: layerValue)
    }
    
    public func getArgument() -> Argument?{
        return propbank
    }
    
    public override func getLayerValue() -> String {
        return propbank!.getArgumentType() + "$" + propbank!.getId()
    }
}
