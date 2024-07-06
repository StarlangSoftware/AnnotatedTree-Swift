//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation
import AnnotatedSentence

public class IsNoneNode : IsLeafNode{
    private var secondLanguage: ViewLayerType
    
    public init(secondLanguage: ViewLayerType){
        self.secondLanguage = secondLanguage
    }
    
    /// Checks if the data of the parse node is '*NONE*'.
    /// - Parameter parseNode: Parse node to check.
    /// - Returns: True if the data of the parse node is '*NONE*', false otherwise.
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let data = parseNode.getLayerData(viewLayer: secondLanguage)
            return data != nil && data == "*NONE*"
        }
        return false
    }
}
