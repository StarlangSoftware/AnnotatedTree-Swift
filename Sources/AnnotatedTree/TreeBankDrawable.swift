//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 21.04.2022.
//

import Foundation
import ParseTree
import AnnotatedSentence
import WordNet

public class TreeBankDrawable : TreeBank{
    
    public override init(){
        super.init()
    }
    
    /**
     * A constructor of {@link TreeBank} class which reads all {@link ParseTree} files inside the given folder. For each
     * file inside that folder, the constructor creates a ParseTree and puts in inside the list parseTrees.
     - Parameters:
        - folder: Folder where all parseTrees reside.
     */
    public override init(folder: String){
        super.init()
        let fileManager = FileManager.default
        do {
            let listOfFiles = try fileManager.contentsOfDirectory(atPath: folder)
            for file in listOfFiles {
                let thisDirectory = URL(fileURLWithPath: folder)
                let url = thisDirectory.appendingPathComponent(file)
                let parseTree = ParseTreeDrawable(url: url)
                if parseTree.getRoot() != nil{
                    parseTrees.append(parseTree)
                }
            }
        } catch {
        }
    }

    /**
     * A constructor of {@link TreeBank} class which reads all {@link ParseTree} files with the file name satisfying the
     * given pattern inside the given folder. For each file inside that folder, the constructor creates a ParseTree
     * and puts in inside the list parseTrees.
     - Parameters:
        - folder: Folder where all parseTrees reside.
        - pattern: File pattern such as "." ".train" ".test".
     */
    public override init(folder: String, pattern: String){
        super.init()
        let fileManager = FileManager.default
        do {
            let listOfFiles = try fileManager.contentsOfDirectory(atPath: folder)
            for file in listOfFiles {
                if file.contains(pattern){
                    let thisDirectory = URL(fileURLWithPath: folder)
                    let url = thisDirectory.appendingPathComponent(file)
                    let parseTree = ParseTreeDrawable(url: url)
                    if parseTree.getRoot() != nil{
                        parseTrees.append(parseTree)
                    }
                }
            }
        } catch {
        }
    }
    
    public func getParseTrees() -> [ParseTree]{
        return parseTrees
    }
    
    public func clearLayer(layerType: ViewLayerType){
        for parseTree in parseTrees{
            let tree = parseTree as! ParseTreeDrawable
            tree.clearLayer(layerType: layerType)
        }
    }
    
    public func extractTreesWithPredicates(wordNet: WordNet) -> [ParseTreeDrawable]{
        var result : [ParseTreeDrawable] = []
        for parseTree in parseTrees{
            let tree = parseTree as! ParseTreeDrawable
            if tree.extractNodesWithPredicateVerbs(wordNet: wordNet).count > 0{
                result.append(tree)
            }
        }
        return result
    }
    
    public func removeTree(index: Int){
        parseTrees.remove(at: index)
    }

}
