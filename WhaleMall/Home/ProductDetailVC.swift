//
//  ProductDetailVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/18.
//

import UIKit
import JXPhotoBrowser

class ProductViewModel {
    let disposeBag = DisposeBag()
    var collectTapSignal : ControlEvent<Void>! {
        didSet{
            collectTapSignal.subscribe { _ in
                userService.rx.request(.getLikes)
                
            }.disposed(by: disposeBag)
        }
    }
    var product: Product
    var isCollectedRelay: BehaviorRelay<Bool>
    
    init(product: Product) {
        self.product = product
        self.isCollectedRelay = .init(value: product.is_collect)
    }
    
    func toggleCollection() {
        product.is_collect.toggle()
        isCollectedRelay.accept(product.is_collect)
    }
}


class ProductDetailVC: BaseVC {
    
    var viewModel : ProductViewModel
    
    let product: Product
    var stackView : UIStackView!
    var collectBtn : UIButton!
    //var bottomCollectBtn : UIButton!
    
    init(product: Product) {
        self.product = product
        self.viewModel = ProductViewModel(product: product)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configNavigationBar() {
        self.navBarBgAlpha = 0
        let backButton = UIBarButtonItem(image: .init(named: "detail_nav_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        backButton.actionBlock = {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    override func configSubViews() {
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        scrollView.contentInsetAdjustmentBehavior = .never
        
        
        stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        
        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(detailView)
        
        
    }
    
    lazy var bottomBar: UIView = {
        let bottomBar = UIView()
        bottomBar.snp.makeConstraints { make in
            make.height.equalTo(68 + kBottomSafeInset)
        }
        
        let container = UIView()
        bottomBar.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(68)
        }
        
//        bottomCollectBtn = .init()
//        container.addSubview(bottomCollectBtn)
        
        let serviceBtn = UIButton()
        bottomBar.addSubview(serviceBtn)
        serviceBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        serviceBtn.chain.normalImage(.init(named: "detail_service")).font(.normal(12)).normalTitleColor(color: .kTextBlack).normalTitle(text: "客服")
        serviceBtn.setImagePosition(.top, spacing: 2)
        
        let buyBtn = UIButton()
        bottomBar.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(48)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        buyBtn.chain.normalTitle(text: "购买").normalTitleColor(color: .white).font(.semibold(16)).backgroundColor(.kPinkColor).corner(radius: 8).clipsToBounds(true)
        
        buyBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else {return}
            UserStore.checkLoginStatusThen {
                let confirmView = OrderConfirmView(product: self.product)
                confirmView.popFromViewBottom(fromView:self.view) {
                    confirmView.updateAddress(address: CRAddressManager.shared.defaultAddressModel)
                }
            }
        }
        return bottomBar
    }()
    
    
    lazy var detailView: UIView = {
        let detailView = UIView()
        let label = UILabel()
        detailView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }
        label.chain.text("商品详情").font(.semibold(16)).text(color: .kTextBlack)

        let leftLine = UIView()
        detailView.addSubview(leftLine)
        leftLine.snp.makeConstraints { make in
            make.right.equalTo(label.snp.left).offset(-12)
            make.centerY.equalTo(label)
            make.width.equalTo(60)
            make.height.equalTo(2)
        }
        leftLine.backgroundColor = .kSepLineColor
        
        let rightLine = UIView()
        detailView.addSubview(rightLine)
        rightLine.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(12)
            make.centerY.equalTo(label)
            make.width.equalTo(60)
            make.height.equalTo(2)
        }
        rightLine.backgroundColor = .kSepLineColor
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        detailView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        
        for (index,pic) in viewModel.product.content_pics.enumerated() {
            let imageView = UIImageView()
            imageView.chain.corner(radius: 5).clipsToBounds(true)
            imageView.snp.makeConstraints { make in
                make.width.equalTo(kScreenWidth - 28)
                make.height.equalTo(200)
            }
            imageView.kf.setImage(with: URL(subPath: pic)) { result in
                if case .success(let imageResult ) = result{
                    imageView.snp.updateConstraints { make in
                        make.height.equalTo((kScreenWidth - 28) * imageResult.image.size.height / imageResult.image.size.width)
                    }
                }
            }
            contentStackView.addArrangedSubview(imageView)
            imageView.chain.userInteractionEnabled(true).tap {[weak self] in
                guard let self = self else {return}
                let browser = JXPhotoBrowser()
                // 浏览过程中实时获取数据总量
                var list = self.product.content_pics
                list.insert(self.product.list_pic, at: 0)
    
                browser.numberOfItems = {
                    list.count
                }
                // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
                browser.reloadCellAtIndex = { [weak self] context in
                    guard let self = self else {return}
                    let browserCell = context.cell as? JXPhotoBrowserImageCell
                    browserCell?.imageView.kf.setImage(with: URL(subPath: list[context.index]))
                }
                browser.pageIndex = index + 1
                browser.show()
            }
            
        }
        
