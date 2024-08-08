//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by pc on 8/2/24.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
  private let disposeBag = DisposeBag()
  
  let pokemonDetailRelay = PublishRelay<PokemonDetails>()
  func fetchPokemonData(_ url: String) {
    let urlString = url
    guard let url = URL(string: urlString) else { return }
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemonDetail: PokemonDetails) in
        self?.pokemonDetailRelay.accept(pokemonDetail)
      }).disposed(by: disposeBag)
  }
}
