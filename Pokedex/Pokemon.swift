//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ionut-Daniel Ciubotariu on 15/08/2017.
//  Copyright © 2017 Bucur Dragos. All rights reserved.
//

import Foundation
import Alamofire
class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _pokemonURL: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoTxt: String!
    private var _nextEvoLvl: String!
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            return ""
        } else {
            return _nextEvoName
        }
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            return ""
        } else {
            return _nextEvoId
        }
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            return ""
        } else {
            return _nextEvoLvl
        }
    }
    
    var description: String {
        if _description == nil {
            return ""
        } else {
            return _description
        }
    }
    
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            return ""
        } else {
            return _nextEvoTxt
        }
    }
    
    var attack: String {
        if _attack == nil {
            return ""
        } else {
            return _attack
        }
    }
    
    var weight: String {
        if _weight == nil {
            return ""
        } else {
            return _weight
        }
    }
    
    var height: String {
        if _height == nil {
            return ""
        } else {
            return _height
        }
    }
    
    var defense: String {
        if _defense == nil {
            return ""
        } else {
            return _defense
        }
    }
    
    var type: String {
        if _type == nil {
            return ""
        } else {
            return _type
        }
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
            
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for type in 1..<types.count {
                            if let name = types[type]["name"] {
                                self._type! += "/\(name.capitalized!)"
                            }
                        }
                    }
                    print(self._type)
                    
                } else {
                    self._type = ""
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 0 {
                    if let url = descArray[0]["resource_uri"] {
                        let desUrl = "http://pokeapi.co\(url)"
                        Alamofire.request(desUrl).responseJSON(completionHandler: { (response) in
                            
                            if let desDict = response.result.value as? Dictionary<String, AnyObject>{
                                if let description = desDict["description"] as? String {
                                    
                                    let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                    print(newDesc)
                                }
                            }
                            completed()
                        }
                        )
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        self._nextEvoLvl = "\(lvl)"
                                    }
                                    
                                } else {
                                    self._nextEvoLvl = ""
                                }
                            }
                        }
                        
                    }
                }
                
                
                
            }
            completed()
        }
        
    }
}
