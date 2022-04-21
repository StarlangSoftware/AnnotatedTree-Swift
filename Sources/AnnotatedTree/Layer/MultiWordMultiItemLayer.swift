//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation
import AnnotatedSentence

public class MultiWordMultiItemLayer<T> : MultiWordLayer<T>{
    
    public func getLayerSize(viewLayer: ViewLayerType) -> Int{
        return 0
    }
    
    public func getLayerInfoAt(viewLayer: ViewLayerType, index: Int) -> String?{
        return ""
    }
}
