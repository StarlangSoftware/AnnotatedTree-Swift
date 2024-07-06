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
    
    /// Constructor for the ParseTreeDrawable. Sets the file description and reads the tree from the file description.
    /// - Parameters:
    ///   - path: Path of the tree
    ///   - rawFileName: File name of the tree such as 0123.train.
    convenience init(path: String, rawFileName: String){
        self.init(fileDescription: FileDescription(path: path, extensionOrFileName: rawFileName))
    }
    
    /// Another constructor for the ParseTreeDrawable. Sets the file description and reads the tree from the file
    /// description.
    /// - Parameters:
    ///   - path: Path of the tree
    ///   - extensionOfFile: Extension of the file such as train, test or dev.
    ///   - index: Index of the file such as 1235.
    convenience init(path: String, extensionOfFile: String, index: Int){
        self.init(fileDescription: FileDescription(path: path, extensionOrFileName: extensionOfFile, index: index))
    }
    
    /// Another constructor for the ParseTreeDrawable. Sets the file description and reads the tree from the file
    /// description.
    /// - Parameters:
    ///   - path: Path of the tree
    ///   - fileDescription: File description that contains the path, index and extension information.
    convenience init(path: String, fileDescription: FileDescription){
        self.init(fileDescription: FileDescription(path: path, extensionOrFileName: fileDescription.getExtension(), index: fileDescription.getIndex()))
    }
    
    /// Mutator method for the fileDescription attribute.
    /// - Parameter fileDescription: New fileDescription value.
    public func setFileDescription(fileDescription: FileDescription){
        self.fileDescription = fileDescription
    }
    
    /// Accessor method for the fileDescription attribute.
    /// - Returns: FileDescription attribute.
    public func getFileDescription() -> FileDescription{
        return self.fileDescription
    }
    
    /// Copies the file description information from the given parse tree.
    /// - Parameter parseTree: Parse tree whose file description information will be copied.
    public func copyInfo(parseTree: ParseTreeDrawable){
        self.fileDescription = parseTree.fileDescription
    }
    
    /// Reloads the tree from the input file.
    public func reload(){
        readFromFile(url: URL(string: fileDescription.getPath())!)
    }
    
    /// Mutator for the root attribute.
    /// - Parameter newRootNode: New root node.
    public func setRoot(newRootNode: ParseNode){
        root = newRootNode
    }
    
    /// Reads the parse tree from the given file description with path replaced with the currentPath. It sets the root
    /// node which calls ParseNodeDrawable constructor recursively.
    /// - Parameter url: Path of the tree
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
    
    /// Sets the inOrderTraversalIndex attribute of all nodes in tree. InOrderTraversalIndex shows the index of the
    /// node according to the inorder traversal. Sets also the leafIndex attribute. LeafIndex shows the index of the
    /// leaf node according to the inorder traversal without considering non-leaf nodes.
    private func updateTraversalIndexes(){
        (root as! ParseNodeDrawable).inOrderTraversal(pos: 0)
        (root as! ParseNodeDrawable).leafTraversal(pos: 0)
        maxInOrderTraversalIndex = (root as! ParseNodeDrawable).maxInOrderTraversal()
    }
    
    /// Accessor for the maxInOrderTraversalIndex attribute
    /// - Returns: maxInOrderTraversalIndex attribute.
    public func getMaxInOrderTraversalIndex() -> Int{
        return maxInOrderTraversalIndex
    }
    
    /// Loads the next tree according to the index of the parse tree. For example, if the current
    /// tree fileName is 0123.train, after the call of nextTree(3), the method will load 0126.train. If the next tree
    /// does not exist, nothing will happen.
    /// - Parameter count: Number of trees to go forward
    public func nextTree(count: Int){
        if fileDescription.nextFileExists(count: count){
            fileDescription.addToIndex(count: count)
            reload()
        }
    }
    
    /// Loads the previous tree according to the index of the parse tree. For example, if the current
    /// tree fileName is 0123.train, after the call of previousTree(4), the method will load 0119.train. If the
    /// previous tree does not exist, nothing will happen.
    /// - Parameter count: Number of trees to go backward
    public func previousTree(count: Int){
        if fileDescription.previousFileExists(count: count){
            fileDescription.addToIndex(count: -count)
            reload()
        }
    }
    
    /// Updates all pos tags in the leaf nodes according to the morphological tag in those leaves.
    /// nodes.
    public func updatePosTags(){
        (root as! ParseNodeDrawable).updatePosTags()
    }
    
    /// Calculates the maximum depth of the tree.
    /// - Returns: The maximum depth of the tree.
    public func maxDepth() -> Int{
        return (root as! ParseNodeDrawable).maxDepth()
    }
    
    /// Swaps the given child node of this node with the previous sibling of that given node. If the given node is the
    /// leftmost child, it swaps with the last node.
    /// - Parameter node: Node to be swapped.
    public func moveLeft(node: ParseNode){
        if root != node{
            root?.moveLeft(node: node)
            updateTraversalIndexes()
        }
    }
    
    /// Swaps the given child node of this node with the next sibling of that given node. If the given node is the
    /// rightmost child, it swaps with the first node.
    /// - Parameter node: Node to be swapped.
    public func moveRight(node: ParseNode){
        if root != node{
            root?.moveRight(node: node)
            updateTraversalIndexes()
        }
    }
    
    /// Moves the subtree rooted at fromNode as a child to the node toNode.
    /// - Parameters:
    ///   - fromNode: Subtree root node to be moved.
    ///   - toNode: Node to which a new subtree will be added.
    public func moveNode(fromNode: ParseNode, toNode: ParseNode){
        if root != fromNode{
            let parent = fromNode.getParent()
            parent?.removeChild(child: fromNode)
            toNode.addChild(child: fromNode)
            updateTraversalIndexes()
            (root as! ParseNodeDrawable).updateDepths(depth: 0)
        }
    }
    
    /// Moves the subtree rooted at fromNode as a child to the node toNode at position childIndex.
    /// - Parameters:
    ///   - fromNode: Subtree root node to be moved.
    ///   - toNode: Node to which a new subtree will be added.
    ///   - childIndex: New child index of the toNode.
    public func moveNode(fromNode: ParseNode, toNode: ParseNode, childIndex: Int){
        if root != fromNode{
            let parent = fromNode.getParent()
            parent?.removeChild(child: fromNode)
            toNode.addChild(index: childIndex, child: fromNode)
            updateTraversalIndexes()
            (root as! ParseNodeDrawable).updateDepths(depth: 0)
        }
    }
    
    /// Removed the first child of the parent node and adds the given child node as a child to that node.
    /// - Parameters:
    ///   - parent: Parent node.
    ///   - child: New child node to be added.
    public func combineWords(parent: ParseNodeDrawable, child: ParseNodeDrawable){
        while parent.numberOfChildren() > 0{
            parent.removeChild(child: parent.firstChild())
        }
        parent.addChild(child: child)
        updateTraversalIndexes()
        (root as! ParseNodeDrawable).updateDepths(depth: 0)
    }
    
    /// The method checks if all nodes in the tree has the annotation in the given layer.
    /// - Parameter viewLayerType: Layer name
    /// - Returns: True if all nodes in the tree has the annotation in the given layer, false otherwise.
    public func layerExists(viewLayerType: ViewLayerType) -> Bool{
        return (root as! ParseNodeDrawable).layerExists(viewLayerType: viewLayerType)
    }
    
    /// Checks if all nodes in the tree has annotation with the given layer.
    /// - Parameter viewLayerType: Layer name
    /// - Returns: True if all nodes in the tree has annotation with the given layer, false otherwise.
    public func layerAll(viewLayerType: ViewLayerType) -> Bool{
        return (root as! ParseNodeDrawable).layerAll(viewLayerType: viewLayerType)
    }
    
    /// Returns the framesets that are used to annotate the leaf nodes in the current tree with "PREDICATE".
    /// - Parameter framesetList: Framenet which contains the framesets.
    /// - Returns: The framesets that are used to annotate the leaf nodes in the current tree with "PREDICATE".
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
    
    /// Replaces id's of predicates, which have previousId as synset id, with currentId. Replaces also predicate id's of
    /// frame elements, which have predicate id's previousId, with currentId.
    /// - Parameters:
    ///   - previousId: Previous id of the synset.
    ///   - currentId: Replacement id.
    /// - Returns: Returns true, if any replacement has been done; false otherwise.
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
    
    /// Returns the leaf node that comes one after the given parse node according to the inorder traversal.
    /// - Parameter parseNode: Input parse node.
    /// - Returns: The leaf node that comes one after the given parse node according to the inorder traversal.
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
    
    /// Returns the leaf node that comes one before the given parse node according to the inorder traversal.
    /// - Parameter parseNode: Input parse node.
    /// - Returns: The leaf node that comes one before the given parse node according to the inorder traversal.
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
    
    /// Clears the given layer for all nodes in the tree
    /// - Parameter layerType: Layer name
    public func clearLayer(layerType: ViewLayerType){
        if root != nil{
            (root as! ParseNodeDrawable).clearLayer(layerType: layerType)
        }
    }
    
    /// Constructs an AnnotatedSentence object from the Turkish tree. Collects all leaf nodes, then for each leaf node
    /// converts layer info of all words at that node to AnnotatedWords. Layers are converted to the counterparts in the
    /// AnnotatedWord.
    /// - Returns: AnnotatedSentence counterpart of the Turkish tree
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
    
    /// Constructs an AnnotatedSentence object from the English tree. Collects all leaf nodes, then for each leaf node
    /// converts the word with its parents pos tag to AnnotatedWord.
    /// - Parameter language: English or Persian.
    /// - Returns: AnnotatedSentence counterpart of the English tree
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
    
    /// Recursive method that generates a new parse tree by replacing the tag information of the all parse nodes (with all
    /// its descendants) with respect to the morphological annotation of all parse nodes (with all its descendants)
    /// of the current parse tree.
    /// - Parameter surfaceForm: If true, tag will be replaced with the surface form annotation.
    /// - Returns: A new parse tree by replacing the tag information of the all parse nodes with respect to the
    /// morphological annotation of all parse nodes of the current parse tree.
    public func generateParseTree(surfaceForm: Bool) -> ParseTree{
        let result = ParseTree(root: ParseNode(data: (root?.getData())!))
        (root as! ParseNodeDrawable).generateParseNode(parseNode: result.getRoot()!, surfaceForm: surfaceForm)
        return result
    }
    
    /// Returns list of nodes that contain verbs.
    /// - Parameter wordNet: Wordnet used for checking the pos tag of the synset.
    /// - Returns: List of nodes that contain verbs.
    public func extractNodesWithVerbs(wordNet: WordNet) -> [ParseNodeDrawable]{
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsVerbNode(wordNet: wordNet))
        return nodeDrawableCollector.collect()
    }
    
    /// Returns list of nodes that contain verbs which are annotated as 'PREDICATE'.
    /// - Parameter wordNet: Wordnet used for checking the pos tag of the synset.
    /// - Returns: List of nodes that contain verbs which are annotated as 'PREDICATE'.
    public func extractNodesWithPredicateVerbs(wordNet: WordNet) -> [ParseNodeDrawable]{
        let nodeDrawableCollector = NodeDrawableCollector(rootNode: root as! ParseNodeDrawable, condition: IsPredicateVerbNode(wordNet: wordNet))
        return nodeDrawableCollector.collect()
    }
    
    /// Returns tag symbols of all nodes in the tree.
    /// - Returns: List of tag symbols of all nodes in the tree.
    public func extractTags() -> [String]{
        var tagList : [String] = []
        (root as! ParseNodeDrawable).extractTags(tagList: &tagList)
        return tagList
    }
    
    /// Returns number of children of all nodes in the tree.
    /// - Returns: A list of number of children of all nodes in the tree.
    public func extractNumberOfChildren() -> [Int]{
        var numberOfChildrenList: [Int] = []
        (root as! ParseNodeDrawable).extractNumberOfChildren(childNumberList: &numberOfChildrenList)
        return numberOfChildrenList
    }
    
    /// Returns the index of the layer data in the given x and y coordinates in the panel that displays the annotated
    /// tree.
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: Index of the layer data in the given x and y coordinates in the panel that displays the annotated tree.
    public func getSubItemAt(x: Int, y: Int) -> Int{
        return (root as! ParseNodeDrawable).getSubItemAt(x: x, y: y)
    }
    
    /// Returns the leaf node in the given x and y coordinates in the panel that displays the annotated tree.
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: The leaf node in the given x and y coordinates in the panel that displays the annotated tree.
    public func getLeafNodeAt(x: Int, y: Int) -> ParseNodeDrawable?{
        return (root as! ParseNodeDrawable).getLeafNodeAt(x: x, y: y)
    }
    
    /// Returns the parse node in the given x and y coordinates in the panel that displays the annotated tree.
    /// - Parameters:
    ///   - x: x coordinate
    ///   - y: y coordinate
    /// - Returns: The parse node in the given x and y coordinates in the panel that displays the annotated tree.
    public func getNodeAt(x: Int, y: Int) -> ParseNodeDrawable?{
        return (root as! ParseNodeDrawable).getNodeAt(x: x, y: y)
    }
    
    /// Returns the leaf node at position index in the tree.
    /// - Parameter index: Position of the leaf node.
    /// - Returns: The leaf node at position index in the tree.
    public func getLeatWithIndex(index: Int) -> ParseNodeDrawable?{
        return (root as! ParseNodeDrawable).getLeafWithIndex(index: index)
    }

}
