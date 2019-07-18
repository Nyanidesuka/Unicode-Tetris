//
//  Tetrimino.swift
//  gameboyTry2
//
//  Created by Haley Jones on 5/4/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation
class tetrimino {
    var shape: minoShape?
    //the top-left of the "sprite" we're making
    var origin: [Int] = []
    //position of the blocks relative to the origin
    //these are like... coordinates
    var firstBlock: [Int] = []
    var secondBlock: [Int] = []
    var thirdBlock: [Int] = []
    var fourthBlock: [Int] = []
    //what emoji you should use to draw the blocks
    var emoji: String?
    var rotation = blockRotation.original
    
    init(shape: minoShape){
        self.origin = [0, 4]
        self.shape = shape
        switch shape{
        case .o:
            self.firstBlock = [origin[0], origin[1]]
            self.secondBlock = [origin[0], origin[1] + 1]
            self.thirdBlock = [origin[0] + 1, origin[1]]
            self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            self.emoji = "⏹"
        case .i:
            self.firstBlock = [origin[0], origin[1]]
            self.secondBlock = [origin[0] + 1, origin[1]]
            self.thirdBlock = [origin[0] + 2, origin[1]]
            self.fourthBlock = [origin[0] + 3, origin[1]]
            self.emoji = "🔼"
        case .s:
            self.firstBlock = [origin[0], origin[1] + 1]
            self.secondBlock = [origin[0], origin[1] + 2]
            self.thirdBlock = [origin[0] + 1, origin[1]]
            self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            self.emoji = "❇️"
        case .z:
            self.firstBlock = [origin[0], origin[1]]
            self.secondBlock = [origin[0], origin[1] + 1]
            self.thirdBlock = [origin[0] + 1, origin[1] + 1]
            self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            self.emoji = "🈴"
        case .j:
            self.firstBlock = [origin[0], origin[1]]
            self.secondBlock = [origin[0] + 1, origin[1]]
            self.thirdBlock = [origin[0] + 1, origin[1] + 1]
            self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            self.emoji = "🈂️"
        case .l:
            self.firstBlock = [origin[0], origin[1] + 2]
            self.secondBlock = [origin[0] + 1, origin[1]]
            self.thirdBlock = [origin[0] + 1, origin[1] + 1]
            self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            self.emoji = "✴️"
        case .t:
            self.firstBlock = [origin[0], origin[1] + 1]
            self.secondBlock = [origin[0] + 1, origin[1]]
            self.thirdBlock = [origin[0] + 1, origin[1] + 1]
            self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            self.emoji = "⚛️"
        }
    }
    
    func updateBlocks(forTetrimino: tetrimino){
        print("update blocks trying to fire...")
        guard let switchShape = forTetrimino.shape else {return}
        switch switchShape{
        case .o:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0], origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0], origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0], origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0], origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            }
        case .i:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 2, origin[1]]
                self.fourthBlock = [origin[0] + 3, origin[1]]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1] - 1]
                self.secondBlock = [origin[0], origin[1] - 2]
                self.thirdBlock = [origin[0], origin[1]]
                self.fourthBlock = [origin[0], origin[1] + 1]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 2, origin[1]]
                self.fourthBlock = [origin[0] + 3, origin[1]]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1] - 1]
                self.secondBlock = [origin[0], origin[1]]
                self.thirdBlock = [origin[0], origin[1] + 1]
                self.fourthBlock = [origin[0], origin[1] + 2]
            }
        case .s:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0], origin[1] + 2]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 2, origin[1] + 1]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0], origin[1] + 2]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 2, origin[1] + 1]
            }
        case .z:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0], origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 2, origin[1]]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0], origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 2, origin[1]]
            }
        case .j:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 2, origin[1]]
                self.fourthBlock = [origin[0], origin[1] + 1]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1] + 2]
                self.thirdBlock = [origin[0], origin[1] + 1]
                self.fourthBlock = [origin[0], origin[1] + 2]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1] + 1]
                self.thirdBlock = [origin[0] + 2, origin[1] + 1]
                self.fourthBlock = [origin[0] + 2, origin[1]]
            }
        case .l:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1] + 2]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 2, origin[1]]
                self.fourthBlock = [origin[0] + 2, origin[1] + 1]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1]]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0], origin[1] + 1]
                self.fourthBlock = [origin[0], origin[1] + 2]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1] + 1]
                self.thirdBlock = [origin[0] + 2, origin[1] + 1]
                self.fourthBlock = [origin[0], origin[1]]
            }
        case .t:
            switch self.rotation{
            case .original:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1]]
                self.thirdBlock = [origin[0] + 1, origin[1] + 1]
                self.fourthBlock = [origin[0] + 1, origin[1] + 2]
            case .ninetyCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1] + 2]
                self.fourthBlock = [origin[0] + 2, origin[1] + 1]
            case .oneEightCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0], origin[1]]
                self.thirdBlock = [origin[0], origin[1] + 2]
                self.fourthBlock = [origin[0] + 1, origin[1] + 1]
            case .twoSeventyCW:
                self.firstBlock = [origin[0], origin[1] + 1]
                self.secondBlock = [origin[0] + 1, origin[1] + 1]
                self.thirdBlock = [origin[0] + 1, origin[1]]
                self.fourthBlock = [origin[0] + 2, origin[1] + 1]
            }
        }
        print("update blocks fired")
    }
}


