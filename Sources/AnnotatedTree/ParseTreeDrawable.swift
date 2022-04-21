//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 17.04.2022.
//

import Foundation
import ParseTree
import Corpus
import AnnotatedSentence
import PropBank
import WordNet

public class ParseTreeDrawable : ParseTree{
    
    private var fileDescription: FileDescription = FileDescription(path: "", extensionOrFileName: "0000.train")
    private var maxInOrderTraversalIndex: Int = -1
    private var name: String = ""
    
    init(fileDescription: FileDescription){
        super.init()
        self.fileDescription = fileDescription
        readFromFile(url: URL(string: fileDescription.getPath())!)
    }

    override init(){
        super.init()
    }
    
    override init(url: URL){
        super.init()
        readFromFile(url: url)
    }

    convenience init(path: String, rawFileName: String){
        self.init(fileDescription: FileDescription(path: path, extensionOrFileName: rawFileName))
    }
    
    convenience init(path: String, extensionOfFile: String, index: Int){
        self.init(fileDescription: FileDescription(path: path, extensionOrFileName: extensionOfFile, index: index))
    }
    
    convenience init(path: String, fileDescription: FileDescription){
        self.init(fileDescription: FileDescription(path: path, extensionOrFileName: fileDescription.getExtension(), index: fileDescription.getIndex()))
    }
    
    public func setFileDescription(fileDescription: FileDescription){
        self.fileDescription = fileDescription
    }
    
    public func getFileDescription() -> FileDescription{
        return self.fileDescription
    }
    
    public func copyInfo(parseTree: ParseTreeDrawable){
        self.fileDescription = parseTree.fileDescription
    }
    
    public func reload(){
        readFromFile(url: URL(string: fileDescription.getPath())!)
    }
    
    public func setRoot(newRootNode: ParseNode){
        root = newRootNode
    }
    
    public func readFromFile(url: URL){
        do{
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            let lines : [String] = fileContent.split(whereSeparator: \.isNewline).map(String.init)
            let line = lines[0]
            if line.contains("(") && line.contains(")") {
                let start = line.index(line.firstIndex(of: "(")!, offsetBy: 1)
                let end = line.lastIndex(of: ")")!
                root = ParseNodeDrawable(parent: nil, line: String(line[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines), isLeaf: false, depth: 0)
            }
        }catch{
        }
    }
    
    private func updateTraversalIndexes(){
        (root as! ParseNodeDrawable).inOrderTraversal(pos: 0)
        (root as! ParseNodeDrawable).leafTraversal(pos: 0)
        maxInOrderTraversalIndex = (root as! ParseNodeDrawable).maxInOrderTraversal()
    }
    
    public func getMaxInOrderTraversalIndex() -> Int{
        return maxInOrderTraversalIndex
    }
    
    public func setName(name: String){
        self.name = name
    }

    public func getName() -> String{
        return name
    }
    
    public func nextTree(count: Int){
        if fileDescription.nextFileExists(count: count){
            fileDescription.addToIndex(count: count)
            reload()
        }
    }

    public func previousTree(count: Int){
        if fileDescription.previousFileExists(count: count){
            fileDescription.addToIndex(count: -count)
            reload()
        }
    }
    
    public func updatePosTags(){
        (root as! ParseNodeDrawable).updatePosTags()
    }
    
    public func maxDepth() -> Int{
        return (root as! ParseNodeDrawable).maxDepth()
    }
    
    public func moveLeft(node: ParseNode){
        if root != node{
            root?.moveLeft(node: node)
            updateTraversalIndexes()
        }
    }
    
    public func moveRight(node: ParseNode){
        if root != node{
            root?.moveRight(node: node)
            updateTraversalIndexes()
        }
    }
    
    public func moveNode(fromNode: ParseNode, toNode: ParseNode){
        if root != fromNode{
            let parent = fromNode.getParent()
            parent?.removeChild(child: fromNode)
            toNode.addChild(child: fromNode)
            updateTraversalIndexes()
            (root as! ParseNodeDrawable).updateDepths(depth: 0)
        }
    }
    
    public func moveNode(fromNode: ParseNode, toNode: ParseNode, childIndex: Int){
        if root != fromNode{
            let parent = fromNode.getParent()
            parent?.removeChild(child: fromNode)
            toNode.addChild(index: childIndex, child: fromNode)
            updateTraversalIndexes()
            (root as! ParseNodeDrawable).updateDepths(depth: 0)
        }
    }
    
    public func combineWords(parent: ParseNodeDrawable, child: ParseNodeDrawable){
        while parent.numberOfChildren() > 0{
            parent.removeChild(child: parent.firstChild())
        }
        parent.addChild(child: child)
        updateTraversalIndexes()
        (root as! ParseNodeDrawable).updateDepths(depth: 0)
    }
    
    public func layerExists(viewLayerType: ViewLayerType) -> Bool{
        return (root as! ParseNodeDrawable).layerExists(viewLayerType: viewLayerType)
    }
    
    public func layerAll(viewLayerType: ViewLayerType) -> Bool{
        return (root as! ParseNodeDrawable).layerAll(viewLayerType: viewLayerType)
    }
    
    public func getPredicateSynSets(framesetList: FramesetList) -> Set<Frameset>{
        var synSets : Set<Frameset> = Set()
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsTurkishLeafNode())
        let leafList = nodeDrawableCollector.collect()
        for leafNode in leafList{
            let argument = leafNode.getLayerInfo().getArgument()
            if argument != nil && argument?.getArgumentType() == "PREDICATE"{
                if framesetList.frameExists(synSetId: leafNode.getLayerInfo().getArgument()!.getId()){
                    synSets.insert(framesetList.getFrameSet(synSetId: leafNode.getLayerInfo().getArgument()!.getId())!)
                }
            }
        }
        return synSets
    }
    
