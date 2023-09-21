//
//  HomeVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/13.
//

import UIKit
import MJRefresh



//struct Product {
//    var isCollected = false
//}

class ProductCell: UICollectionViewCell{
    var cover: UIImageView!
    var titleLabel: UILabel!
    var priceLabel: UILabel!
    var product : Product? {
        didSet{
            guard let product = product else {return}
            titleLabel.text = product.name
            priceLabel.text = String(format: "¥%.2f", product.price)
            cover.kf.setImage(with: URL(subPath: product.list_pic))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews(){
        self.chain.backgroundColor(.white).corner(radius: 5).clipsToBounds(true)
        cover = .init()
        contentView.addSubview(cover)
        cover.chain.corner(radius: 4).clipsToBounds(true).contentMode(.scaleAspectFit).backgroundColor(.kBlack)
        cover.snp.makeConstraints { make in
            make.top.left.equalTo(7)
            make.right.equalTo(-7)
            make.height.equalTo(cover.snp.width).multipliedBy(112/152.0)
        }
        
        
        let newTag = UIImageView()
        contentView.addSubview(newTag)
        newTag.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).offset(8)
            make.left.equalTo(9)
            make.size.equalTo(CGSize(width: 47, height: 20))
        }
        newTag.image = .init(named: "tag_bg")
        
        let tagButton = UIButton()
        newTag.addSubview(tagButton)
        tagButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        tagButton.chain.normalImage(.init(named: "tag_star")).normalTitle(text: "New").normalTitleColor(color: .kTextBlack).font(.semibold(10))
        
        
        titleLabel = .init()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(newTag.snp.bottom).offset(8)
            make.left.equalTo(9)
            make.right.equalTo(-9)
        }
        
        // "a\na" 这个是用来layout计算高度用的.
        titleLabel.chain.text(color: .kTextBlack).font(.semibold(14)).numberOfLines(2).text("a\na")
        
        
        priceLabel = .init()
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(9)
        }
        priceLabel.chain.text(color: .init(hexColor: "#A4328A")).font(.semibold(18))
        
        
        let buyBtn = UIButton()
        contentView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(64)
            make.height.equalTo(28)
            make.right.equalTo(-12)
            make.bottom.equalTo(-12)
        }
        buyBtn.chain.normalTitleColor(color: .white).normalTitle(text: "购买").font(.medium(12)).backgroundColor(.black).corner(radius: 14).clipsToBounds(true).userInteractionEnabled(false)
    }
}


class HomeVC: BaseVC {
    
    
    var refreshHeader : MJRefreshNormalHeader!
    var productsRelay = BehaviorRelay(value:[Product]())
    var allProducts = [Product]()
    var collectionView: UICollectionView!
    
