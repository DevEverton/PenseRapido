//
//  TelaInicial.swift
//  PenseRápido
//
//  Created by Everton Carneiro on 16/06/17.
//  Copyright © 2017 Everton. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import Social
import CoreData

class TelaInicial: UIViewController, GADBannerViewDelegate {
    
    
    var lastBest = Int()
    var playGame = AVAudioPlayer()
  
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var bannerAd1: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lastBestScore = UserDefaults.standard.object(forKey: "lastBestScore") as? Int {
            UserDefaults.standard.synchronize()
            lastBest = lastBestScore
            recordLabel.text = "Recorde: \(lastBest)"
            
        }
        
       /*CORE DATA CODE
         
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBest = NSEntityDescription.insertNewObject(forEntityName: "Score", into: context)
        
        newBest.setValue(lastBest, forKey: "bestscore")
        do{
            try context.save()
            
        }
        catch{
            print(error)
            
        }
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject]{
                
                
                let lastBestSaved = result.value(forKey: "bestscore") as? Int16
                recordLabel.text = "Recorde: \(lastBestSaved!)"
                print("ULTIMO SCORE GRAVADO: \(lastBestSaved!)")
                
                
            }
            
        }
        catch{
            
            print(error)
        }
        */

        
        //code for play sound
        
        do{
            playGame = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "playGame", ofType: "wav")!))
            
        }
        catch {
            
            print(error)
        }
        //code block responsible for the ads
        let request1 = GADRequest()
        //request1.testDevices = ["128e94dd91c25a6fcb3ef877ecca6456"]
        bannerAd1.adUnitID = "ca-app-pub-4828696079960529/2391135499"
        bannerAd1.rootViewController = self
        bannerAd1.delegate = self
        bannerAd1.load(request1)
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        //  let FaceBookSheet: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        //  self.present(FaceBookSheet, animated: true, completion: nil)
        
        /*THIS CODE SHARE A PRINT SCREEN ON FACEBBOK
         */
        let screen = UIScreen.main
        
        if let window = UIApplication.shared.keyWindow {
            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeSheet?.setInitialText("Saca só meu recorde! Qual é o seu?")
            composeSheet?.add(image)
            
            present(composeSheet!, animated: true, completion: nil)
        }

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             
    if segue.identifier == "startButton" {
      playGame.play()
      let destination: TelaJogo = segue.destination as! TelaJogo
            
      let (generateFirstRandomCalc, firstResult) = randomCalculationGenerator()
      destination.StringLabelCalculoShow = generateFirstRandomCalc
      destination.result = firstResult
        
      let firstRandomNumber = randomNumberToCompare()
      destination.StringNumberToCompare = "\(firstRandomNumber)"
      destination.randomNumber = firstRandomNumber
      destination.bestScore = lastBest
            
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

    
}
