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
    
    /// Constructor for the NodeDrawableCollector class. NodeDrawableCollector's main aim is to collect a set of
    /// ParseNode's from a subtree rooted at rootNode, where the ParseNode's satisfy a given NodeCondition, which is
    /// implemented by other interface class.
    /// - Parameters:
    ///   - rootNode: Root node of the subtree
    ///   - condition: The condition interface for which all nodes in the subtree rooted at rootNode will be checked
    public init(rootNode: ParseNodeDrawable, condition: NodeDrawableCondition?){
        self.rootNode = rootNode
        self.condition = condition
    }
    
    /// Private recursive method to check all descendants of the parseNode, if they ever satisfy the given node condition
    /// - Parameters:
    ///   - parseNode: Root node of the subtree
    ///   - collected: The {@link ArrayList} where the collected ParseNode's will be stored.
    private func collectNodes(parseNode: ParseNodeDrawable, collected: inout [ParseNodeDrawable]){
        if condition == nil || condition!.satisfies(parseNode: parseNode){
            collected.append(parseNode)
        }
        for i in 0..<parseNode.numberOfChildren(){
            collectNodes(parseNode: parseNode.getChild(i: i) as! ParseNodeDrawable, collected: &collected)
        }
    }
    
    /// Collects and returns all ParseNodes satisfying the node condition.
    /// - Returns: All ParseNodes satisfying the node condition.
    public func collect() -> [ParseNodeDrawable]{
        var result : [ParseNodeDrawable] = []
        collectNodes(parseNode: rootNode, collected: &result)
        return result
    }
}
