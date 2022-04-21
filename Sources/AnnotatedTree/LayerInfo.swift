//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation
import AnnotatedSentence
import MorphologicalAnalysis
import PropBank

public class LayerInfo{
    
    private var layers : Dictionary<ViewLayerType, WordLayer> = [:]
    
    init(info: String){
        let splitLayers = info.components(separatedBy: CharacterSet(charactersIn: "[{}]"))
        for layer in splitLayers {
            if !layer.isEmpty{
                let splitWords = layer.split(separator: "=").map(String.init)
                let layerType = splitWords[0]
                let layerValue = splitWords[1]
                if layerType == "turkish"{
                    layers[.TURKISH_WORD] = TurkishWordLayer(layerValue: layerValue)
                } else {
                    if layerType == "persian"{
                        layers[.PERSIAN_WORD] = PersianWordLayer(layerValue: layerValue)
                    } else {
                        if layerType == "english"{
                            layers[.ENGLISH_WORD] = EnglishWordLayer(layerValue: layerValue)
                        } else {
                            if layerType == "morphologicalAnalysis"{
                                layers[.INFLECTIONAL_GROUP] = MorphologicalAnalysisLayer(layerValue: layerValue)
                                layers[.PART_OF_SPEECH] = MorphologicalAnalysisLayer(layerValue: layerValue)
                            } else {
                                if layerType == "metaMorphemes"{
                                    layers[.META_MORPHEME] = MetaMorphemeLayer(layerValue: layerValue)
                                } else {
                                    if layerType == "metaMorphemesMoved"{
                                        layers[.META_MORPHEME_MOVED] = MetaMorphemesMovedLayer(layerValue: layerValue)
                                    } else {
                                        if layerType == "dependency"{
                                            layers[.DEPENDENCY] = DependencyLayer(layerValue: layerValue)
                                        } else {
                                            if layerType == "semantics"{
                                                layers[.SEMANTICS] = TurkishSemanticLayer(layerValue: layerValue)
                                            } else {
                                                if layerType == "namedEntity"{
                                                    layers[.NER] = NERLayer(layerValue: layerValue)
                                                } else {
                                                    if layerType == "propBank"{
                                                        layers[.PROPBANK] = TurkishPropbankLayer(layerValue: layerValue)
                                                    } else {
                                                        if layerType == "englishPropbank"{
                                                            layers[.ENGLISH_PROPBANK] = EnglishPropbankLayer(layerValue: layerValue)
                                                        } else {
                                                            if layerType == "englishSemantics"{
                                                                layers[.ENGLISH_SEMANTICS] = EnglishSemanticLayer(layerValue: layerValue)
                                                            } else {
                                                                if layerType == "shallowParse"{
                                                                    layers[.SHALLOW_PARSE] = ShallowParseLayer(layerValue: layerValue)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    init(){
    }
    
    public func setLayerData(viewLayer: ViewLayerType, layerValue: String){
        switch viewLayer {
        case .PERSIAN_WORD:
            layers[.PERSIAN_WORD] = PersianWordLayer(layerValue: layerValue)
            layers.removeValue(forKey: .SEMANTICS)
        case .TURKISH_WORD:
            layers[.TURKISH_WORD] = TurkishWordLayer(layerValue: layerValue)
            layers.removeValue(forKey: .INFLECTIONAL_GROUP)
            layers.removeValue(forKey: .PART_OF_SPEECH)
            layers.removeValue(forKey: .META_MORPHEME)
            layers.removeValue(forKey: .META_MORPHEME_MOVED)
            layers.removeValue(forKey: .SEMANTICS)
        case .ENGLISH_WORD:
            layers[.ENGLISH_WORD] = EnglishWordLayer(layerValue: layerValue)
        case .PART_OF_SPEECH, .INFLECTIONAL_GROUP:
            layers[.INFLECTIONAL_GROUP] = MorphologicalAnalysisLayer(layerValue: layerValue)
            layers[.PART_OF_SPEECH] = MorphologicalAnalysisLayer(layerValue: layerValue)
            layers.removeValue(forKey: .META_MORPHEME_MOVED)
        case .META_MORPHEME:
            layers[.META_MORPHEME] = MetaMorphemeLayer(layerValue: layerValue)
        case .META_MORPHEME_MOVED:
            layers[.META_MORPHEME_MOVED] = MetaMorphemesMovedLayer(layerValue: layerValue)
        case .DEPENDENCY:
            layers[.DEPENDENCY] = DependencyLayer(layerValue: layerValue)
        case .SEMANTICS:
            layers[.SEMANTICS] = TurkishSemanticLayer(layerValue: layerValue)
        case .ENGLISH_SEMANTICS:
            layers[.ENGLISH_SEMANTICS] = EnglishSemanticLayer(layerValue: layerValue)
        case .NER:
            layers[.NER] = NERLayer(layerValue: layerValue)
        case .PROPBANK:
            layers[.PROPBANK] = TurkishPropbankLayer(layerValue: layerValue)
        case .ENGLISH_PROPBANK:
            layers[.ENGLISH_PROPBANK] = EnglishPropbankLayer(layerValue: layerValue)
        case .SHALLOW_PARSE:
            layers[.SHALLOW_PARSE] = ShallowParseLayer(layerValue: layerValue)
        default:
            break
        }
    }
    
    public func setMorphologicalAnalysis(parse: MorphologicalParse){
        layers[.INFLECTIONAL_GROUP] = MorphologicalAnalysisLayer(layerValue: parse.description())
        layers[.PART_OF_SPEECH] = MorphologicalAnalysisLayer(layerValue: parse.description())
    }
    
    public func setMetamorphemes(parse: MetamorphicParse){
        layers[.META_MORPHEME] = MetaMorphemeLayer(layerValue: parse.description())
    }
    
    public func layerExists(viewLayerType: ViewLayerType) -> Bool{
        return layers[viewLayerType] != nil
    }
    
    public func checkLayer(viewLayer: ViewLayerType) -> ViewLayerType{
        switch viewLayer {
        case .PART_OF_SPEECH, .INFLECTIONAL_GROUP, .META_MORPHEME, .SEMANTICS, .NER, .PROPBANK, .SHALLOW_PARSE, .ENGLISH_PROPBANK:
            if layers[viewLayer] == nil{
                return .TURKISH_WORD
            }
        case .TURKISH_WORD, .PERSIAN_WORD, .ENGLISH_SEMANTICS:
            if layers[viewLayer] == nil{
                return .ENGLISH_WORD
            }
        case .META_MORPHEME_MOVED:
            if layers[viewLayer] == nil{
                return .META_MORPHEME
            }
        default:
            return viewLayer
        }
        return viewLayer
    }
    
    public func getNumberOfWords() -> Int{
        if let layer = layers[.TURKISH_WORD]{
            return (layer as! TurkishWordLayer).size()
        } else {
            if let layer = layers[.PERSIAN_WORD]{
                return (layer as! PersianWordLayer).size()
            }
        }
        return 0
    }
    
    public func getMultiWordAt(viewLayerType: ViewLayerType, index: Int, layerName: String) -> String{
        if let layer = layers[viewLayerType]{
            if let multiWordLayer = layer as? MultiWordLayer<String>{
                if index < multiWordLayer.size() && index >= 0{
                    return multiWordLayer.getItemAt(index: index)!
                } else {
                    if (viewLayerType == .SEMANTICS){
                        return multiWordLayer.getItemAt(index: multiWordLayer.size() - 1)!
                    }
                }
            }
        }
        return ""
    }
    
    public func getTurkishWordAt(index: Int) -> String{
        return getMultiWordAt(viewLayerType: .TURKISH_WORD, index: index, layerName: "turkish")
    }
    
    public func getNumberOfMeanings() -> Int{
        if layers[.SEMANTICS] != nil{
            return (layers[.SEMANTICS] as! TurkishSemanticLayer).size()
        } else {
            return 0
        }
    }
    
    public func getSemanticAt(index: Int) -> String{
        return getMultiWordAt(viewLayerType: .SEMANTICS, index: index, layerName: "semantics")
    }
    
    public func getShallowParseAt(index: Int) -> String{
        return getMultiWordAt(viewLayerType: .SHALLOW_PARSE, index: index, layerName: "shallowParse")
    }
    
    public func getArgument() -> Argument?{
        if let layer = layers[.PROPBANK]{
            if let argumentLayer = layer as? TurkishPropbankLayer{
                return argumentLayer.getArgument()!
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func getArgumentAt(index: Int) -> Argument?{
        if let layer = layers[.ENGLISH_PROPBANK]{
            if let multiArgumentLayer = layer as? SingleWordMultiItemLayer<Argument>{
                return multiArgumentLayer.getItemAt(index: index)!
            }
        }
        return nil
    }
    
    public func getMorphologicalParseAt(index: Int) -> MorphologicalParse?{
        if let layer = layers[.INFLECTIONAL_GROUP]{
            if let multiWordLayer = layer as? MultiWordLayer<MorphologicalParse>{
                if index < multiWordLayer.size() && index >= 0{
                    return multiWordLayer.getItemAt(index: index)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    public func getMetamorphicParseAt(index: Int) -> MetamorphicParse?{
        if let layer = layers[.META_MORPHEME]{
            if let multiWordLayer = layer as? MultiWordLayer<MetamorphicParse>{
                if index < multiWordLayer.size() && index >= 0{
                    return multiWordLayer.getItemAt(index: index)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    public func getMetaMorphemeAtIndex(index: Int) -> String?{
        if let layer = layers[.META_MORPHEME]{
            if let metaMorphemeLayer = layer as? MetaMorphemeLayer{
                if index < metaMorphemeLayer.getLayerSize(viewLayer: .META_MORPHEME) && index >= 0{
                    return metaMorphemeLayer.getLayerInfoAt(viewLayer: .META_MORPHEME, index: index)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    public func getMetaMorphemeFromIndex(index: Int) -> String?{
        if let layer = layers[.META_MORPHEME]{
            if let metaMorphemeLayer = layer as? MetaMorphemeLayer{
                if index < metaMorphemeLayer.getLayerSize(viewLayer: .META_MORPHEME) && index >= 0{
                    return metaMorphemeLayer.getLayerInfoFrom(index: index)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func getLayerSize(viewLayer: ViewLayerType) -> Int{
        if let layer = layers[viewLayer] as? MultiWordMultiItemLayer<Any>{
            return layer.getLayerSize(viewLayer: viewLayer)
        } else {
            if let layer = layers[viewLayer] as? SingleWordMultiItemLayer<Any>{
                return layer.getLayerSize(viewLayer: viewLayer)
            }
        }
        return 0
    }
    
    public func getLayerInfoAt(viewLayer: ViewLayerType, index: Int) -> String?{
        switch viewLayer {
        case .META_MORPHEME_MOVED, .PART_OF_SPEECH, .INFLECTIONAL_GROUP:
            if let layer = layers[viewLayer] as? MultiWordMultiItemLayer<Any>{
                return layer.getLayerInfoAt(viewLayer: viewLayer, index: index)
            }
        case .META_MORPHEME:
            return getMetaMorphemeAtIndex(index: index)
        case .ENGLISH_PROPBANK:
            return getArgumentAt(index: index)?.getArgumentType()
        default:
            return nil
        }
        return nil
    }
    
    public func getLayerDescription() -> String{
        var result = ""
        for viewLayerType in layers.keys{
            if viewLayerType != .PART_OF_SPEECH{
                result = result + (layers[viewLayerType]?.getLayerDescription())!
            }
        }
        return result
    }
    
    public func getLayerData(viewLayer: ViewLayerType) -> String?{
        if let layer = layers[viewLayer]{
            return layer.getLayerValue()
        } else {
            return nil
        }
    }
    
    public func getRobustLayerData(viewLayer: ViewLayerType) -> String?{
        let viewLayer = checkLayer(viewLayer: viewLayer)
        return getLayerData(viewLayer: viewLayer)
    }
    
    public func updateMetaMorphemesMoved(){
        if let layer = layers[.META_MORPHEME]{
            if let metaMorphemeLayer = layer as? MetaMorphemeLayer{
                if metaMorphemeLayer.size() > 0{
                    var result : String = (metaMorphemeLayer.getItemAt(index: 0)?.description())!
                    for i in 1..<metaMorphemeLayer.size(){
                        result = result + (metaMorphemeLayer.getItemAt(index: i)?.description())!
                    }
                    layers[.META_MORPHEME_MOVED] = MetaMorphemesMovedLayer(layerValue: result)
                }
            }
        }
    }
    
    public func removeLayer(layerType: ViewLayerType){
        layers.removeValue(forKey: layerType)
    }
    
    public func metaMorphemeClear(){
        layers.removeValue(forKey: .META_MORPHEME)
        layers.removeValue(forKey: .META_MORPHEME_MOVED)
    }
    
    public func englishClear(){
        layers.removeValue(forKey: .ENGLISH_WORD)
    }
    
    public func dependencyClear(){
        layers.removeValue(forKey: .DEPENDENCY)
    }
    
    public func metaMorphemesMovedClear(){
        layers.removeValue(forKey: .META_MORPHEME_MOVED)
    }
    
    public func semanticClear(){
        layers.removeValue(forKey: .SEMANTICS)
    }
    
    public func englishSemanticClear(){
        layers.removeValue(forKey: .ENGLISH_SEMANTICS)
    }
    
    public func morphologicalAnalysisClear(){
        layers.removeValue(forKey: .INFLECTIONAL_GROUP)
        layers.removeValue(forKey: .PART_OF_SPEECH)
        layers.removeValue(forKey: .META_MORPHEME)
        layers.removeValue(forKey: .META_MORPHEME_MOVED)
    }
    
    public func metaMorphemeRemove(index: Int) -> MetamorphicParse?{
        var removedParse : MetamorphicParse? = nil
        if let layer = layers[.META_MORPHEME]{
            if let metaMorphemeLayer = layer as? MetaMorphemeLayer{
                if index >= 0 && index < metaMorphemeLayer.getLayerSize(viewLayer: .META_MORPHEME){
                    removedParse = metaMorphemeLayer.metaMorphemeRemoveFromIndex(index: index)
                    updateMetaMorphemesMoved()
                }
            }
        }
        return removedParse
    }
    
    public func divideIntoWords() -> [LayerInfo]{
        var result : [LayerInfo] = []
        for i in 0..<getNumberOfWords(){
            let layerInfo = LayerInfo()
            layerInfo.setLayerData(viewLayer: .TURKISH_WORD, layerValue: getTurkishWordAt(index: i))
            layerInfo.setLayerData(viewLayer: .ENGLISH_WORD, layerValue: getLayerData(viewLayer: .ENGLISH_WORD)!)
            if layerExists(viewLayerType: .INFLECTIONAL_GROUP){
                layerInfo.setMorphologicalAnalysis(parse: getMorphologicalParseAt(index: i)!)
            }
            if layerExists(viewLayerType: .META_MORPHEME){
                layerInfo.setMetamorphemes(parse: getMetamorphicParseAt(index: i)!)
            }
            if layerExists(viewLayerType: .ENGLISH_PROPBANK){
                layerInfo.setLayerData(viewLayer: .ENGLISH_PROPBANK, layerValue: getLayerData(viewLayer: .ENGLISH_PROPBANK)!)
            }
            if layerExists(viewLayerType: .ENGLISH_SEMANTICS){
                layerInfo.setLayerData(viewLayer: .ENGLISH_SEMANTICS, layerValue: getLayerData(viewLayer: .ENGLISH_SEMANTICS)!)
            }
            if layerExists(viewLayerType: .NER){
                layerInfo.setLayerData(viewLayer: .NER, layerValue: getLayerData(viewLayer: .NER)!)
            }
            if layerExists(viewLayerType: .SEMANTICS){
                layerInfo.setLayerData(viewLayer: .SEMANTICS, layerValue: getSemanticAt(index: i))
            }
            if layerExists(viewLayerType: .PROPBANK){
                layerInfo.setLayerData(viewLayer: .PROPBANK, layerValue: (getArgument()?.description())!)
            }
            if layerExists(viewLayerType: .SHALLOW_PARSE){
                layerInfo.setLayerData(viewLayer: .SHALLOW_PARSE, layerValue: getShallowParseAt(index: i))
            }
            result.append(layerInfo)
        }
        return result
    }
    
    public func toAnnotatedWord(wordIndex: Int) -> AnnotatedWord{
        let annotatedWord : AnnotatedWord = AnnotatedWord(word: getTurkishWordAt(index: wordIndex))
        if layerExists(viewLayerType: .INFLECTIONAL_GROUP){
            annotatedWord.setParse(parseString: getMorphologicalParseAt(index: wordIndex)?.description())
        }
        if layerExists(viewLayerType: .META_MORPHEME){
            annotatedWord.setMetamorphicParse(parseString: (getMetamorphicParseAt(index: wordIndex)?.description())!)
        }
        if layerExists(viewLayerType: .SEMANTICS){
            annotatedWord.setSemantic(semantic: getSemanticAt(index: wordIndex))
        }
        if layerExists(viewLayerType: .NER){
            annotatedWord.setNamedEntityType(namedEntity: getLayerData(viewLayer: .NER))
        }
        if layerExists(viewLayerType: .PROPBANK){
            annotatedWord.setArgument(argument: getArgument()?.description())
        }
        if layerExists(viewLayerType: .SHALLOW_PARSE){
            annotatedWord.setShallowParse(parse: getShallowParseAt(index: wordIndex))
        }
        return annotatedWord
    }

}
