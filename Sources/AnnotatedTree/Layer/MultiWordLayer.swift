//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class MultiWordLayer<T> : WordLayer{
    
    var items: [T] = []
    
    /// Returns the item (word or its property) at position index.
    /// - Parameter index: Position of the item (word or its property).
    /// - Returns: The item at position index.
    public func getItemAt(index: Int) -> T?{
        if index < items.count{
            return items[index]
        } else {
            return nil
        }
    }
    
    /// Returns number of items (words) in the items array list.
    /// - Returns: Number of items (words) in the items array list.
    public func size() -> Int{
        return items.count
    }
    
}
