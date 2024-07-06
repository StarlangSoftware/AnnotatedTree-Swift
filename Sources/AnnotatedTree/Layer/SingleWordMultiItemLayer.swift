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
    
    /// Returns the property at position index for the word.
    /// - Parameter index: Position of the property
    /// - Returns: The property at position index for the word.
    public func getItemAt(index: Int) -> T?{
        if index < items.count{
            return items[index]
        } else {
            return nil
        }
    }
    
    /// Returns the total number of properties for the word in the node.
    /// - Parameter viewLayer: Not used.
    /// - Returns: Total number of properties for the word in the node.
    public func getLayerSize(viewLayer: ViewLayerType) -> Int{
        return items.count
    }

}
