//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 11.04.2022.
//

import Foundation

public class MultiWordLayer<T> : WordLayer{
    
    var items: [T] = []
    
    public func getItemAt(index: Int) -> T?{
        if index < items.count{
            return items[index]
        } else {
            return nil
        }
    }
    
    public func size() -> Int{
        return items.count
    }
    
}
