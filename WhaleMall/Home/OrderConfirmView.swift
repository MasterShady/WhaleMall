//
//  OrderComfirmView.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/19.
//

import UIKit




class OrderConfirmView: BaseView {
    
    var userContactlabel: UILabel!
    var addressDetailLabel: UILabel!
    var chooseAddressLabel: UILabel!
    
    var address : AddressModel?
    
    let product: Product
    
    init(product: Product){
        self.product = product
        super.init(frame: .zero)
        configSubViews()
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews(){
        self.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
        }
        chain.backgroundColor(.white)
        
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(16)
        }
        titleLabel.chain.text(color: .kTextBlack).font(.semibold(18)).text("确认订单")
        
        let closeBtn = UIButton()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.right.equalTo(-16)
        }
        closeBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            self?.dismissFromView()
        }
        
        closeBtn.chain.normalImage(.init(named: "close"))
        
        let addressView = UIView()
        addSubview(addressView)
        addressView.snp.makeConstraints { make in
            make.top.equalTo(61)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(85)
        }
        addressView.chain.backgroundColor(.kExLightGray).corner(radius: 10).clipsToBounds(true)
        
        userContactlabel = .init()
        addressView.addSubview(userContactlabel)
        userContactlabel.snp.makeConstraints { make in
            make.top.equalTo(9)
            make.left.equalTo(12)
        }
        userContactlabel.chain.text(color: .kTextBlack).font(.normal(12))
        
        addressDetailLabel = .init()
        addressView.addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(userContactlabel.snp.bottom).offset(9)
            make.left.equalTo(12)
            make.right.equalTo(-34)
        }
        addressDetailLabel.chain.text(color: .kTextBlack).font(.semibold(14))
        
        chooseAddressLabel = .init()
        addressView.addSubview(chooseAddressLabel)
        chooseAddressLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        chooseAddressLabel.chain.text(color: .kTextLightGray).font(.normal(12)).text("选择地址")
        
        let arrow = UIImageView(image: .init(named: "arrow"))
        addressView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        addressView.addGestureRecognizer(UITapGestureRecognizer(actionBlock: {[weak self] _ in
            let vc = AddressListVC()
            vc.didSelectComplete = { address in
                self?.updateAddress(address:address)
            }
            UIViewController.currentViewController(from: appdelegate.window!).navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        
        let productView = UIView()
        addSubview(productView)
        productView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(21)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(80)
        }
        
        let cover = UIImageView()
        productView.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(cover.snp.height)
        }
        cover.kf.setImage(with: URL(subPath: product.list_pic))
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        
        let nameLabel = UILabel()
        productView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(cover.snp.right).offset(10)
            make.top.right.equalTo(0)
        }
        nameLabel.chain.text(color: .kTextBlack).font(.semibold(14)).text(product.name)
        
        let hintLabel = UILabel()
        productView.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel)
        }
        hintLabel.chain.text(color: .kTextLightGray).font(.normal(12)).text("官方正版/货到付款")
        
        let priceLabel = UILabel()
        productView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.bottom.equalToSuperview()
        }
        
        let price = product.price
        let raw = String(format: "¥%.2f", price)
        let priceTitle = NSMutableAttributedString(raw, color: .red, font: .semibold(21))
        priceTitle.setAttributes([
            .font : UIFont.semibold(14),
            .foregroundColor : UIColor.red
        ], range: (raw as NSString).range(of: "¥"))
        priceLabel.attributedText = priceTitle
        
        let sep = UIView()
        addSubview(sep)
        sep.snp.makeConstraints { make in
            make.top.equalTo(productView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(1)
        }
        sep.backgroundColor = .kSepLineColor
        
        let guaranteeLabel = UILabel()
        addSubview(guaranteeLabel)
        guaranteeLabel.snp.makeConstraints { make in
            make.top.equalTo(sep.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        guaranteeLabel.chain.text("— 品质保障 —").font(.normal(13)).text(color: .kTextLightGray)
        
        let featureView = UIImageView(image: .init(named: "order_feature"))
        addSubview(featureView)
        featureView.snp.makeConstraints { make in
            make.top.equalTo(guaranteeLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        let confirmBtn = UIButton()
        addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(featureView.snp.bottom).offset(53)
            make.width.equalTo(240)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-9 - kBottomSafeInset)
        }
        confirmBtn.chain.normalTitle(text: "提交订单").normalTitleColor(color: .white).font(.semibold(16)).backgroundColor(.kPinkColor).corner(radius: 12).clipsToBounds(true)
        confirmBtn.addTarget(self, action: #selector(commit), for: .touchUpInside)

    }
    
    @objc func commit(){
        if self.address == nil{
            "请选择下单地址".hint()
            return
        }
        userService.request(.makeOrder(id: product.id)) {[weak self] result in
            result.hj_map2 { body in
                "下单成功, 已经通知商家配货, 预计48小时内发出".hint()
                self?.dismissFromView()
            }
        }
    }
    
    
    override func decorate() {
        self.addCornerRect(with: [.topLeft, .topRight], radius: 10)
    }
    
    
    func updateAddress(address: AddressModel?){
        self.address = address
        if let address = address{
            userContactlabel.isHidden = false
            addressDetailLabel.isHidden = false
            userContactlabel.text = address.uname + "      " + address.phone
            addressDetailLabel.text = address.address_area + address.address_detail
            chooseAddressLabel.isHidden = true
        }else{
            userContactlabel.isHidden = true
            addressDetailLabel.isHidden = true
            chooseAddressLabel.isHidden = false
        }
    }

}
