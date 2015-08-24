//
//  MineSweeperModel.swift
//  MineSweeper
//
//  Created by Local Student on 14/06/15.
//  Copyright (c) 2015 AIT. All rights reserved.
//

import Foundation

private let model = MineSweeperModel()

class MineSweeperModel {

    var mr1 = 0
    var mr2 = 0
    var mr3 = 0
    var mc1 = 0
    var mc2 = 0
    var mc3 = 0
    
    enum CellContent {
        case Tile
        case Mine
        case Empty
    }
    
    class var sharedModel: MineSweeperModel {
        get {
            return model
        }
    }
    
    var grid = [[CellContent]]()
    
    
    init() {
        for row in 0..<5 {
            grid.append([CellContent](count: 5, repeatedValue: .Tile))
        }
    }
    
    func contentForCell(row: Int, column: Int) -> CellContent {
        return grid[row][column]
    }
    
    func markRow(row: Int, column: Int) {
        if grid[row][column] == .Tile {
            grid[row][column] = .Empty
        }
        if grid[row][column] == .Mine {
            lose()
        }
    }
    
    func lose() {
        grid[mr1][mc1] = .Mine
        grid[mr2][mc2] = .Mine
        grid[mr3][mc3] = .Mine
    }
    
    func hideMines() {
        var mineRow1 = Int(arc4random_uniform(5))
        var mineRow2 = Int(arc4random_uniform(5))
        var mineRow3 = Int(arc4random_uniform(5))
        var mineColumn1 = Int(arc4random_uniform(5))
        var mineColumn2 = Int(arc4random_uniform(5))
        var mineColumn3 = Int(arc4random_uniform(5))
        if mineRow1 == mineRow2 && mineColumn1 == mineColumn2 {
            mineRow1 = Int(arc4random_uniform(5))
            mineRow2 = Int(arc4random_uniform(5))
            mineColumn1 = Int(arc4random_uniform(5))
            mineColumn2 = Int(arc4random_uniform(5))
        }
        if mineRow2 == mineRow3 && mineColumn2 == mineColumn3 {
            mineRow2 = Int(arc4random_uniform(5))
            mineRow3 = Int(arc4random_uniform(5))
            mineColumn2 = Int(arc4random_uniform(5))
            mineColumn3 = Int(arc4random_uniform(5))
        }
        if mineRow1 == mineRow3 && mineColumn1 == mineColumn3 {
            mineRow1 = Int(arc4random_uniform(5))
            mineRow3 = Int(arc4random_uniform(5))
            mineColumn1 = Int(arc4random_uniform(5))
            mineColumn3 = Int(arc4random_uniform(5))
        }
        grid[mineRow1][mineColumn1] = .Mine
        grid[mineRow2][mineColumn2] = .Mine
        grid[mineRow3][mineColumn3] = .Mine
        mr1 = mineRow1
        mr2 = mineRow2
        mr3 = mineRow3
        mc1 = mineColumn1
        mc2 = mineColumn2
        mc3 = mineColumn3
    }
    
    func restartGame() {
        for r in 0..<5 {
            for c in 0..<5 {
                grid[r][c] = .Tile
            }
        }
    }
}
