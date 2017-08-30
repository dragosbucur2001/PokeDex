//
//  ViewController.swift
//  Pokedex
//
//  Created by Ionut-Daniel Ciubotariu on 15/08/2017.
//  Copyright © 2017 Bucur Dragos. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
        
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                
                pokemons.append(poke)
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath)
            as? PokeCell {
            
            let pokemon: Pokemon!
            if inSearchMode {
                pokemon = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon)
            } else {
                pokemon = pokemons[indexPath.row]
                cell.configureCell(pokemon)
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemons[indexPath.row]
        } else {
            poke = pokemons[indexPath.row]
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PokeDetail") as! PokeDetailVC
        vc.poke = poke
        present(vc, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemons.count
        } else {
            return pokemons.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
        
    }
    
    
}

