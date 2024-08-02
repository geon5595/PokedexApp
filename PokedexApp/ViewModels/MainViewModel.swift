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
  private var limit = 20
  private var offset = 0
  init() {
    fetchPokemonData()
  }
  
  func fetchPokemonData() {
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
      pokemonSubject.onError(NetworkError.invalidUrl)
      return
    }
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemonresponse: PokemonResponse) in
        self?.pokemonSubject.onNext(pokemonresponse.results)
      }, onFailure:  { [weak self] error in
        self?.pokemonSubject.onError(NetworkError.decodingFail)
      }).disposed(by: disposeBag)
  }
}
