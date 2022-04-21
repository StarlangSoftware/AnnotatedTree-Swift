//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation
import AnnotatedSentence

public class SingleWordMultiItemLayer<T> : SingleWordLayer<T>{
    
    var items: [T] = []
    
    public func getItemAt(index: Int) -> T?{
        if index < items.count{
            return items[index]
        } else {
            return nil
        }
    }
    
    public func getLayerSize(viewLayer: ViewLayerType) -> Int{
        return items.count
    }

}
