//
//  ViewController.swift
//  Swift_MBSimpleLoadingIndicator
//
//  Created by Matt Brenman on 1/8/15.
//  Copyright (c) 2015 mbrenman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var loadview: MBLoadingIndicator = MBLoadingIndicator()
        
        self.view.addSubview(loadview)
        loadview.start()
        
        var count:Int = 0
        
        while count++ < 10 {
            let timeDelay:Double = Double(count) * 1.7
            let c:Int = count
            delay(timeDelay, {
                loadview.incrementPercentageBy(17);
                NSLog("%d", c)
                if (c % 2 == 0) {
                    //Change colors
                    loadview.setLoadedColor(UIColor.purpleColor())
                    loadview.setLoaderBackgroundColor(UIColor.whiteColor())
                    loadview.setBackColor(UIColor.blueColor())
                
                    //Change widths
                    loadview.setWidth(15);
                    loadview.setOuterLoaderBuffer(0)
                } else {
                    //Change colors
                    loadview.setLoadedColor(UIColor.lightGrayColor())
                    loadview.setLoaderBackgroundColor(UIColor.greenColor())
                    loadview.setBackColor(UIColor.darkGrayColor())
                
                    //Change widths
                    loadview.setWidth(5);
                    loadview.setOuterLoaderBuffer(10)
                }
                
                return
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}

