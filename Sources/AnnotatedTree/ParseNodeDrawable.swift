//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 16.04.2022.
//

import Foundation
import ParseTree
import Util
import Dictionary
import AnnotatedSentence
import NamedEntityRecognition

public class ParseNodeDrawable : ParseNode{
    
    public var layers : LayerInfo? = nil
    var leafIndex : Int = -1
    var depth : Int = 0
    var area : RectAngle? = nil
    var inOrderTraversalIndex : Int = -1;
    let sentenceLabels : [String] = ["SINV", "SBARQ", "SBAR", "SQ", "S"]
    
    /// Constructs a ParseNodeDrawable from a single line. If the node is a leaf node, it only sets the data. Otherwise,
    /// splits the line w.r.t. spaces and parenthesis and calls itself recursively to generate its child parseNodes.
    /// - Parameters:
    ///   - parent: The parent node of this node.
    ///   - line: The input line to create this parseNode.
    ///   - isLeaf: True, if this node is a leaf node; false otherwise.
    ///   - depth: Depth of the node.
    public init(parent: ParseNodeDrawable?, line: String, isLeaf: Bool, depth: Int){
        super.init()
        var parenthesisCount : Int = 0
        var childLine : String = ""
        self.depth = depth
        self.parent = parent
        self.children = []
        if isLeaf{
            if !line.contains("{"){
                data = Symbol(name: line)
            } else {
                layers = LayerInfo(info: line)
            }
        } else {
            data = Symbol(name: String(line[line.index(line.startIndex, offsetBy: 1)..<line.range(of: " ")!.lowerBound]))
            if line.firstIndex(of: ")") == line.lastIndex(of: ")") {
                let start = line.index(line.firstIndex(of: " ")!, offsetBy: 1)
                let end = line.firstIndex(of: ")")!
                children.append(ParseNodeDrawable(parent: self, line: String(line[start..<end]), isLeaf: true, depth: depth + 1))
            } else {
                let emptyIndex = Int(line.distance(from: line.startIndex, to: line.firstIndex(of: " ")!))
                for i in emptyIndex + 1..<line.count {
                    if Word.charAt(s: line, i: i) != " " || parenthesisCount > 0 {
                        childLine = childLine + String(Word.charAt(s: line, i: i))
                    }
                    if Word.charAt(s: line, i: i) == "(" {
                        parenthesisCount += 1
                    } else {
                        if Word.charAt(s: line, i: i) == ")" {
                            parenthesisCount -= 1
                        }
                    }
                    if parenthesisCount == 0 && childLine != "" {
                        children.append(ParseNodeDrawable(parent: self, line: childLine.trimmingCharacters(in: .whitespacesAndNewlines), isLeaf: false, depth: depth + 1))
                        childLine = ""
                    }
                }
            }
        }
    }
    
    /// Another simple constructor for ParseNode. It only takes input the data, and sets it.
    /// - Parameter data: Data for this node.
    public override init(data: Symbol){
        super.init(data: data)
    }
    
    /// Another constructor for ParseNodeDrawable. Sets the parent to the given parent, and adds given child as a
    /// single child, and sets the given symbol as data.
    /// - Parameters:
    ///   - parent: Parent of this node.
    ///   - child: Single child of this node.
    ///   - symbol: Symbol of this node.
    public init(parent: ParseNodeDrawable, child: ParseNodeDrawable, symbol: String){
        super.init()
        children = []
        depth = child.depth
        child.updateDepths(depth: depth + 1)
        self.parent = parent
        self.parent?.setChild(index: parent.getChildIndex(child: child), child: self)
        children.append(child)
        child.parent = self
        data = Symbol(name: symbol)
        inOrderTraversalIndex = child.inOrderTraversalIndex
    }
    
    /// Accessor for layers attribute
    /// - Returns: Layers attribute
    public func getLayerInfo() -> LayerInfo{
        return layers!
    }
    
    /// Returns the data. Either the node is a leaf node, in which case English word layer is returned; or the node is
    /// a nonleaf node, in which case the node tag is returned.
    /// - Returns: English word for leaf node, constituency tag for non-leaf node.
    public override func getData() -> Symbol? {
        if layers == nil{
            return super.getData()
        } else {
            return Symbol(name: getLayerData(viewLayer: .ENGLISH_WORD)!)
        }
    }
    
