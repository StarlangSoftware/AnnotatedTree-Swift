//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class TreeModifier{
    
    private var parseTree: ParseTreeDrawable
    private var nodeModifier: NodeModifier
    
    public init(parseTree: ParseTreeDrawable, nodeModifier: NodeModifier){
        self.parseTree = parseTree
        self.nodeModifier = nodeModifier
    }
    
    private func nodeModify(parseNode: ParseNodeDrawable){
        nodeModifier.modifier(parseNode: parseNode)
        for i in 0..<parseNode.numberOfChildren(){
            nodeModify(parseNode: parseNode.getChild(i: i) as! ParseNodeDrawable)
        }
    }
    
    public func modify(){
        nodeModify(parseNode: parseTree.getRoot() as! ParseNodeDrawable)
    }
}
