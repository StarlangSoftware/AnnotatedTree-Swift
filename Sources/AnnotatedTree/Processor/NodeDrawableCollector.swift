//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 19.04.2022.
//

import Foundation

public class NodeDrawableCollector{
    
    private var condition: NodeDrawableCondition?
    private var rootNode: ParseNodeDrawable
    
    public init(rootNode: ParseNodeDrawable, condition: NodeDrawableCondition?){
        self.rootNode = rootNode
        self.condition = condition
    }
    
    private func collectNodes(parseNode: ParseNodeDrawable, collected: inout [ParseNodeDrawable]){
        if condition == nil || condition!.satisfies(parseNode: parseNode){
            collected.append(parseNode)
        }
        for i in 0..<parseNode.numberOfChildren(){
            collectNodes(parseNode: parseNode.getChild(i: i) as! ParseNodeDrawable, collected: &collected)
        }
    }
    
    public func collect() -> [ParseNodeDrawable]{
        var result : [ParseNodeDrawable] = []
        collectNodes(parseNode: rootNode, collected: &result)
        return result
    }
}
