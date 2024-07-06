//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class IsNumber : IsLeafNode{
    
    /// Checks if the node is a leaf node and contains numerals as the data and its parent has the tag CD.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is a leaf node and contains numerals as the data and its parent has the tag CD, false
    /// otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            var p : NSRegularExpression?
            let data = parseNode.getLayerData(viewLayer: .ENGLISH_WORD)
            let parentData = parseNode.getParent()?.getData()?.getName()
            do{
                p = try NSRegularExpression(pattern: "[0-9,.]+")
            } catch {
            }
            return parentData == "CD" && p!.matches(in: data!, range: NSRange(location: 0, length: data!.utf16.count)).count != 0
        }
        return false
    }
}
