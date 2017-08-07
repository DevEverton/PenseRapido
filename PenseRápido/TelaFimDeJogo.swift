//
//  TelaFimDeJogo.swift
//  PenseRápido
//
//  Created by Everton Carneiro on 16/06/17.
//  Copyright © 2017 Everton. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class TelaFimDeJogo: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet weak var labelFinalScore: UILabel!
    @IBOutlet weak var referenceRestartButton: UIButton!
    @IBOutlet weak var bannerAd3: GADBannerView!
    
    
    
    
    var lastBestScore = Int()
    var finalScore = Int()
    var gameOverSound = AVAudioPlayer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelFinalScore.text = "Seu Score: \(finalScore)"
        
        do {
            gameOverSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "gameOver", ofType: "wav")!))
            
        }
        catch{
            
            print(error)
        }
        
        gameOverSound.play()
        
        //code block responsible for the ads
        let request3 = GADRequest()
        //request3.testDevices = ["128e94dd91c25a6fcb3ef877ecca6456"]
        bannerAd3.adUnitID = "ca-app-pub-4828696079960529/2391135499"
        bannerAd3.rootViewController = self
        bannerAd3.delegate = self
        bannerAd3.load(request3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveScoreUser(_ sender: Any) {
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToStart" {
            
           let firstScreenDestination: TelaInicial = segue.destination as! TelaInicial
            
            if finalScore > lastBestScore {
             UserDefaults.standard.set(finalScore, forKey: "lastBestScore")
            firstScreenDestination.lastBest = finalScore
                
            }else{
            UserDefaults.standard.set(lastBestScore, forKey: "lastBestScore")
            firstScreenDestination.lastBest = lastBestScore
           }
        }
        
    }
}
