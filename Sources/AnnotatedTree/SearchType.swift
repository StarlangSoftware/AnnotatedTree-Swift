//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 13.04.2022.
//

import Foundation

public enum SearchType : String, CaseIterable{
    case EQUALS
    
    case EQUALS_IGNORE_CASE
    
    case CONTAINS
    
    case MATCHES
    
    case STARTS
    
    case ENDS
    
    case IS_NULL
}
