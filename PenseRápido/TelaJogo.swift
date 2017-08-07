//
//  TelaJogo.swift
//  PenseRápido
//
//  Created by Everton Carneiro on 16/06/17.
//  Copyright © 2017 Everton. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class TelaJogo: UIViewController, GADBannerViewDelegate {
    
    
  
    @IBOutlet weak var labelCalculoShow: UILabel!
    @IBOutlet weak var numberToCompare: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelBestScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var bannerAd2: GADBannerView!
    
    //this two variables stores the data from the segue in order to generate the first calculations
    //on the screen
    var StringLabelCalculoShow = String()
    var StringNumberToCompare = String()
    
    var score = Int()
    var bestScore = Int()
    var generateRandomCalc = String()
    var result = Int()
    var randomNumber = Int()
    
    var buttonSound = AVAudioPlayer()
    var timerSound = AVAudioPlayer()
    
    var counter = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCalculoShow.text = StringLabelCalculoShow
        numberToCompare.text = StringNumberToCompare
        labelBestScore.text = (": \(bestScore)")
        
        do{
            buttonSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "button clicked", ofType: "wav")!))
           timerSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "timerSound", ofType: "wav")!))
            
            
        }
        catch {
            
            print(error)
        }
        
        counter = 5
        labelTimer.text = (": \(counter)")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TelaJogo.updateCounter), userInfo: nil, repeats: true)
      
        //code block responsible for the ads
        let request2 = GADRequest()
        //request2.testDevices = ["128e94dd91c25a6fcb3ef877ecca6456"]
        bannerAd2.adUnitID = "ca-app-pub-4828696079960529/2391135499"
        bannerAd2.rootViewController = self
        bannerAd2.delegate = self
        bannerAd2.load(request2)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timerSound.play()
        timerSound.numberOfLoops = -1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateCounter (){
        counter -= 1
        labelTimer.text = (": \(counter)")
        if counter == 0 {
            timerSound.stop()
            performSegue(withIdentifier: "toTheGameOverScreen", sender: (Any).self)
        }
    }

    
    func randomNumberToCompare() -> Int{
          //generate a random number
        let randomNumber: Int = Int(arc4random_uniform(30))
        return randomNumber
    }
    
    func randomCalculationGenerator() -> (String, Int) {
        //this function generate a random calculation 
        
        var labelCalculo: String = ""
        let counter = arc4random_uniform(7)
        var result: Int = 0
        
        
        var num1: Int = Int(arc4random_uniform(11))
        if num1 == 0 {
            num1 += 1
        }
        var num2: Int = Int(arc4random_uniform(11))
        if num2 == 0 {
            num2 += 1
        }
        var num3: Int = Int(arc4random_uniform(11))
        if num3 == 0 {
            num3 += 1
        }
        
        switch counter {
        case 0:
            let result = (num1 * num2) + num3
            let labelCalculo = "\(num1) x \(num2) + \(num3)"
            return (labelCalculo, result)
        case 1:
            let result = (num1 / num2) + num3
            let labelCalculo = "\(num1) ÷ \(num2) + \(num3)"
            return (labelCalculo, result)
        case 2:
            let result = (num1 * num2) - num3
            let labelCalculo = "\(num1) x \(num2) - \(num3)"
            return (labelCalculo, result)
        case 3:
            let result = num1 + (num2 * num3)
            let labelCalculo = "\(num1) + \(num2) x \(num3)"
            return (labelCalculo, result)
        case 4:
            let result = num1 - (num2 * num3)
            let labelCalculo = "\(num1) - \(num2) x \(num3)"
            return (labelCalculo, result)
        case 5:
            let result = num1 + (num2 / num3)
            let labelCalculo = "\(num1) + \(num2) ÷ \(num3)"
            return (labelCalculo, result)
        case 6:
            let result = num1 - (num2 / num3)
            let labelCalculo = "\(num1) - \(num2) ÷ \(num3)"
            return (labelCalculo, result)
        default:
            break
        }
        return (labelCalculo , result)
    }
    
    @IBAction func ArrowUp(_ sender: Any) {
        
        buttonSound.play()
        counter = 6
        if result >= randomNumber {
            score += 1
            labelScore.text = "Score: \(score)"
            
            var (newGenerateRandomCalc, newResult) = randomCalculationGenerator()
            generateRandomCalc = newGenerateRandomCalc
            result = newResult
            labelCalculoShow.text = generateRandomCalc
            
            randomNumber = randomNumberToCompare()
            numberToCompare.text = "\(randomNumber)"
            
            
        }else {
            //call the game over screen if the answer is wrong
            timerSound.stop()
            performSegue(withIdentifier: "toTheGameOverScreen", sender: (Any).self)
          
        }
        
    }
    
    @IBAction func ArrowDown(_ sender: Any) {
        
        buttonSound.play()
        counter = 6
        if result <= randomNumber {
            score += 1
            labelScore.text = "Score: \(score)"
            
            var (newGenerateRandomCalc, newResult) = randomCalculationGenerator()
            generateRandomCalc = newGenerateRandomCalc
            result = newResult
            labelCalculoShow.text = generateRandomCalc
            
            randomNumber = randomNumberToCompare()
            numberToCompare.text = "\(randomNumber)"

        }else {
            //call the game over screen if the answer is wrong
            timerSound.stop()
            performSegue(withIdentifier: "toTheGameOverScreen", sender: (Any).self)
            
        }
        
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == "toTheGameOverScreen" {
        
            //send the final score to the next screen
           let nextDestination: TelaFimDeJogo = segue.destination as! TelaFimDeJogo
           nextDestination.finalScore = score
           nextDestination.lastBestScore = bestScore
        }
    
        
     }
    
}
