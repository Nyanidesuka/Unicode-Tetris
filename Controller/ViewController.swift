//
//  ViewController.swift
//  gameboyTry2
//
//  Created by Haley Jones on 5/4/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class TetrisViewController: UIViewController {
    
    //MARK: Outlets and properties
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var tetrisTextField: UITextView!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    var currentBag: [minoShape] = [.i, .o, .j, .l, .s, .z, .t]
    var nextBag: [minoShape] = [.i, .o, .j, .l, .s, .z, .t]
    
    var playfield: [[String]] = []
    //by setting one mino as "active", we can make sure user inputs only move that 1 mino at a time,
    //and inactive minos should be super easy to clear.
    var activeMino: tetrimino?
    var stateOfGame = gameState.placingTetrimino
    var level = 1
    var gravityInterval = 60
    var gravityIntervalMax = 45
    var score = 0
    let emptyChar = "⬛️"
    //🔘
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a CADisplayLink
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
        
        //make the playfield array
        for _ in 1...16{
            //make an array that contains sixteen arrays!!
            //each aray is one row on the play field
            var loopArray = [emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar,emptyChar, emptyChar, emptyChar]
            //i fill it with 10 emptyChar because emptyChar is the blank space and they should start blank
            playfield.append(loopArray)
            //so now, the y coordinate is the first position in playfield, and the x cordinate is the second.
        }
        currentBag.shuffle()
        scoreLabel.text = String(score)
    }
    
    //button actions
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        moveTetriminoHorizontal(direction: "left")
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        moveTetriminoHorizontal(direction: "right")
    }
    
    //rotate pieces and dang this is gonna suck
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        guard let targetMino = activeMino else {return}
        let originalRotation = targetMino.rotation
        undrawMino()
        updatePlayfield()
        switch targetMino.rotation{
        case .original:
            targetMino.rotation = .ninetyCW
            targetMino.updateBlocks(forTetrimino: targetMino)
            if canWeRotate(previousRotation: originalRotation) == true{
                drawMino()
                updatePlayfield()
            }
            else{
                targetMino.rotation = .original
                targetMino.updateBlocks(forTetrimino: targetMino)
                drawMino()
            }
            return
        case .ninetyCW:
            targetMino.rotation = .oneEightCW
            targetMino.updateBlocks(forTetrimino: targetMino)
            if canWeRotate(previousRotation: originalRotation) == true{
                drawMino()
                updatePlayfield()
            }
            else{
                targetMino.rotation = .ninetyCW
                targetMino.updateBlocks(forTetrimino: targetMino)
                drawMino()
            }
            return
        case .oneEightCW:
            targetMino.rotation = .twoSeventyCW
            targetMino.updateBlocks(forTetrimino: targetMino)
            if canWeRotate(previousRotation: originalRotation) == true{
                drawMino()
                updatePlayfield()
            }
            else{
                targetMino.rotation = .oneEightCW
                targetMino.updateBlocks(forTetrimino: targetMino)
                drawMino()
            }
            return
        case .twoSeventyCW:
            targetMino.rotation = .original
            targetMino.updateBlocks(forTetrimino: targetMino)
            if canWeRotate(previousRotation: originalRotation) == true{
                drawMino()
                updatePlayfield()
            }
            else{
                targetMino.rotation = .twoSeventyCW
                targetMino.updateBlocks(forTetrimino: targetMino)
                drawMino()
            }
            drawMino()
            updatePlayfield()
            return
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        gravityOnActiveMino()
        print("gravity button pressed")
        gravityInterval = gravityIntervalMax
    }
    
    //system funkies
    
    //this checks the array and fills in the text field accordingly
    func updatePlayfield(){
        var updateText = ""
        for row in playfield{
            guard let targetRow = playfield.firstIndex(of: row) else {return}
            var loopLap = 0
            while loopLap <= 9 {
                let addLetter:String = playfield[targetRow][loopLap]
                updateText.append(addLetter)
                loopLap += 1
            }
            updateText.append("\n")
        }
        print(updateText)
        //oh my god it works hell yeah
        tetrisTextField.text = updateText
        print("update play field fired")
    }
    //oh my god it works hell yeah
    
    //ok this one will be hard
    func spawnTetrimino(mino: tetrimino){
        print("spawn tetromino fired")
        activeMino = mino
        //for my reference, the origin is at:
        //0, 4
        // this means when im doing coordinated it's y,x not x,y!!!!!!!!
        //so now we need to change the array
        //add the first mino of the block to the playfield
        //im gonna use this block to also check for fail state
        guard let blockEmoji = activeMino?.emoji else {return}
        guard let originTargetX = activeMino?.firstBlock[1], let originTargetY = activeMino?.firstBlock[0] else {return}
        if playfield[originTargetY][originTargetX] != emptyChar{
            stateOfGame = .gameOver
            return
        }
        playfield[originTargetY][originTargetX] = blockEmoji
        guard let blockTwoX = activeMino?.secondBlock[1], let blockTwoY = activeMino?.secondBlock[0] else {return}
        if playfield[blockTwoY][blockTwoX] != emptyChar{
            stateOfGame = .gameOver
            return
        }
        playfield[blockTwoY][blockTwoX] = blockEmoji
        guard let block3X = activeMino?.thirdBlock[1], let blockThreeY = activeMino?.thirdBlock[0] else {return}
        if playfield[blockThreeY][block3X] != emptyChar{
            stateOfGame = .gameOver
            return
        }
        playfield[blockThreeY][block3X] = blockEmoji
        guard let block4X = activeMino?.fourthBlock[1], let block4Y = activeMino?.fourthBlock[0] else {return}
        if playfield[block4Y][block4X] != emptyChar{
            stateOfGame = .gameOver
            return
        }
        playfield[block4Y][block4X] = blockEmoji
        updatePlayfield()
    }
    
    //wow look there grabidy. This will fiew every x frames; adjustable for difficulty!
    func gravityOnActiveMino(){
        print("gravity on mino fired")
        guard let targetMino = activeMino else {return}
        print(targetMino.origin)
        print("oob check")
        //checking to see if the mino is about to move OOB.
        if (OOBCheckVertical() == true){
            print("the mino would move out of bounds. Stopping it.")
            lockDownTetrimino()
            checkForClears()
            updatePlayfield()
            return
        }
        
        //clear the current mino from the screen, we will redraw it in a sec
        undrawMino()
        //after this i need to check for collision with other tetriminos
        if (veritcalCollision() == true){
            print("the mino has collided with a mino below it. Stopping it.")
            drawMino()
            lockDownTetrimino()
            checkForClears()
            updatePlayfield()
            return
        }
        print("we tried to reset the characters in the array")
        print(targetMino.origin)
        //so then weeeee update the origin of this active block, then update all of its blocks
        targetMino.origin[0] += 1
        targetMino.updateBlocks(forTetrimino: targetMino)

        //and after that we redraw it in it new spot
        print(targetMino.origin[0])
        drawMino()
        print("we tried to draw the characters ot the screen")
        print(targetMino.origin)
 
        //then update the field
        updatePlayfield()
    }
    
    //let the tetrimino move left and right.
    func moveTetriminoHorizontal(direction: String){
        guard let targetMino = activeMino else {return}
        //make sure we dont move OOB
        if (OOBCheckHorizontal(direction: direction) == true){
            print("the mino would move out of bounds horizontally. Stopping it.")
            return
        }
        undrawMino()
        //will also test for collision w/ other tetriminos when i write that!
        //Doing it after i undraw the mino to avoid coliding with itself.
        if (horizontalCollision(direction: direction) == true){
            print("the mino would collide with another mino horizontally. Stopping it.")
            drawMino()
            return
        }
        if (direction == "right"){
            targetMino.origin[1] += 1
        }
        if (direction == "left"){
            targetMino.origin[1] -= 1
        }
        targetMino.updateBlocks(forTetrimino: targetMino)
        drawMino()
        updatePlayfield()
    }
    
    //this function is gonna tell the tetrimino when it's hit the bottom of the playspace.
    func OOBCheckVertical() -> Bool{
        guard let checkMino = activeMino else {return true}
        //check each block of the tetrimino;
        //At the y position it's at, would moving down put you outside the index of playfield?
        //i might make the playfield taller later so im trying to code this to be adaptable to that
        if (checkMino.firstBlock[0] + 1 >= playfield.count){
            return true
        }else if (checkMino.secondBlock[0] + 1 >= playfield.count){
            return true
        }else if (checkMino.thirdBlock[0] + 1 >= playfield.count){
            return true
        }else if (checkMino.fourthBlock[0] + 1 >= playfield.count){
            return true
        }else{
            return false
        }
    }
    
    //This function will check if the tetrimino is about to collide with another tetrimino below it.
    //We only need below because a tetrmimino can never move upwards.
    func veritcalCollision() -> Bool{
        guard let checkMino = activeMino else {return true}
        //check each block of the tetrimino;
        //At the y position it's at, would moving down put you outside the index of playfield?
        //i might make the playfield taller later so im trying to code this to be adaptable to that
        //first we gotta find what character is in the potential new position. There's a better way to do this than 4 constants, will refactor eventually.
        let checkSpotOne: String = playfield[checkMino.firstBlock[0] + 1 ][checkMino.firstBlock[1]]
        let checkSpotTwo: String = playfield[checkMino.secondBlock[0] + 1 ][checkMino.secondBlock[1]]
        let checkSpotThree: String = playfield[checkMino.thirdBlock[0] + 1 ][checkMino.thirdBlock[1]]
        let checkSpotFour: String = playfield[checkMino.fourthBlock[0] + 1 ][checkMino.fourthBlock[1]]
        //then compare it to figure out if it's empty
        if (checkSpotOne != emptyChar){
            //if it isnt != emptyChar) it's not empty, therefore there's a block in there so. collide.
            return true
        }else if (checkSpotTwo != emptyChar){
            return true
        }else if (checkSpotThree != emptyChar){
            return true
        }else if (checkSpotFour != emptyChar){
            return true
        }else{
            return false
        }
    }
    
    //this will prevent tetriminos from going outside the array left or right
    //this i can hard code because i know the play field will always be 10 wide
    func OOBCheckHorizontal(direction: String) -> Bool{
        guard let checkMino = activeMino else {return true}
        if direction == "right"{
            if checkMino.firstBlock[1] + 1 >= 10{
                return true
            } else if checkMino.secondBlock[1] + 1 >= 10{
                return true
            } else if checkMino.thirdBlock[1] + 1 >= 10{
                return true
            } else if checkMino.fourthBlock[1] + 1 >= 10{
                return true
            } else{
                return false
            }
        } else if direction == "left"{
            if checkMino.firstBlock[1] - 1 < 0{
                return true
            } else if checkMino.secondBlock[1] - 1 < 0{
                return true
            } else if checkMino.thirdBlock[1] - 1 < 0{
                return true
            } else if checkMino.fourthBlock[1] - 1 < 0{
                return true
            } else{
                return false
            }
        }
        return true
    }
    
    //this one will check to see if there's a collision with another tetrimino
    func horizontalCollision(direction: String) -> Bool{
        guard let checkMino = activeMino else {return true}
        var checkSpotOne = ""
        var checkSpotTwo = ""
        var checkSpotThree = ""
        var checkSpotFour = ""
        if direction == "right"{
            checkSpotOne = playfield[checkMino.firstBlock[0]][checkMino.firstBlock[1] + 1]
            checkSpotTwo = playfield[checkMino.secondBlock[0]][checkMino.secondBlock[1] + 1]
            checkSpotThree = playfield[checkMino.thirdBlock[0]][checkMino.thirdBlock[1] + 1]
            checkSpotFour = playfield[checkMino.fourthBlock[0]][checkMino.fourthBlock[1] + 1]
        } else if direction == "left"{
            checkSpotOne = playfield[checkMino.firstBlock[0]][checkMino.firstBlock[1] - 1]
            checkSpotTwo = playfield[checkMino.secondBlock[0]][checkMino.secondBlock[1] - 1]
            checkSpotThree = playfield[checkMino.thirdBlock[0]][checkMino.thirdBlock[1] - 1]
            checkSpotFour = playfield[checkMino.fourthBlock[0]][checkMino.fourthBlock[1] - 1]
        } else{
            return true
        }
        //now we have all the spots to check so lets see if theyre empty
        if checkSpotOne != emptyChar{
            return true
        } else if checkSpotTwo != emptyChar{
            return true
        } else if checkSpotThree != emptyChar{
            return true
        } else if checkSpotFour != emptyChar{
            return true
        }
        return false
    }
    
    //this function "locks down" the active mino. Tells the game there's no tetrimino it should be able to control, and
    //also sets the game state so it can wait a few frames before spawning a new mino
    func lockDownTetrimino(){
        activeMino = nil
        //stateOfGame = .waitBetweenTetriminos
    }
    
    //this function will check if any lines are complete and therefore, according to the rules of tetris, should be cleared.
    func checkForClears(){
        var linesCleared = 0
        for row in playfield{
            //if there are no 🔘 in the row, we know it has no empty spots. so it's full.
            if !row.contains(emptyChar){
                guard let targetRow = playfield.firstIndex(of: row) else {return}
                playfield[targetRow] = [emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar,emptyChar, emptyChar, emptyChar]
                linesCleared += 1
            }
        }
        if linesCleared != 0 {
            //drop the stack once for every line that was cleared.
            for _ in 1...linesCleared{
            dropTheStack()
            }
            switch linesCleared{
            case 1:
                score += (100 * level)
            case 2:
                score += (300 * level)
            case 3:
                score += (500 * level)
            case 4:
                score += (800 * level)
            default:
                score += 0
            }
            scoreLabel.text = String(score)
        }
        updatePlayfield()
    }
    
    //after lines are cleared, drop the stack
    func dropTheStack(){
        //we want to do this from the bottom up.
        var targetRow = playfield.count - 1
        //it should never run for row 0 because nothing wil ever drop onto row 0.
        while (targetRow > 0){
            //if the row is empty
            if playfield[targetRow] == [emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar,emptyChar, emptyChar, emptyChar]{
                //make the empty row equal to the one above it
                playfield[targetRow] = playfield[targetRow - 1]
                //then empty out the row above it so it looks like the row dropped down
                //also so it's empty for the logic to repeat.
                playfield[targetRow - 1] = [emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar, emptyChar,emptyChar, emptyChar, emptyChar]
            }
            //decrement targetRow so it repeats this logic on the row above it.
            targetRow -= 1
        }
    }
    
    //function to see if we can rotate
    func canWeRotate(previousRotation: blockRotation) -> Bool{
        //this function assumes you've already changed the rotation and run updateBlocks() but have not yet updated the playfield array
        //so if this returns false you could just put the rotation back how it was and updateBlocks() again.
        guard let targetMino = activeMino else {return false}
        if wouldRotateOOB(targetMino: targetMino) == true{
            if canWeKick(targetMino: targetMino) == false{
                return false
            }
        }
        undrawMino()
        var checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
        var checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
        var checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
        var checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
        if checkSpot1 == emptyChar &&
        checkSpot2 == emptyChar &&
        checkSpot3 == emptyChar &&
            checkSpot4 == emptyChar{
            drawMino()
            return true
        }
        //gonna try to bs a kick method because guideline tetris kicks would take too much time for a project i cant even put on the app store
        //and i wont know the difference when im playing
        if canWeKick(targetMino: targetMino) == true{
            //do the kick, then
            return true
        }
        return false
    }
    
    //a whole function for wallkicking off the sides of the well
    
    
    //a whole function to test for wallkicks just off of other minos
    func canWeKick(targetMino: tetrimino) -> Bool{
        var checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
        var checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
        var checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
        var checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
        //test 1 to the left
        if (targetMino.origin[1] != 0){
            targetMino.origin[1] -= 1
            targetMino.updateBlocks(forTetrimino: targetMino)
            if wouldRotateOOB(targetMino: targetMino) == false{
                //update the places we're checking
                checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                if checkSpot1 == emptyChar &&
                    checkSpot2 == emptyChar &&
                    checkSpot3 == emptyChar &&
                    checkSpot4 == emptyChar{
                    return true
                }
            }
        }
        //test 2 to the left if it's an i
        if targetMino.shape == .i{
            if (targetMino.origin[1] != 0){
                targetMino.origin[1] -= 1
                targetMino.updateBlocks(forTetrimino: targetMino)
                if wouldRotateOOB(targetMino: targetMino) == false{
                    //update the places we're checking
                    checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                    checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                    checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                    checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                    if checkSpot1 == emptyChar &&
                        checkSpot2 == emptyChar &&
                        checkSpot3 == emptyChar &&
                        checkSpot4 == emptyChar{
                        return true
                    }
                }
            }
            targetMino.origin[1] -= 1
            targetMino.updateBlocks(forTetrimino: targetMino)
        }
        //reset to the original position
        targetMino.origin[1] += 2
        //test 1 to the right
        if (targetMino.origin[1] < 10){
            targetMino.origin[1] += 1
            targetMino.updateBlocks(forTetrimino: targetMino)
                if wouldRotateOOB(targetMino: targetMino) == false{
                //update the places we're checking
                checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                if checkSpot1 == emptyChar &&
                    checkSpot2 == emptyChar &&
                    checkSpot3 == emptyChar &&
                    checkSpot4 == emptyChar{
                    return true
                }
            }
        }
        //test 2 to the right if its an i
        if targetMino.shape == .i{
            if (targetMino.origin[1] < 10){
                targetMino.origin[1] += 1
                targetMino.updateBlocks(forTetrimino: targetMino)
                if wouldRotateOOB(targetMino: targetMino) == false{
                    //update the places we're checking
                    checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                    checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                    checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                    checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                    if checkSpot1 == emptyChar &&
                        checkSpot2 == emptyChar &&
                        checkSpot3 == emptyChar &&
                        checkSpot4 == emptyChar{
                        return true
                    }
                }
            }
            targetMino.origin[1] -= 1
            targetMino.updateBlocks(forTetrimino: targetMino)
        }
        //test 1 down
        if targetMino.origin[0] < 15{
            targetMino.origin[0] += 1
            targetMino.updateBlocks(forTetrimino: targetMino)
            if wouldRotateOOB(targetMino: targetMino) == false{
                //update the places we're checking
                checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                if checkSpot1 == emptyChar &&
                    checkSpot2 == emptyChar &&
                    checkSpot3 == emptyChar &&
                    checkSpot4 == emptyChar{
                    return true
                }
            }
        }
        //test 1 up
        if targetMino.origin[0] < 1{
            targetMino.origin[0] -= 2
            targetMino.updateBlocks(forTetrimino: targetMino)
            if wouldRotateOOB(targetMino: targetMino) == false{
            //update the places we're checking
                checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                if checkSpot1 == emptyChar &&
                    checkSpot2 == emptyChar &&
                    checkSpot3 == emptyChar &&
                    checkSpot4 == emptyChar{
                    return true
                }
            }
        }
        //test 2 up if it's an i
        if targetMino.shape == .i{
            if targetMino.origin[0] < 1{
                targetMino.origin[0] -= 1
                targetMino.updateBlocks(forTetrimino: targetMino)
                //check for OOB rotation
                if wouldRotateOOB(targetMino: targetMino) == false{
                    //update the places we're checking
                    checkSpot1 = playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]]
                    checkSpot2 = playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]]
                    checkSpot3 = playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]]
                    checkSpot4 = playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]]
                    if checkSpot1 == emptyChar &&
                        checkSpot2 == emptyChar &&
                        checkSpot3 == emptyChar &&
                        checkSpot4 == emptyChar{
                        return true
                    }
                }
            }
            targetMino.origin[0] += 1
            targetMino.updateBlocks(forTetrimino: targetMino)
        }
        //reset to neutral, update blocks
        targetMino.origin[0] -= 1
        targetMino.updateBlocks(forTetrimino: targetMino)
        return false
    }
    
    //a whole function to see if rotating would put you OOB
    func wouldRotateOOB(targetMino: tetrimino) -> Bool{
        if targetMino.firstBlock[0] < playfield.count - 1 &&
        targetMino.firstBlock[1] < 10 &&
        targetMino.secondBlock[0] < playfield.count - 1 &&
        targetMino.secondBlock[1] < 10 &&
        targetMino.thirdBlock[0] < playfield.count - 1 &&
        targetMino.thirdBlock[1] < 10 &&
        targetMino.fourthBlock[0] < playfield.count - 1 &&
            targetMino.fourthBlock[1] < 10{
            return false
        }
        //get back in bounds horizontally
        while areWeOOBHorizontalRight() == true{
            targetMino.origin[1] -= 1
            targetMino.updateBlocks(forTetrimino: targetMino)
        }
        while areWeOOBHorizontalLeft() == true{
            targetMino.origin[1] += 1
            targetMino.updateBlocks(forTetrimino: targetMino)
        }
        //get back in bounds vertically
        while areWeOOBVertical() == true{
            targetMino.origin[0] -= 1
            targetMino.updateBlocks(forTetrimino: targetMino)
        }
        if targetMino.firstBlock[0] < playfield.count - 1 &&
            targetMino.firstBlock[1] < 10 &&
            targetMino.secondBlock[0] < playfield.count - 1 &&
            targetMino.secondBlock[1] < 10 &&
            targetMino.thirdBlock[0] < playfield.count - 1 &&
            targetMino.thirdBlock[1] < 10 &&
            targetMino.fourthBlock[0] < playfield.count - 1 &&
            targetMino.fourthBlock[1] < 10{
            return false
        }
        return true
    }
    
    //undraw a tetrimino
    func undrawMino(){
        guard let targetMino = activeMino else {return}
        playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]] = emptyChar
        playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]] = emptyChar
        playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]] = emptyChar
        playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]] = emptyChar
    }
    
    //redraw a mino
    func drawMino(){
        guard let targetMino = activeMino else {return}
        guard let blockEmoji = targetMino.emoji else {return}
        playfield[targetMino.firstBlock[0]][targetMino.firstBlock[1]] = blockEmoji
        playfield[targetMino.secondBlock[0]][targetMino.secondBlock[1]] = blockEmoji
        playfield[targetMino.thirdBlock[0]][targetMino.thirdBlock[1]] = blockEmoji
        playfield[targetMino.fourthBlock[0]][targetMino.fourthBlock[1]] = blockEmoji
    }
    
    //so many functions
    func areWeOOBVertical() -> Bool{
        guard let targetMino = activeMino else {return true}
        if targetMino.firstBlock[0] > playfield.count - 1 ||
            targetMino.secondBlock[0] > playfield.count - 1 ||
            targetMino.thirdBlock[0] > playfield.count - 1 ||
            targetMino.fourthBlock[0] > playfield.count - 1{
            return true
        }
        return false
    }
    
    func areWeOOBHorizontalRight() -> Bool{
        guard let targetMino = activeMino else {return true}
        if targetMino.firstBlock[1] >= 10 ||
            targetMino.secondBlock[1] >= 10 ||
            targetMino.thirdBlock[1] >= 10 ||
            targetMino.fourthBlock[1] >= 10{
            return true
        }
        return false
    }
    
    func areWeOOBHorizontalLeft() -> Bool{
        guard let targetMino = activeMino else {return true}
        if targetMino.firstBlock[1] < 0 ||
            targetMino.secondBlock[1] < 0 ||
            targetMino.thirdBlock[1] < 0 ||
            targetMino.fourthBlock[1] < 0{
            return true
        }
        return false
    }
    
    
    //make sure we always have a new bag ready
    func bagMaintenance(){
        currentBag = nextBag
        currentBag.shuffle()
        nextBag = [.i, .o, .j, .l, .s, .z, .t]
    }
    
    //MARK: Gameplay Loop
    //the code in here will be executed every frame. So this will be like... the whole-ass game!
    @objc func handleUpdate(){
        //spawn a new tetrimino if we're in the state of moving one around but we dont have one active
        if (stateOfGame == gameState.placingTetrimino){
            if activeMino == nil{
                //create a tetrimino
                if currentBag.isEmpty{
                    bagMaintenance()
                }
                //this line of code picks a random mino from the bag
                guard let randomShape = currentBag.randomElement() else {return}
                //then removes that mino from the bag we're getting out shapes from, which should mean we get 1 of every mino before getting a duplicate
                guard let removeIndex = currentBag.firstIndex(of: randomShape) else {return}
                currentBag.remove(at: removeIndex)
                let spawnmino = tetrimino(shape: randomShape)
                //and spawn it
                spawnTetrimino(mino: spawnmino)
            }
            //tick down gravity's interval
            if gravityInterval > 0{
                gravityInterval -= 1
            } else {
                gravityInterval = gravityIntervalMax
                gravityOnActiveMino()
            }
        }
        
    }
    
}

