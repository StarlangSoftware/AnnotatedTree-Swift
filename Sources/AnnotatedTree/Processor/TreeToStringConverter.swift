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
    
    /// Constructor of the TreeToStringConverter class. Sets the attributes.
    /// - Parameters:
    ///   - parseTree: Parse tree to be converted.
    ///   - converter: Node to string converter interface.
    public init(parseTree: ParseTreeDrawable, converter: LeafToStringConverter){
        self.parseTree = parseTree
        self.converter = converter
    }
    
    /// Converts recursively a parse node to a string. If it is a leaf node, calls the converter's leafConverter method,
    /// otherwise concatenates the converted strings of its children.
    /// - Parameter parseNode: Parse node to convert to string.
    /// - Returns: String form of the parse node and all of its descendants.
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
    
    /// Calls the convertToString method with root of the tree to convert the parse tree to string.
    /// - Returns: String form of the parse tree.
    public func convert() -> String{
        return convertToString(parseNode: parseTree.getRoot() as! ParseNodeDrawable)
    }
}
