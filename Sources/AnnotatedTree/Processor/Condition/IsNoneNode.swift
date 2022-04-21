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
    
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let data = parseNode.getLayerData(viewLayer: secondLanguage)
            return data != nil && data == "*NONE*"
        }
        return false
    }
}
