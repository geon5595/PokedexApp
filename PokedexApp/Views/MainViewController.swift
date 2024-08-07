//
//  ViewController.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {

  private let disposeBag = DisposeBag()
  private let mainViewModel = MainViewModel()
  private var pokemon = [Pokemon]()
  private var isLoading = false
  var onNext: ((String, Data?) -> Void)?
  
  private let pokeballImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Pokeball")
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.itemSize = CGSize(width: view.frame.size.width / 3.4,
                                 height: view.frame.size.width / 3.4)
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.id)
    collectionView.backgroundColor = .darkRed
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .mainRed
    configureUI()
    bind()
  }
  
  private func bind() {
    let pokemonObservable = mainViewModel.pokemonSubject
      .observe(on: MainScheduler.instance)
    
    pokemonObservable
      .bind(to: collectionView.rx.items(cellIdentifier: PokemonCell.id, cellType: PokemonCell.self)) { index, pokemon, cell in
        cell.configure(with: pokemon)
      }.disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let cell = self?.collectionView.cellForItem(at: indexPath) as? PokemonCell else { return }
        if let pokemonImage = cell.imageView.image {
          if let imageData = pokemonImage.pngData() {
            let pokemonUrl = self?.pokemon[indexPath.row].url
            self?.onNext?(pokemonUrl!, imageData)
          }
        }
      }).disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .subscribe(onNext: { [weak self] contentOffset in
        guard let self = self else { return }
        let maxOffset = self.collectionView.contentSize.height - self.collectionView.frame.size.height
        if contentOffset.y > maxOffset && !self.isLoading {
          self.isLoading = true
          self.mainViewModel.fetchPokemonData()
        }
      }).disposed(by: disposeBag)
    
    mainViewModel.pokemonSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemons in
        self?.pokemon = pokemons
        self?.collectionView.reloadData()
        self?.isLoading = false
      }).disposed(by: disposeBag)
  }
  
  private func configureUI() {
    [
      pokeballImage,
      collectionView
    ].forEach { view.addSubview($0) }
    
    pokeballImage.snp.makeConstraints {
      $0.top.equalToSuperview().inset(80)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(100)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(pokeballImage.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview().inset(50)
    }
  }
}

