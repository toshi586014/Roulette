//
//  RouletteViewController.swift
//  Roulette
//
//  Created by Toshiaki Nakamura on 2016/09/20.
//  Copyright © 2016年 Toshiaki Nakamura. All rights reserved.
//

import UIKit

class RouletteViewController: UIViewController {
    
    @IBOutlet weak var luckyTextView: UITextView!
    
    private var entries = [String]()
    // MARK: ここに当選者の人数を登録してね
    private let luckyNumber = 9
    
    // MARK: - オーバーライドメソッド
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // MARK: この配列に当選者を登録してね
        self.entries = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        self.shuffleArray()
        self.updateTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - メソッド
    func shuffleArray(){
        let total = self.entries.count
        var i: Int = total
        while i > 0 {
            let j: Int = Int(arc4random_uniform(UInt32(i)))
            let tmpArray = self.entries[j]
            self.entries[j] = self.entries[i - 1]
            self.entries[i - 1] = tmpArray
            i = i - 1
        }
    }
    
    func updateTextView() {
        for i in 0..<self.luckyNumber {
            let luckyPerson = self.entries[i]
            self.luckyTextView.text = self.luckyTextView.text.stringByAppendingString(luckyPerson)
            self.luckyTextView.text = self.luckyTextView.text.stringByAppendingString("\n")
        }
    }
    
    // MARK: - IBACtion
    @IBAction func pushBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