    /// Clears the layers hash map.
    public func clearLayers(){
        layers = LayerInfo()
    }
    
    /// Recursive method to clear a given layer.
    /// - Parameter layerType: Name of the layer to be cleared
    public func clearLayer(layerType: ViewLayerType){
        if children.count == 0 && layerExists(viewLayerType: layerType){
            layers?.removeLayer(layerType: layerType)
        }
        for i in 0..<numberOfChildren(){
            (children[i] as! ParseNodeDrawable).clearLayer(layerType: layerType)
        }
    }
    
    /// Clears the node tag.
    public func clearData(){
        data = nil
    }
    
    /// Setter for the data attribute and also clears all layers.
    /// - Parameter data: New data field.
    public func setDataAndClearLayers(data: Symbol){
        super.setData(data: data)
        layers = nil
    }
    
    /// Accessor for inOrderTraversalIndex attribute
    /// - Returns: InOrderTraversalIndex attribute.
    public func getInOrderTraversalIndex() -> Int{
        return inOrderTraversalIndex
    }
    
    /// Mutator for the data field. If the layers is null, its sets the data field, otherwise it sets the English layer
    /// to the given value.
    /// - Parameter data: Data to be set.
    public override func setData(data: Symbol) {
        if layers == nil{
            super.setData(data: data)
        } else {
            layers?.setLayerData(viewLayer: .ENGLISH_WORD, layerValue: data.getName())
        }
    }
    
    /// Returns the layer value of the head child of this node.
    /// - Parameter viewLayerType: Layer name
    /// - Returns: Layer value of the head child of this node.
    public func headWord(viewLayerType: ViewLayerType) -> String{
        if children.count > 0{
            return (headChild() as! ParseNodeDrawable).headWord(viewLayerType: viewLayerType)
        } else {
            return getLayerData(viewLayer: viewLayerType)!
        }
    }
    
    /// Accessor for the data or layers attribute.
    /// - Returns: If data is not null, this node is a non-leaf node, it returns the data field. Otherwise, this node is a
    /// leaf node, it returns the layer description.
    public func getLayerData() -> String{
        if data != nil{
            return (data?.getName())!
        }
        return (layers?.getLayerDescription())!
    }
    
    /// Returns the layer value of a given layer.
    /// - Parameter viewLayer: Layer name
    /// - Returns: Value of the given layer
    public func getLayerData(viewLayer: ViewLayerType) -> String?{
        if viewLayer == .WORD || layers == nil{
            return data?.getName()
        }
        return layers?.getLayerData(viewLayer: viewLayer)
    }
    
    /// Accessor for the leafIndex attribute
    /// - Returns: LeafIndex attribute
    public func getLeafIndex() -> Int{
        return leafIndex
    }
    
    /// Accessor for the depth attribute
    /// - Returns: Depth attribute
    public func getDepth() -> Int{
        return depth
    }
    
    /// Recursive setter method for the leafIndex attribute. LeafIndex shows the index of the leaf node according to the
    /// inorder traversal without considering non-leaf nodes.
    /// - Parameter pos: Current leaf index
    /// - Returns: Updated leaf index
    public func leafTraversal(pos: Int) -> Int{
        var currentPos : Int = pos
        if children.count == 0{
            currentPos = currentPos + 1
            leafIndex = currentPos
        }
        for i in 0..<children.count{
            currentPos = (children[i] as! ParseNodeDrawable).leafTraversal(pos: currentPos)
        }
        return currentPos
    }
    
    /// Recursive setter method for the inOrderTraversalIndex attribute. InOrderTraversalIndex shows the index of the
    /// node according to the inorder traversal.
    /// - Parameter pos: Current inorder traversal index
    /// - Returns: Update inorder traversal index
    public func inOrderTraversal(pos: Int) -> Int{
        var currentPos : Int = pos
        for i in 0..<children.count / 2{
            currentPos = (children[i] as! ParseNodeDrawable).inOrderTraversal(pos: currentPos)
        }
        inOrderTraversalIndex = currentPos
        if children.count % 2 != 1{
            currentPos = currentPos + 1
        }
        for i in children.count / 2..<children.count{
            currentPos = (children[i] as! ParseNodeDrawable).leafTraversal(pos: currentPos)
        }
        return currentPos
    }
    
