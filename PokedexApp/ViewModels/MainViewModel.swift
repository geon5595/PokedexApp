//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
  private let disposeBag = DisposeBag()
  
  let pokemonRelay = BehaviorRelay(value: [Pokemon]())
  
  private var urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
  
  func fetchPokemonData() {
    guard let url = URL(string: urlString) else { return }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
        var currentPokemon = self?.pokemonRelay.value ?? []
        currentPokemon.append(contentsOf: pokemonResponse.results)
        self?.pokemonRelay.accept(currentPokemon)
        self?.urlString = pokemonResponse.next ?? ""
      })
      .disposed(by: disposeBag)
  }
}
