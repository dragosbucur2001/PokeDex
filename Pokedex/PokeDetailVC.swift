//
//  PokeDetailVC.swift
//  Pokedex
//
//  Created by Ionut-Daniel Ciubotariu on 15/08/2017.
//  Copyright © 2017 Bucur Dragos. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {
    
    var poke: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var wieghtLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = poke.name.capitalized
        
        let img = UIImage(named: "\(poke.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        idLbl.text = "\(poke.pokedexId)"
        
        
        poke.downloadPokemonDetail { 
            
            self.updateUI()
            
        }
    }

    func updateUI() {
        
        attackLbl.text = poke.attack
        wieghtLbl.text = poke.weight
        defenseLbl.text = poke.defense
        heightLbl.text = poke.height
        typeLbl.text = poke.type
        descriptionLbl.text = poke.description
        
        if poke.nextEvoId == "" {
            evolutionLbl.text = "No evolutionss"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: poke.nextEvoId)
            let string = "Next Evolution : \(poke.nextEvoName) - LVL \(poke.nextEvoLvl)"
            evolutionLbl.text = string
        }
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
