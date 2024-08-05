//
//  DetailViewController.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift


class DetailViewController: UIViewController {
  private let detailViewModel = DetailViewModel()
  private let disposeBag = DisposeBag()

  var receivedPokemonNumber: Int?
  var receivedImage: Data?
  

  private lazy var detailView: DetailView = {
    let detailView = DetailView()
    detailView.layer.cornerRadius = 10
    return detailView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurUI()
    if let pokemonNumber = receivedPokemonNumber {
      detailViewModel.fetchPokemonData(at: pokemonNumber)
    }
    bind()
  }
  
  private func bind() {
    detailViewModel.pokemonDetailSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemonData in
        self?.updateDetailView(with: pokemonData)
      }, onError: { error in
        print("error")
      }).disposed(by: disposeBag)
  }
    
  private func updateDetailView(with pokemonData: PokemonDetails) {
    let pokemonKoreanName = PokemonTranslator.getKoreanName(for: pokemonData.name)
    let pokemonKoreanType = PokemonTypeName(rawValue: pokemonData.types[0].type.name)!.displayName 
    detailView.setPokemonImageView(UIImage(data: receivedImage!) ?? UIImage())
    detailView.setPokemonName(receivedPokemonNumber!, pokemonKoreanName)
    detailView.setPokemonType(pokemonKoreanType)
    detailView.setPokemonHeight(Double(pokemonData.height) / 10)
    detailView.setPokemonWeight(Double(pokemonData.weight) / 10)
  }
  
  private func configurUI() {
    view.backgroundColor = .mainRed
    view.addSubview(detailView)
    detailView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.horizontalEdges.equalToSuperview().inset(35)
      $0.bottom.equalToSuperview().inset(350)
    }
  }
}

