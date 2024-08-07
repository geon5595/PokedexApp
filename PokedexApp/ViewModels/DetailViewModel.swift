//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by pc on 8/2/24.
//

import Foundation
import RxSwift

class DetailViewModel {
  private let disposeBag = DisposeBag()
  
  let pokemonDetailSubject = PublishSubject<PokemonDetails>()
  func fetchPokemonData(_ url: String) {
    let urlString = url
    guard let url = URL(string: urlString) else {
      pokemonDetailSubject.onError(NetworkError.invalidUrl)
      return
    }
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemonDetail: PokemonDetails) in
        self?.pokemonDetailSubject.onNext(pokemonDetail)
      }, onFailure:  { [weak self] error in
        self?.pokemonDetailSubject.onError(NetworkError.decodingFail)
      }).disposed(by: disposeBag)
  }
}