    override func configSubViews() {
        self.hideNavBar = true
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.contentInsetAdjustmentBehavior = .never
        
        refreshHeader = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else {return}
            userService.rx.request(.goodsList(data_type: 0)).catchErrorAndMapToBody(type: Product.self).drive { body, error in
                self.refreshHeader.endRefreshing()
                if let error = error{
                    error.msg.hint()
                    return
                }
                //
                self.allProducts = body!.decodedObjList!.sorted(by: \.sales_count).reversed()
                self.productsRelay.accept(self.allProducts.filter({$0.goods_type == 1}))
            }.disposed(by: self.disposeBag)
        })
        //refreshHeader.ignoredScrollViewContentInsetTop = kStatusBarHeight
        
        scrollView.mj_header = refreshHeader
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(discountView)
        stackView.addSpacing(self.tabBarController!.tabBar.height)
    }
    
    override func networkRequest() {
        refreshHeader.beginRefreshing()
    }
    
    
    lazy var discountView: UIView = {
        let discountView = UIView()
        let label = YYLabel()
        discountView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(48)
        }
        label.textContainerInset = .init(top: 0, left: 20, bottom: 0, right: 0)
        label.text = "折扣好货"
        label.font = .semibold(16)
        label.textColor = .kTextBlack
        
        let banner = UIImageView()
        discountView.addSubview(banner)
        let bannerImage = UIImage(named: "home_banner")!
        banner.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(banner.snp.width).multipliedBy(bannerImage.size.height/bannerImage.size.width)
        }
        banner.image = bannerImage
        banner.chain.userInteractionEnabled(true).tap { [weak self] in
            guard let self = self else {return}
            var products = self.allProducts.filter{$0.goods_type == 3}
            let vc = ProductListVC(products:products)
            vc.title = "游戏手柄"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let collectionViewHeader = YYLabel()
        discountView.addSubview(collectionViewHeader)
        collectionViewHeader.snp.makeConstraints { make in
            make.top.equalTo(banner.snp.bottom).offset(14)
            make.left.right.equalTo(0)
            make.height.equalTo(24)
            
        }
        collectionViewHeader.textContainerInset = .init(top: 0, left: 20, bottom: 0, right: 0)
        collectionViewHeader.text = "高级🐑手办"
        collectionViewHeader.font = .semibold(16)
        collectionViewHeader.textColor = .kTextBlack
        
        
        let dudo = UIImageView()
        collectionViewHeader.addSubview(dudo)
        dudo.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-24)
        }
        dudo.image = .init(named: "dudo")
        
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
        collectionView.isScrollEnabled = false
        collectionView.contentInset = .init(top: 0, left: insets, bottom: 0, right: insets)
        collectionView.backgroundColor = .clear
        discountView.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewHeader.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        
        productsRelay
            .bind(to: collectionView.rx.items(cellIdentifier: "cellId", cellType: ProductCell.self)) { index, element, cell in
                cell.product = element
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe {[weak self] index in
            guard let self = self else {return}
            let product = self.productsRelay.value[index.row]
            let vc = ProductDetailVC(product: product)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        _ = collectionView.rx.observe(\.contentSize).take(until: rx.deallocated).distinctUntilChanged().map { size in
            return size.height
        }.subscribe(onNext: {[weak self] height in
            self!.collectionView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        })
        
        return discountView
    }()
    
    
    lazy var header: UIView = {
        let header = UIView()
        let headerH = 242 + kNavBarHeight
        
        header.backgroundColor = UIColor.gradient(fromColors: [.init(hexColor: "#E4F4FF", alpha: 0.5), .init(hexColor: "#FFFFFF", alpha: 0)], size: CGSizeMake(kScreenWidth,headerH))
        header.snp.makeConstraints({ make in
            make.height.equalTo(headerH)
        })
        
        let titleImageView = UIImageView()
        header.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarHeight + 20)
            make.left.equalTo(24)
        }
        titleImageView.image = .init(named: "home_header_title")
        
        let TLImageView = UIImageView()
        header.addSubview(TLImageView)
        TLImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
        }
        TLImageView.image = .init(named: "home_header_top_right_corner")
        
        let folderImageView = UIImageView()
        header.addSubview(folderImageView)
        folderImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(208.rw - 48)
        }
        folderImageView.image = .init(named: "home_header_folder")
        folderImageView.isUserInteractionEnabled = true
        
        let folderTitleLabel = UILabel()
        folderImageView.addSubview(folderTitleLabel)
        folderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(20)
        }
        folderTitleLabel.chain.text("值得买的周边好物").text(color: .kTextBlack).font(.boldSystemFont(ofSize: 18))
        
        let items = [
            ("淘外设","peripherals", [3,2]),
            ("淘游戏","game", [4]),
            ("淘配件","gear", [2,5]),
            ("淘周边","derivative", [1])
        ]
        
        let inset = 24
        let itemW = 62
        let itemSpaing = (kScreenWidth - inset * 2 - itemW * items.count) / (items.count - 1)
        
        for (i,item) in items.enumerated() {
            let itemView = UIButton()
            folderImageView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.left.equalTo(inset + (itemW + itemSpaing) * i)
                make.bottom.equalTo(-16)
                make.width.equalTo(itemW)
            }
            itemView.chain.normalTitle(text: item.0).normalImage(.init(named: item.1)).normalTitleColor(color: .kTextBlack).font(.semibold(14))
            itemView.setImagePosition(.top, spacing: 5)
            itemView.addBlock(for: .touchUpInside) {[weak self] _ in
                guard let self = self else {return}
                var products = self.allProducts.filter{item.2.contains($0.goods_type)}
                let vc = ProductListVC(products:products)
                vc.title = item.0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return header
    }()
    
    
}
