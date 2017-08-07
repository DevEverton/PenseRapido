//
//  TelaInfo.swift
//  PenseRápido
//
//  Created by Everton Carneiro on 04/07/17.
//  Copyright © 2017 Everton. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TelaInfo: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet weak var bannerAd4: GADBannerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //code block responsible for the ads
        let request4 = GADRequest()
        //request4.testDevices = ["128e94dd91c25a6fcb3ef877ecca6456"]
        bannerAd4.adUnitID = "ca-app-pub-4828696079960529/2391135499"
        bannerAd4.rootViewController = self
        bannerAd4.delegate = self
        bannerAd4.load(request4)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
