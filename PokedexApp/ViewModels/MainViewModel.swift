//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import Foundation
import RxSwift

class MainViewModel {
  private let disposeBag = DisposeBag()
  
  let pokemonSubject = BehaviorSubject(value: [Pokemon]())
  
  private var urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
  
  func fetchPokemonData() {
    guard let url = URL(string: urlString) else {
      pokemonSubject.onError(NetworkError.invalidUrl)
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
        var currentPokemon = try? self?.pokemonSubject.value() ?? []
        currentPokemon?.append(contentsOf: pokemonResponse.results)
        self?.pokemonSubject.onNext(currentPokemon ?? [])
        self?.urlString = pokemonResponse.next ?? ""
      }, onFailure: { [weak self] error in
        self?.pokemonSubject.onError(NetworkError.decodingFail)
      })
      .disposed(by: disposeBag)
  }
}
