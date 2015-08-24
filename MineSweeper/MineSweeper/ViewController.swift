//
//  ViewController.swift
//  MineSweeper
//
//  Created by Local Student on 14/06/15.
//  Copyright (c) 2015 AIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let minesweeper = MineSweeperModel.sharedModel
    
    
    
    
    var cellButtons = [UIButton]()
    var clicks: Int = 0
    var clicksMines: Int = 0
    enum PlayMode {
        case RevealField
        case PlaceFlag
    }
    
    @IBOutlet weak var smileyImage: UIImageView!
    @IBOutlet weak var clickCounter: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var playMode = PlayMode.RevealField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGameBoard()
    }

    func createGameBoard() {
        
        let buttonSize = CGSize(width: 40, height: 40)
        
        for r in 0..<5 {
            for c in 0..<5 {
                let button = UIButton.buttonWithType(.Custom) as! UIButton
                button.frame = CGRect(
                    x: 60 + CGFloat(c) * (buttonSize.width + 1),
                    y: 100 + CGFloat(r) * (buttonSize.height + 1),
                    width: buttonSize.width,
                    height: buttonSize.height)
                
                button.backgroundColor = UIColor.lightGrayColor()
                view.addSubview(button)
                cellButtons.append(button)
                
                button.addTarget(self, action: "handleButtonTap:", forControlEvents: .TouchUpInside)
                button.setBackgroundImage(UIImage(named: "MineSweeper-Tile.png"), forState: .Normal)
                configureButtonForRow(r, column: c)
                
            }
        }
        minesweeper.hideMines()
        clicks = 0
        clickCounter.text = "00"
    }
    

    
    @IBAction func handlePlayMode(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            playMode = .RevealField
        case 1:
            playMode = .PlaceFlag
        default:
            assert(false)
            break
        }    
    }

    
    func handleButtonTap(button: UIButton) {
        let buttonIndex = find(cellButtons, button)!
        
        let row = buttonIndex / 5
        let column = buttonIndex % 5
        
        minesweeper.markRow(row, column: column)
        configureButtonForRow(row, column: column)
//        clicks++
        clickCounter.text = "0\(clicks)"
        
    }
    
    func configureButtonForRow(row: Int, column: Int) {
        let mr1 = minesweeper.mr1
        let mr2 = minesweeper.mr2
        let mr3 = minesweeper.mr3
        let mc1 = minesweeper.mc1
        let mc2 = minesweeper.mc2
        let mc3 = minesweeper.mc3
        var mineCount = 0
        let button = cellButtons[row*5 + column]
        switch playMode {
        case .RevealField:
            switch minesweeper.contentForCell(row, column: column) {
            case .Empty:
                if row+1 >= 0 && row+1 <= 4 {
                    switch minesweeper.contentForCell(row+1, column: column) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if row-1 >= 0 && row-1 <= 4 {
                    switch minesweeper.contentForCell(row-1, column: column) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if row+1 >= 0 && row+1 <= 4 && column+1 >= 0 && column+1 <= 4 {
                    switch minesweeper.contentForCell(row+1, column: column+1) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if row-1 >= 0 && row-1 <= 4 && column-1 >= 0 && column-1 <= 4 {
                    switch minesweeper.contentForCell(row-1, column: column-1) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if row+1 >= 0 && row+1 <= 4 && column-1 >= 0 && column-1 <= 4 {
                    switch minesweeper.contentForCell(row+1, column: column-1) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if row-1 >= 0 && row-1 <= 4 && column+1 >= 0 && column+1 <= 4 {
                    switch minesweeper.contentForCell(row-1, column: column+1) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if column+1 >= 0 && column+1 <= 4 {
                    switch minesweeper.contentForCell(row, column: column+1) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if column-1 >= 0 && column-1 <= 4 {
                    switch minesweeper.contentForCell(row, column: column-1) {
                    case .Empty:
                        break
                    case .Mine :
                        mineCount++
                    default:
                        break
                    }
                }
                if mineCount == 2 {
                    button.setBackgroundImage(UIImage(named: "2.png"), forState: .Normal)
                    button.enabled = false
                }
                else if mineCount == 1 {
                    button.setBackgroundImage(UIImage(named: "1.png"), forState: .Normal)
                    button.enabled = false
                }
                else if mineCount == 3 {
                    button.setBackgroundImage(UIImage(named: "3.png"), forState: .Normal)
                    button.enabled = false
                }
                else if mineCount == 0 {
                    button.setBackgroundImage(UIImage(named: "MineSweeper-Background.png"), forState: .Normal)
                    button.enabled = false
                }
                clicks++
                if clicks == 22 {
                    smileyImage.image = UIImage(named: "face-shout.png")
                    let alertFinish = UIAlertController(title: "Get Ready!", message: "Hurry up and get those flags down! We're in enemy territory!", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "I'm going in.", style: .Default, handler: nil)
                    alertFinish.addAction(okAction)
                    presentViewController(alertFinish, animated: true, completion: nil)
                }
                
                if clicks == 25 && clicksMines == 3 {
                    win()
                }
            case .Mine:
                lose()
                for all in cellButtons {
                    all.enabled = false
                }
            default:
                button.setImage(nil, forState: .Normal)
            }
        case .PlaceFlag:
        switch minesweeper.contentForCell(row, column: column) {
        case .Empty:
            lose()
            for all in cellButtons {
                all.enabled = false
            }
        case .Mine:
            button.setBackgroundImage(UIImage(named: "mine-flag.png"), forState: .Normal)
            button.enabled = false
            clicks++
            clicksMines++
            if clicksMines == 3 {
                win()
            }
            
        default:
            button.setImage(nil, forState: .Normal)
        }
        }
    }
    
    func win() {
        for all in cellButtons {
            all.enabled = false
        }
        let alertWin = UIAlertController(title: "You Won!", message: "You Belong On The Battlefield!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertWin.addAction(okAction)
        presentViewController(alertWin, animated: true, completion: nil)
    }
    
    func lose() {
        smileyImage.image = UIImage(named: "face-mine.png")
        let row1 = minesweeper.mr1
        let row2 = minesweeper.mr2
        let row3 = minesweeper.mr3
        let column1 = minesweeper.mc1
        let column2 = minesweeper.mc2
        let column3 = minesweeper.mc3
        var button1 = UIButton.buttonWithType(.Custom) as! UIButton
        cellButtons.append(button1)
        let button1L = cellButtons[row1*5 + column1]
        var button2 = UIButton.buttonWithType(.Custom) as! UIButton
        cellButtons.append(button2)
        let button2L = cellButtons[row2*5 + column2]
        var button3 = UIButton.buttonWithType(.Custom) as! UIButton
        cellButtons.append(button3)
        let button3L = cellButtons[row3*5 + column3]
        button1L.setBackgroundImage(UIImage(named: "redmine.png"), forState: .Normal)
        button2L.setBackgroundImage(UIImage(named: "redmine.png"), forState: .Normal)
        button3L.setBackgroundImage(UIImage(named: "redmine.png"), forState: .Normal)
        let alertGameOver = UIAlertController(title: "You lose!", message: "Game Over", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            { action in
//            exit(0)
//        })
        alertGameOver.addAction(okAction)
        presentViewController(alertGameOver, animated: true, completion: nil)
    }
    
//    func endLostGame() {
//        let row1 = minesweeper.mr1
//        let row2 = minesweeper.mr2
//        let row3 = minesweeper.mr3
//        let column1 = minesweeper.mc1
//        let column2 = minesweeper.mc2
//        let column3 = minesweeper.mc3
//        var array: [[Int]] = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [4, 0], [4, 1], [4, 2], [4, 3], [4, 4]]
//        for each in 0..<array.count {
//            if array[each] == [row1, column1] || array[each] == [row2, column2] || array[each] == [row3, column3] {
//                array.removeAtIndex(each)
//            }
//        }
//        for all in 0..<array.count {
//            let button = UIButton.buttonWithType(.Custom) as! UIButton
//            cellButtons.append(button)
//            let button1L = cellButtons[array[0][0]*5 + array[0][1]]
//            button1L.setBackgroundImage(UIImage(named: "MineSweeper-Background.png"), forState: .Normal)
//        }
//    }
}
