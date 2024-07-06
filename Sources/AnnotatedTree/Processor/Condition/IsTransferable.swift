//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation
import AnnotatedSentence

public class IsTransferable : IsLeafNode{
    
    private var secondLanguage: ViewLayerType
    
    public init(secondLanguage: ViewLayerType){
        self.secondLanguage = secondLanguage
    }
    
    /// Checks if the node is a leaf node and is not a None or Null node.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the node is a leaf node and is not a None or Null node, false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            if IsNoneNode(secondLanguage: secondLanguage).satisfies(parseNode: parseNode){
                return false
            }
            return !IsNullElement().satisfies(parseNode: parseNode)
        }
        return false
    }
}