        let qualityLabel = UILabel()
        detailView.addSubview(qualityLabel)
        qualityLabel.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        qualityLabel.chain.text("品质保障").font(.semibold(16)).text(color: .kTextBlack)

        let qualityLeftLine = UIView()
        detailView.addSubview(qualityLeftLine)
        qualityLeftLine.snp.makeConstraints { make in
            make.right.equalTo(qualityLabel.snp.left).offset(-12)
            make.centerY.equalTo(qualityLabel)
            make.width.equalTo(60)
            make.height.equalTo(2)
        }
        qualityLeftLine.backgroundColor = .kSepLineColor
        
        let qualityRightLine = UIView()
        detailView.addSubview(qualityRightLine)
        qualityRightLine.snp.makeConstraints { make in
            make.left.equalTo(qualityLabel.snp.right).offset(12)
            make.centerY.equalTo(qualityLabel)
            make.width.equalTo(60)
            make.height.equalTo(2)
        }
        qualityRightLine.backgroundColor = .kSepLineColor
        
        let qualityImageView = UIImageView()
        detailView.addSubview(qualityImageView)
        qualityImageView.snp.makeConstraints { make in
            make.top.equalTo(qualityLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        qualityImageView.image = .init(named: "order_feature")
        
        return detailView
    }()
    
    
    lazy var header: UIView = {
        let header = UIView()
        let cover = UIImageView()
        header.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        cover.kf.setImage(with: URL(subPath: viewModel.product.list_pic))
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        
        let info = UIView()
        header.addSubview(info)
        info.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).offset(-14)
            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(108)
        }
        info.backgroundColor = .white
//        info.size = CGSizeMake(kScreenWidth, 108)
//        info.addCornerRect(with: [.topLeft, .topRight], radius: 8)
        
        let titleLabel = UILabel()
        info.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.right.equalTo(-14)
        }
        titleLabel.numberOfLines = 2
        titleLabel.chain.font(.medium(16)).text(color: .kTextBlack)
        titleLabel.text = viewModel.product.name
        
        let priceLabel = UILabel()
        info.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(14)
        }
        
        let price = viewModel.product.price
        let raw = String(format: "¥%.2f", price)
        let priceTitle = NSMutableAttributedString(raw, color: .kTextDeepRed, font: .semibold(21))
        priceTitle.setAttributes([
            .font : UIFont.semibold(14),
            .foregroundColor : UIColor.kTextDeepRed
        ], range: (raw as NSString).range(of: "¥"))
        priceLabel.attributedText = priceTitle
        
        let tag1 = UILabel()
        info.addSubview(tag1)
        tag1.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.height.equalTo(15)
            make.left.equalTo(priceLabel.snp.right).offset(7)
            make.bottom.equalTo(priceLabel.snp.lastBaseline)
        }
        tag1.chain.text(color: .init(hexColor: "#7549F2")).font(.normal(9)).text("官方正版").textAlignment(.center).border(color: .init(hexColor: "#7549F2")).border(width: 1).corner(radius: 2).clipsToBounds(true)
        
        let tag2 = UILabel()
        info.addSubview(tag2)
        tag2.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.height.equalTo(15)
            make.left.equalTo(tag1.snp.right).offset(5)
            make.bottom.equalTo(priceLabel.snp.lastBaseline)
        }
        tag2.chain.text(color: .init(hexColor: "#F469FD")).font(.normal(9)).text("顺丰到付").textAlignment(.center).border(color: .init(hexColor: "#F469FD")).border(width: 1).corner(radius: 2).clipsToBounds(true)
        
        let salesCountLabel = UILabel()
        info.addSubview(salesCountLabel)
        salesCountLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.left.equalTo(priceLabel)
            make.bottom.equalTo(-20)
        }
        salesCountLabel.chain.font(.normal(12)).text(color: .kTextLightGray)
        salesCountLabel.text = "最近30天售出: \(product.sales_count)"
        
        
        
        collectBtn = .init()
        info.addSubview(collectBtn)
        collectBtn.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalTo(salesCountLabel)
        }
        
        collectBtn.chain.normalImage(.init(named: "collect_normal")).selectedImage(.init(named: "collect_selected")).font(.normal(13)).normalTitleColor(color: .kTextBlack).normalTitle(text: "收藏")
        collectBtn.setImagePosition(.left, spacing: 4)
        
        viewModel.isCollectedRelay.bind(to: collectBtn.rx.isSelected).disposed(by: disposeBag)
        collectBtn.rx.tap.subscribe {[weak self] _ in
            guard let self = self else {return}
            if !self.product.is_collect {
                userService.request(.like(id: self.product.id)) { result in
                    result.hj_map2 { body in
                        "收藏成功".hint()
                        self.viewModel.toggleCollection()
                    }
                }
            }else{
                userService.request(.dislike(id: self.product.id)) { result in
                    result.hj_map2 { body in
                        "取消收藏成功".hint()
                        self.viewModel.toggleCollection()
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        
        
        
        return header
    }()
    
}
