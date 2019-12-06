//
//  Collection+SafeIndex.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 06/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
