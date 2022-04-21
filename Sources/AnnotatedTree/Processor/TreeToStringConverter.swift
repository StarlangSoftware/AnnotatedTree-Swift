//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class TreeToStringConverter{
    
    private var converter: LeafToStringConverter
    private var parseTree: ParseTreeDrawable
    
    public init(parseTree: ParseTreeDrawable, converter: LeafToStringConverter){
        self.parseTree = parseTree
        self.converter = converter
    }
    
    private func convertToString(parseNode: ParseNodeDrawable) -> String{
        if parseNode.isLeaf(){
            return converter.leafConverter(leafNode: parseNode)
        } else {
            var st : String = ""
            for i in 0..<parseNode.numberOfChildren(){
                st = st + convertToString(parseNode: parseNode.getChild(i: i) as! ParseNodeDrawable)
            }
            return st
        }
    }
    
    public func convert() -> String{
        return convertToString(parseNode: parseTree.getRoot() as! ParseNodeDrawable)
    }
}
