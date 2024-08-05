//
//  Pokemon.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import Foundation

struct PokemonResponse: Decodable {
  let next: String?
  let previous: String?
  let results: [Pokemon]
}

struct Pokemon: Decodable {
  let name: String
  let url: String
}
