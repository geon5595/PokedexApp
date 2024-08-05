//
//  PokemonDetail.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import Foundation

struct PokemonDetails: Decodable {
  let name: String
  let height: Int
  let weight: Int
  let types: [PokemonTypeSlot]
}

struct PokemonTypeSlot: Decodable {
  let type: PokemonType
}

struct PokemonType: Decodable {
  let name: String
}
