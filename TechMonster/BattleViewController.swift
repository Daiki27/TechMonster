//
//  BattleViewController.swift
//  TechMonster
//
//  Created by 樋口大樹 on 2017/04/20.
//  Copyright © 2017年 樋口大樹. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    var enemy: Enemy!
    var player: Player!
    var enemyAttackTimer: Timer!
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var attackButton: UIButton!
    
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var playerImageView: UIImageView!
    
    @IBOutlet var enemyHPBar: UIProgressView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0 ,y: 4.0)
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0 ,y: 4.0)
        
        playerNameLabel.text = player.name
        playerImageView.image = player.image
        playerHPBar.progress = player.currentHP / player.maxHP
        
        startBattle()
    }
    
    @IBAction func playerAttack() {
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        enemy.currentHP = enemy.currentHP - player.attackPower
        enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP, animated: true)
        
        if enemy.currentHP < 0 {
            TechDraUtil.animateDamage(enemyImageView)
            finishBattle(winPlayer: true)
        }
    }
    
    func startBattle(){
        TechDraUtil.playBGM(fileName: "BGM_battle001")
        
        enemy = Enemy()
        
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
        
        attackButton.isHidden = false
        
        enemyAttackTimer = Timer.scheduledTimer(timeInterval: enemy.attackInterval, target: self,
                                                selector: #selector(self.enemyAttack), userInfo:nil, repeats: true)
    }
    
    func finishBattle(winPlayer: Bool) {
        TechDraUtil.stopBGM()
        
        attackButton.isHidden = true
        
        enemyAttackTimer.invalidate()
        
        let finishedMesseage: String
        if winPlayer == true {
            TechDraUtil.playSE(fileName: "SE_fanfare")
            finishedMesseage = "プレイヤーの勝利!!"
        }else{
            TechDraUtil.playSE(fileName: "SE_gameover")
            finishedMesseage = "プレイヤーの敗北..."
        }
        let alert = UIAlertController(title: "バトル終了!", message: finishedMesseage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
    })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func enemyAttack(){
        TechDraUtil.animateDamage(playerImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        player.currentHP = player.currentHP - enemy.attackPower
        playerHPBar.setProgress(player.currentHP / player.maxHP, animated: true)
        
        if player.currentHP < 0 {
            TechDraUtil.animateVanish(playerImageView)
            finishBattle(winPlayer: false)
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
