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
    
    public override init(data: Symbol){
        super.init(data: data)
    }
    
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
    
    public func getLayerInfo() -> LayerInfo{
        return layers!
    }
    
    public override func getData() -> Symbol? {
        if layers == nil{
            return super.getData()
        } else {
            return Symbol(name: getLayerData(viewLayer: .ENGLISH_WORD)!)
        }
    }
    
    public func clearLayers(){
        layers = LayerInfo()
    }
    
    public func clearLayer(layerType: ViewLayerType){
        if children.count == 0 && layerExists(viewLayerType: layerType){
            layers?.removeLayer(layerType: layerType)
        }
        for i in 0..<numberOfChildren(){
            (children[i] as! ParseNodeDrawable).clearLayer(layerType: layerType)
        }
    }
    
    public func clearData(){
        data = nil
    }
    
    public func setDataAndClearLayers(data: Symbol){
        super.setData(data: data)
        layers = nil
    }
    
    public func getInOrderTraversalIndex() -> Int{
        return inOrderTraversalIndex
    }
    
    public override func setData(data: Symbol) {
        if layers == nil{
            super.setData(data: data)
        } else {
            layers?.setLayerData(viewLayer: .ENGLISH_WORD, layerValue: data.getName())
        }
    }
    
    public func headWord(viewLayerType: ViewLayerType) -> String{
        if children.count > 0{
            return (headChild() as! ParseNodeDrawable).headWord(viewLayerType: viewLayerType)
        } else {
            return getLayerData(viewLayer: viewLayerType)!
        }
    }
    
    public func getLayerData() -> String{
        if data != nil{
            return (data?.getName())!
        }
        return (layers?.getLayerDescription())!
    }
    
    public func getLayerData(viewLayer: ViewLayerType) -> String?{
        if viewLayer == .WORD || layers == nil{
            return data?.getName()
        }
        return layers?.getLayerData(viewLayer: viewLayer)
    }
    
    public func getLeafIndex() -> Int{
        return leafIndex
    }
    
    public func getDepth() -> Int{
        return depth
    }
    
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
    
    public func updateDepths(depth: Int){
        self.depth = depth
        for aChildren in children{
            let aChild = aChildren as! ParseNodeDrawable
            aChild.updateDepths(depth: depth + 1)
        }
    }
    
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
    
    public func getArea() -> RectAngle{
        return area!
    }
    
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
    
    public func getChildrenSymbols() -> [Symbol]{
        var childrenSymbols : [Symbol] = []
        for aChildren in children{
            let aChild = aChildren as! ParseNodeDrawable
            childrenSymbols.append(aChild.getData()!)
        }
        return childrenSymbols
    }
    
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
    
    public func extractTags(tagList: inout [String]){
        if numberOfChildren() != 0{
            tagList.append((getData()?.getName())!)
        }
        for i in 0..<numberOfChildren(){
            (getChild(i: i) as! ParseNodeDrawable).extractTags(tagList: &tagList)
        }
    }
    
    public func extractNumberOfChildren(childNumberList: inout [Int]){
        if numberOfChildren() != 0{
            childNumberList.append(numberOfChildren())
        }
        for i in 0..<numberOfChildren(){
            (getChild(i: i) as! ParseNodeDrawable).extractNumberOfChildren(childNumberList: &childNumberList)
        }
    }

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
    
    public func checkGazetteer(gazetteer: Gazetteer, word: String){
        if gazetteer.contains(word: word) && getParent()?.getData()?.getName() == "NNP"{
            getLayerInfo().setLayerData(viewLayer: .NER, layerValue: gazetteer.getName())
        }
        if word.contains("'") && getParent()?.getData()?.getName() == "NNP" &&
            gazetteer.contains(word: String(word[..<word.range(of: " ")!.lowerBound])){
            getLayerInfo().setLayerData(viewLayer: .NER, layerValue: gazetteer.getName())
            }
    }
    
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
    
    public func setArea(x: Int, y: Int, width: Int, height: Int){
        area = RectAngle(x: x, y: y, width: width, height: height)
    }
}
