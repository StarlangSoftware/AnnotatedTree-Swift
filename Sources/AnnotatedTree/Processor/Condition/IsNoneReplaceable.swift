//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 18.04.2022.
//

import Foundation

public class IsNoneReplaceable : IsLeafNode{
    
    public override func satisfies(parseNode: ParseNodeDrawable) -> Bool {
        if super.satisfies(parseNode: parseNode){
            let data = parseNode.getLayerData(viewLayer: .ENGLISH_WORD)
            let parentData = parseNode.getParent()?.getData()?.getName()
            if parentData == "DT"{
                return data?.lowercased() == "the"
            } else {
                if parentData == "IN"{
                    return data?.lowercased() == "in" || data?.lowercased() == "than" || data?.lowercased() == "from" || data?.lowercased() == "on" || data?.lowercased() == "with" || data?.lowercased() == "of" || data?.lowercased() == "at" || data?.lowercased() == "if" || data?.lowercased() == "by"
                } else {
                    if parentData == "TO"{
                        return data?.lowercased() == "to"
                    } else {
                        if parentData == "VBZ"{
                            return data?.lowercased() == "has" || data?.lowercased() == "does" || data?.lowercased() == "is" || data?.lowercased() == "'s"
                        } else {
                            if parentData == "MD"{
                                return data?.lowercased() == "will" || data?.lowercased() == "'d" || data?.lowercased() == "'ll" || data?.lowercased() == "ca" || data?.lowercased() == "can" || data?.lowercased() == "could" || data?.lowercased() == "would" || data?.lowercased() == "should" || data?.lowercased() == "wo" || data?.lowercased() == "may" || data?.lowercased() == "might"
                            } else {
                                if parentData == "VBP"{
                                    return data?.lowercased() == "'re" || data?.lowercased() == "is" || data?.lowercased() == "are" || data?.lowercased() == "am" || data?.lowercased() == "'m" || data?.lowercased() == "do" || data?.lowercased() == "have" || data?.lowercased() == "has" || data?.lowercased() == "'ve"
                                } else {
                                    if parentData == "VBD"{
                                        return data?.lowercased() == "had" || data?.lowercased() == "did" || data?.lowercased() == "were" || data?.lowercased() == "was"
                                    } else {
                                        if parentData == "VBN"{
                                            return data?.lowercased() == "been"
                                        } else {
                                            if parentData == "VB"{
                                                return data?.lowercased() == "have" || data?.lowercased() == "be"
                                            } else {
                                                if parentData == "RB"{
                                                    return data?.lowercased() == "n't" || data?.lowercased() == "not"
                                                } else {
                                                    if parentData == "POS"{
                                                        return data?.lowercased() == "'s" || data?.lowercased() == "'"
                                                    } else {
                                                        if parentData == "WP"{
                                                            return data?.lowercased() == "who" || data?.lowercased() == "where" || data?.lowercased() == "which" || data?.lowercased() == "what" || data?.lowercased() == "why"
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
        return false
    }
}
