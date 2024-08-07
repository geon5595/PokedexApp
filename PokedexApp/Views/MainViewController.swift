//
//  ViewController.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {

  private let disposeBag = DisposeBag()
  private let mainViewModel = MainViewModel()
  private let detailViewModel = DetailViewModel()
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
    collectionView.delegate = self
    collectionView.dataSource = self
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
    mainViewModel.pokemonSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemons in
        self?.pokemon += pokemons
        self?.collectionView.reloadData()
        self?.isLoading = false
      }, onError: { [weak self] error in
        print("error")
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

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? PokemonCell else { return }
    if let pokemonImage = cell.imageView.image {
      if let imageData = pokemonImage.pngData() {
        let pokemonUrl = pokemon[indexPath.row].url
          onNext?(pokemonUrl, imageData)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.id, for: indexPath) as? PokemonCell else {
      return UICollectionViewCell()
    }
    cell.configure(with: pokemon[indexPath.row])
    print(indexPath.row)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemon.count
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print(scrollView.contentOffset)
    let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height - 300
    print(scrollView.contentSize.height)
    print(maxOffset)
    if scrollView.contentOffset.y > maxOffset && !isLoading {
      isLoading = true
      mainViewModel.fetchPokemonData()
    }
  }
}

