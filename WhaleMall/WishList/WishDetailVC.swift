//
//  WishDetailVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/20.
//

import Foundation


class WishDetailVC : BaseVC{
    
    var product: Product
    var stackView : UIStackView!
    var collectBtn : UIButton!
    
    init(product: Product) {
        self.product = product
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
            make.left.right.bottom.equalToSuperview()
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
        
        if product.content_pics_base64.count > 0{
            stackView.addArrangedSubview(detailView)
        }
        
        
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
        

        
        let buyBtn = UIButton()
        bottomBar.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(48)
            make.center.equalToSuperview()
        }
        buyBtn.chain.normalTitle(text: "我也想要").normalTitleColor(color: .white).font(.semibold(16)).backgroundColor(.kPinkColor).corner(radius: 8).clipsToBounds(true)
        
        buyBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else {return}
            UserStore.checkLoginStatusThen {
                self.product.wish_count += 1
                "许愿以收到,敬请期待吧 ~".hint()
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
        label.chain.text("参考图片").font(.semibold(16)).text(color: .kTextBlack)

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
            make.bottom.equalTo(-20)
        }
        
        for (index,pic) in product.content_pics_base64.enumerated() {
            let imageView = UIImageView()
            imageView.chain.corner(radius: 5).clipsToBounds(true)
            let image = pic.toImage()!
            imageView.snp.makeConstraints { make in
                make.width.equalTo(kScreenWidth - 28)
                make.height.equalTo((kScreenWidth - 28) * image.size.height / image.size.width)
            }
            imageView.image = image
            contentStackView.addArrangedSubview(imageView)
        }
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
        cover.image = product.list_pic_base64.toImage()
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        
        let info = UIView()
        header.addSubview(info)
        info.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).offset(-14)
            make.left.right.bottom.equalToSuperview()
        }
        info.backgroundColor = .white
        //info.addCornerRect(with: [.topLeft, .topRight], radius: 8)
        
        let wishTag = UILabel()
        info.addSubview(wishTag)
        wishTag.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
        wishTag.chain.text("求购").textAlignment(.center).font(.normal(14)).text(color: .kTextDeepRed).border(width: 1).border(color: .kTextDeepRed).corner(radius: 4).clipsToBounds(true)
        
        
        let titleLabel = UILabel()
        info.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(wishTag.snp.right).offset(10)
            make.centerY.equalTo(wishTag)
            make.right.equalTo(-14)
        }
        titleLabel.numberOfLines = 2
        titleLabel.chain.font(.semibold(16)).text(color: .kTextBlack)
        titleLabel.text = product.name
        
        let priceLabel = UILabel()
        info.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
        }
        
        let price = product.price
        let raw = String(format: "期望价格: ¥%.2f", price)
        let priceTitle = NSMutableAttributedString(raw, color: .kTextDeepRed, font: .semibold(21))
        priceTitle.setAttributes([
            .font : UIFont.semibold(14),
            .foregroundColor : UIColor.kTextDeepRed
        ], range: (raw as NSString).range(of: "¥"))
        
        priceTitle.setAttributes([
            .font : UIFont.semibold(16),
            .foregroundColor : UIColor.kTextBlack
        ], range: (raw as NSString).range(of: "期望价格: "))
        priceLabel.attributedText = priceTitle
        
        let finessLabel = UILabel()
        info.addSubview(finessLabel)
        finessLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(14)
            make.left.equalTo(14)
        }
        
        let finessRaw = String(format: "期望成色: %@", finessDiscirption(product.new_ratio_name))
        let finessTitle = NSMutableAttributedString(finessRaw, color: .kTextDeepRed, font: .semibold(21))

        finessTitle.setAttributes([
            .font : UIFont.semibold(16),
            .foregroundColor : UIColor.kTextBlack
        ], range: (finessRaw as NSString).range(of: "期望成色: "))
        finessLabel.attributedText = finessTitle
        
        
        
        let detailContainer = UIView()
        info.addSubview(detailContainer)
        detailContainer.snp.makeConstraints { make in
            make.top.equalTo(finessLabel.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-20)
        }
        detailContainer.chain.corner(radius: 8).clipsToBounds(true).backgroundColor(.kExLightGray)
        
        let detailLabel = UILabel()
        detailContainer.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.right.equalTo(-14)
        }
        detailLabel.chain.text("需求描述").font(.semibold(16)).text(color: .kTextBlack).numberOfLines(0)
        
        let detailContentLabel = UILabel()
        detailContainer.addSubview(detailContentLabel)
        detailContentLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-12)
        }
        detailContentLabel.chain.text(product.detail_content).font(.normal(14)).text(color: .kTextBlack).numberOfLines(0)
        
        
        
        
        
        
        
        
        
//        collectBtn = .init()
//        info.addSubview(collectBtn)
//        collectBtn.snp.makeConstraints { make in
//            make.right.equalTo(-14)
//            make.centerY.equalTo(priceLabel)
//        }
//
//        collectBtn.chain.normalImage(.init(named: "collect_normal")).selectedImage(.init(named: "collect_selected")).font(.normal(13)).normalTitleColor(color: .kTextBlack).normalTitle(text: "收藏")
//        collectBtn.setImagePosition(.left, spacing: 4)
//
//        viewModel.isCollectedRelay.bind(to: collectBtn.rx.isSelected).disposed(by: disposeBag)
        
        
        
        
        return header
    }()
}