    public func updateConnectedPredicate(previousId: String, currentId: String) -> Bool{
        var modified: Bool = false
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsTurkishLeafNode())
        let leafList = nodeDrawableCollector.collect()
        for parseNode in leafList{
            if parseNode.getLayerInfo().getArgument() != nil &&  parseNode.getLayerInfo().getArgument()!.getId() == previousId{
                parseNode.getLayerInfo().setLayerData(viewLayer: .PROPBANK, layerValue: parseNode.getLayerInfo().getArgument()!.getArgumentType() + "$" + currentId)
                modified = true
            }
        }
        return modified
    }
    
    public func nextLeafNode(parseNode: ParseNodeDrawable) -> ParseNodeDrawable? {
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsTurkishLeafNode())
        let leafList = nodeDrawableCollector.collect()
        for i in 0..<leafList.count - 1{
            if leafList[i] == parseNode{
                return leafList[i + 1]
            }
        }
        return nil
    }

    public func previousLeafNode(parseNode: ParseNodeDrawable) -> ParseNodeDrawable? {
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsTurkishLeafNode())
        let leafList = nodeDrawableCollector.collect()
        for i in 1..<leafList.count{
            if leafList[i] == parseNode{
                return leafList[i - 1]
            }
        }
        return nil
    }

    public func clearLayer(layerType: ViewLayerType){
        if root != nil{
            (root as! ParseNodeDrawable).clearLayer(layerType: layerType)
        }
    }
    
    public func generateAnnotatedSentence() -> AnnotatedSentence{
        let sentence = AnnotatedSentence()
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsTurkishLeafNode())
        let leafList = nodeDrawableCollector.collect()
        for parseNode in leafList{
            let layers = parseNode.getLayerInfo()
            for i in 0..<layers.getNumberOfWords(){
                sentence.addWord(word: layers.toAnnotatedWord(wordIndex: i))
            }
        }
        return sentence
    }

    public func generateAnnotatedSentence(language: String) -> AnnotatedSentence{
        let sentence = AnnotatedSentence()
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsTurkishLeafNode())
        let leafList = nodeDrawableCollector.collect()
        for parseNode in leafList{
            let newWord = AnnotatedWord(word: "{" + language + "=" + parseNode.getData()!.getName() + "}{posTag="
                                            + parseNode.getParent()!.getData()!.getName() + "}")
            sentence.addWord(word: newWord)
        }
        return sentence
    }
    
    public func extractNodesWithVerbs(wordNet: WordNet) -> [ParseNodeDrawable]{
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsVerbNode(wordNet: wordNet))
        return nodeDrawableCollector.collect()
    }

    public func extractNodesWithPredicateVerbs(wordNet: WordNet) -> [ParseNodeDrawable]{
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsPredicateVerbNode(wordNet: wordNet))
        return nodeDrawableCollector.collect()
    }

    public func extractTags() -> [String]{
        var tagList : [String] = []
        (root as! ParseNodeDrawable).extractTags(tagList: &tagList)
        return tagList
    }
    
    public func extractNumberOfChildren() -> [Int]{
        var numberOfChildrenList: [Int] = []
        (root as! ParseNodeDrawable).extractNumberOfChildren(childNumberList: &numberOfChildrenList)
        return numberOfChildrenList
    }
    
    public func getSubItemAt(x: Int, y: Int) -> Int{
        return (root as! ParseNodeDrawable).getSubItemAt(x: x, y: y)
    }
    
    public func getLeafNodeAt(x: Int, y: Int) -> ParseNodeDrawable?{
        return (root as! ParseNodeDrawable).getLeafNodeAt(x: x, y: y)
    }
    
    public func getNodeAt(x: Int, y: Int) -> ParseNodeDrawable?{
        return (root as! ParseNodeDrawable).getNodeAt(x: x, y: y)
    }
    
    public func getLeatWithIndex(index: Int) -> ParseNodeDrawable?{
        return (root as! ParseNodeDrawable).getLeafWithIndex(index: index)
    }

}