    /// Returns the maximum inorder traversal index considering this node and all of its descendants.
    /// - Returns: The maximum inorder traversal index considering this node and all of its descendants.
    public func maxInOrderTraversal() -> Int{
        if children.count == 0{
            return inOrderTraversalIndex
        } else {
            var maxIndex : Int = inOrderTraversalIndex
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                let childIndex = aChild.maxInOrderTraversal()
                if childIndex > maxIndex{
                    maxIndex = childIndex
                }
            }
            return maxIndex
        }
    }
    
    /// Recursive method which updates the depth attribute
    /// - Parameter depth: Current depth to set.
    public func updateDepths(depth: Int){
        self.depth = depth
        for aChildren in children{
            let aChild = aChildren as! ParseNodeDrawable
            aChild.updateDepths(depth: depth + 1)
        }
    }
    
    /// Calculates the maximum depth of the subtree rooted from this node.
    /// - Returns: The maximum depth of the subtree rooted from this node.
    public func maxDepth() -> Int{
        var depth : Int = self.depth
        for aChildren in children{
            let aChild = aChildren as! ParseNodeDrawable
            if aChild.maxDepth() > depth{
                depth = aChild.maxDepth()
            }
        }
        return depth
    }
    
    /// Accessor for the area attribute.
    /// - Returns: Area attribute.
    public func getArea() -> RectAngle{
        return area!
    }
    
    /// Recursive method that updates all pos tags in the leaf nodes according to the morphological tag in those leaf
    /// nodes.
    public func updatePosTags(){
        if children.count == 1 && children[0].isLeaf() && !children[0].isDummyNode(){
            let layerInfo = (children[0] as! ParseNodeDrawable).getLayerInfo()
            let morphologicalParse = layerInfo.getMorphologicalParseAt(index: layerInfo.getNumberOfWords() - 1)
            let symbol = morphologicalParse?.getTreePos()
            setData(data: Symbol(name: symbol!))
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                aChild.updatePosTags()
            }
        }
    }
    
    /// Returns all symbols in this node.
    /// - Returns: All symbols in the children of this node.
    public func getChildrenSymbols() -> [Symbol]{
        var childrenSymbols : [Symbol] = []
        for aChildren in children{
            let aChild = aChildren as! ParseNodeDrawable
            childrenSymbols.append(aChild.getData()!)
        }
        return childrenSymbols
    }
    
    /// Recursive method that returns the concatenation of all pos tags of all descendants of this node.
    /// - Returns: The concatenation of all pos tags of all descendants of this node.
    public override func ancestorString() -> String {
        if parent == nil{
            return (data?.getName())!
        } else {
            if layers == nil{
                return (parent?.ancestorString())! + (data?.getName())!
            } else {
                return (parent?.ancestorString())! + (layers?.getLayerData(viewLayer: .ENGLISH_WORD))!
            }
        }
    }
    
    /// Recursive method that checks if all nodes in the subtree rooted with this node has the annotation in the given
    /// layer.
    /// - Parameter viewLayerType: Layer name
    /// - Returns: True if all nodes in the subtree rooted with this node has the annotation in the given layer, false
    /// otherwise.
    public func layerExists(viewLayerType: ViewLayerType) -> Bool{
        if children.count == 0{
            if getLayerData(viewLayer: viewLayerType) != nil{
                return true
            }
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                if aChild.layerExists(viewLayerType: viewLayerType){
                    return true
                }
            }
        }
        return false
    }
    
    /// Checks if the current node is a dummy node or not. A node is a dummy node if its data contains '*', or its
    /// data is '0' and its parent is '-NONE-'.
    /// - Returns: True if the current node is a dummy node, false otherwise.
    public override func isDummyNode() -> Bool {
        let data = getLayerData(viewLayer: .ENGLISH_WORD)
        let parentData = (parent as! ParseNodeDrawable).getLayerData(viewLayer: .ENGLISH_WORD)
        let targetData = getLayerData(viewLayer: .TURKISH_WORD)
        if data != nil && parentData != nil{
            if targetData != nil && ((targetData?.contains("*")) != nil){
                return true
            }
            return (data?.contains("*"))! || (data == "0" && parentData == "-NONE-")
        } else {
            return false
        }
    }
    
    /// Checks if all nodes in the subtree rooted with this node has annotation with the given layer.
    /// - Parameter viewLayerType: Layer name
    /// - Returns: True if all nodes in the subtree rooted with this node has annotation with the given layer, false
    /// otherwise.
    public func layerAll(viewLayerType: ViewLayerType) -> Bool{
        if children.count == 0{
            if getLayerData(viewLayer: viewLayerType) == nil && !isDummyNode(){
                return false
            }
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                if !aChild.layerAll(viewLayerType: viewLayerType){
                    return false
                }
            }
        }
        return true
    }
    
    /// Recursive method that accumulates all tag symbols in the descendants of this node in the tagList.
    /// - Parameter tagList: Array of strings to store the tag symbols.
    public func extractTags(tagList: inout [String]){
        if numberOfChildren() != 0{
            tagList.append((getData()?.getName())!)
        }
        for i in 0..<numberOfChildren(){
            (getChild(i: i) as! ParseNodeDrawable).extractTags(tagList: &tagList)
        }
    }
    
    /// Recursive method that accumulates number of children of all descendants of this node in the childNumberList.
    /// - Parameter childNumberList: Array of integers to store the number of children
    public func extractNumberOfChildren(childNumberList: inout [Int]){
        if numberOfChildren() != 0{
            childNumberList.append(numberOfChildren())
        }
        for i in 0..<numberOfChildren(){
            (getChild(i: i) as! ParseNodeDrawable).extractNumberOfChildren(childNumberList: &childNumberList)
        }
    }
    
    /// Recursive method to convert the subtree rooted with this node to a string. All parenthesis types are converted to
    /// their regular forms.
    /// - Returns: String version of the subtree rooted with this node.
    public func toTurkishSentence() -> String{
        if children.count == 0{
            if getLayerData(viewLayer: .TURKISH_WORD) != nil && getLayerData(viewLayer: .TURKISH_WORD) != "*NONE*"{
                return " " + (getLayerData(viewLayer: .TURKISH_WORD)?.replacingOccurrences(of: "-LRB-", with: "(").replacingOccurrences(of: "-RRB-", with: ")").replacingOccurrences(of: "-LSB-", with: "[").replacingOccurrences(of: "-RSB-", with: "]").replacingOccurrences(of: "-LCB-", with: "{").replacingOccurrences(of: "-RCB-", with: "}").replacingOccurrences(of: "-lrb-", with: "(").replacingOccurrences(of: "-rrb-", with: ")").replacingOccurrences(of: "-lsb-", with: "[").replacingOccurrences(of: "-rsb-", with: "]").replacingOccurrences(of: "-lcb-", with: "{").replacingOccurrences(of: "-rcb-", with: "}"))!
            } else {
                return " "
            }
        } else {
            var st: String = ""
            for aChild in children{
                st = st + " " + (aChild as! ParseNodeDrawable).toTurkishSentence()
            }
            return st
        }
    }
    
    /// Sets the NER layer according to the tag of the parent node and the word in the node. The word is searched in the
    /// gazetteer, if it exists, the NER info is replaced with the NER tag in the gazetter.
    /// - Parameters:
    ///   - gazetteer: Gazetteer where we search the word
    ///   - word: Word to be searched in the gazetteer
    public func checkGazetteer(gazetteer: Gazetteer, word: String){
        if gazetteer.contains(word: word) && getParent()?.getData()?.getName() == "NNP"{
            getLayerInfo().setLayerData(viewLayer: .NER, layerValue: gazetteer.getName())
        }
        if word.contains("'") && getParent()?.getData()?.getName() == "NNP" &&
            gazetteer.contains(word: String(word[..<word.range(of: " ")!.lowerBound])){
            getLayerInfo().setLayerData(viewLayer: .NER, layerValue: gazetteer.getName())
            }
    }
    
    /// Recursive method that sets the tag information of the given parse node with all descendants with respect to the
    /// morphological annotation of the current node with all descendants.
    /// - Parameters:
    ///   - parseNode: Parse node whose tag information will be changed.
    ///   - surfaceForm: If true, tag will be replaced with the surface form annotation.
    public func generateParseNode(parseNode: ParseNode, surfaceForm: Bool){
        if numberOfChildren() == 0{
            if surfaceForm{
                parseNode.setData(data: Symbol(name: getLayerData(viewLayer: .TURKISH_WORD)!))
            } else {
                parseNode.setData(data: Symbol(name: (getLayerInfo().getMorphologicalParseAt(index: 0)?.getWord().getName())!))
            }
        } else {
            parseNode.setData(data: data!)
            for i in 0..<numberOfChildren(){
                let newChild = ParseNode()
                parseNode.addChild(child: newChild)
                (children[i] as! ParseNodeDrawable).generateParseNode(parseNode: newChild, surfaceForm: surfaceForm)
            }
        }
    }
    
    /// Recursive method to convert the subtree rooted with this node to a string.
    /// - Returns: String version of the subtree rooted with this node.
    public override func description() -> String {
        if children.count < 2{
            if children.count < 1{
                return getLayerData()
            } else {
                return "(" + data!.getName() + " " + children[0].description() + ")"
            }
        } else {
            var st : String = "(" + (data?.getName())!
            for aChild in children{
                st = st + " " + aChild.description()
            }
            return st + ")"
        }
    }
    
    /// Returns the leaf node at position index in the subtree rooted with this node.
    /// - Parameter index: Position of the leaf node.
    /// - Returns: The leaf node at position index in the subtree rooted with this node.
    public func getLeafWithIndex(index: Int) -> ParseNodeDrawable?{
        if children.count == 0 && leafIndex == index{
            return self
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                let result = aChild.getLeafWithIndex(index: index)
                if result != nil{
                    return result
                }
            }
            return nil
        }
    }
    
    /// Returns the index of the layer data in the given x and y coordinates in the panel that displays the annotated
    /// tree.
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: Index of the layer data in the given x and y coordinates in the panel that displays the annotated tree.
    public func getSubItemAt(x: Int, y: Int) -> Int{
        if (area?.contains(x: x, y: y))! && children.count == 0{
            return (y - (area?.getY())!) / 20
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                let result = aChild.getSubItemAt(x: x, y: y)
                if result != -1{
                    return result
                }
            }
            return -1
        }
    }
    
    /// Returns the parse node in the given x and y coordinates in the panel that displays the annotated tree.
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: The parse node in the given x and y coordinates in the panel that displays the annotated tree.
    public func getNodeAt(x: Int, y: Int) -> ParseNodeDrawable?{
        if (area?.contains(x: x, y: y))!{
            return self
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                let result = aChild.getNodeAt(x: x, y: y)
                if result != nil{
                    return result
                }
            }
            return nil
        }
    }
    
    /// Returns the leaf node in the given x and y coordinates in the panel that displays the annotated tree.
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: The leaf node in the given x and y coordinates in the panel that displays the annotated tree.
    public func getLeafNodeAt(x: Int, y: Int) -> ParseNodeDrawable?{
        if (area?.contains(x: x, y: y))! && children.count == 0{
            return self
        } else {
            for aChildren in children{
                let aChild = aChildren as! ParseNodeDrawable
                let result = aChild.getLeafNodeAt(x: x, y: y)
                if result != nil{
                    return result
                }
            }
            return nil
        }
    }
    
    /// Mutator for the area attribute
    /// - Parameters:
    ///   - x: New x coordinate of the area
    ///   - y: New y coordinate of the area
    ///   - width: New width of the area
    ///   - height: New height of the area
    public func setArea(x: Int, y: Int, width: Int, height: Int){
        area = RectAngle(x: x, y: y, width: width, height: height)
    }
}
