//
//  ProductListVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/18.
//

import UIKit
import ETNavBarTransparent

class ProductListVC: BaseVC {
    
    var collectionView: UICollectionView!
    var productsRelay = BehaviorRelay(value:[Product]())
    
    init(products: [Product]) {
        self.productsRelay.accept(products)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configNavigationBar() {
        self.navBarBgAlpha = 0
    }
    
    
    override func configSubViews() {
        let header = UIImageView()
        view.addSubview(header)
        
        let headerImage = UIImage(named: "list_header")!
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(header.snp.width).multipliedBy(headerImage.size.height/headerImage.size.width)
        }
        header.image = headerImage
        
        let titleLabel = UILabel()
        self.navigationItem.titleView = titleLabel
        titleLabel.chain.font(.medium(20)).text(color: .kTextBlack).text(self.title!)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        let bottomBar = UIView()
        titleLabel.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        bottomBar.backgroundColor = .black
        
        let layout = UICollectionViewFlowLayout()
        let insets = 16.0
        let spacing = 7.0
        let itemW = (kScreenWidth - insets * 2 - spacing) / 2
        let itemH = ProductCell().systemLayoutSizeFitting(CGSize(width: itemW, height: CGFloat(MAXFLOAT)), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.contentInset = .init(top: 0, left: insets, bottom: 0, right: insets)
        
       
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarMaxY)
            make.left.right.bottom.equalToSuperview()
        }
        collectionView.chain.backgroundColor(.clear).corner(radius: 8).clipsToBounds(true)
        _ = productsRelay.bind(to: collectionView.rx.items(cellIdentifier: "cellId", cellType: ProductCell.self)) { index, element, cell in
            cell.product = element
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe {[weak self] index in
            guard let self = self else {return}
            let product = self.productsRelay.value[index.row]
            let vc = ProductDetailVC(product: product)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    

}
