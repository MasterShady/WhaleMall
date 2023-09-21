//
//  CreatePostVC.swift
//  WhaleBox
//
//  Created by 刘思源 on 2023/9/6.
//

import UIKit
import RxCocoa
import RxSwift
import CLImagePickerTool
import Moya

class CreatePostVC: BaseVC {
    
    var titleField : UITextField!
    var imageStackView : UIStackView!
    var imagesRelay = BehaviorRelay(value: [UIImage]())
    var finess = 1.0
    var contentTextView : YYTextView!
    var priceValue: UITextField!
   
    
    lazy var pickerTool : CLImagePickerTool = {
        let pickerTool = CLImagePickerTool.init()
        pickerTool.isHiddenVideo = true
        pickerTool.cameraOut = true //设置相机选择在外部
        pickerTool.singleImageChooseType = .singlePicture //单选模式
        pickerTool.singleModelImageCanEditor = true //设置单选模式下图片可以编辑涂鸦
        return pickerTool
    }()
    
    
    override func configNavigationBar() {
        self.title = "发布求购"
        let closeItem = UIBarButtonItem(image: .init(named: "close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        closeItem.actionBlock = { [weak self] _ in
            self?.dismiss(animated: true)
        }
        self.navigationItem.leftBarButtonItem = closeItem
        
        
    }
    
    
    override func configSubViews() {
        view.backgroundColor = .kExLightGray
        
        titleField = UITextField()
        view.addSubview(titleField)
        titleField.snp.makeConstraints { make in
            make.top.equalTo(20 + kNavBarMaxY)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(44)
        }
        titleField.chain.corner(radius: 6).clipsToBounds(true).backgroundColor(.white)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let leftTitle = UILabel(frame: CGRect(x: 16, y: 0, width: 80, height: 44))
        leftTitle.chain.text(color: .kTextBlack).font(.semibold(16)).text("求购标题:")
        leftView.addSubview(leftTitle)
        
        titleField.leftView = leftView
        titleField.leftViewMode = .always
        titleField.chain.text(color: .kTextBlack).font(.systemFont(ofSize: 16))
        titleField.attributedPlaceholder = NSAttributedString("简要描述求购的商品名称", color: .kTextLightGray, font: .semibold(16))
        
        
        let detailContainer = UIView()
        view.addSubview(detailContainer)
        detailContainer.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            
        }
        detailContainer.chain.backgroundColor(.white).corner(radius: 5).clipsToBounds(true)
        
        contentTextView = YYTextView()
        detailContainer.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(150)
        }
        
        contentTextView.textColor = .kTextBlack
        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.placeholderAttributedText = NSAttributedString("描述一下想要求购的宝贝的具体型号要求和特征吧~", color: .kTextLightGray, font: .semibold(16))
        
        
        
        imageStackView = UIStackView()
        imageStackView.axis = .horizontal
        imageStackView.spacing = 20
        detailContainer.addSubview(imageStackView)
        
        let imgWH = (kScreenWidth - 56 - 20 * 2) / 3
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.left.equalTo(14)
            make.height.equalTo(imgWH)
            make.bottom.equalTo(-14)
        }
        
        
        _ = imagesRelay.subscribe {[weak self] value in
            guard let self = self else {return}
            self.imageStackView.removeAllSubviews()
            
            let loopCount = min(3, value.element!.count + 1)
            for i in 0..<loopCount {
                let imageView = UIImageView()
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(imgWH)
                }
                imageView.isUserInteractionEnabled = true
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true

                var action = {
                    let alert = AEAlertView(style: .defaulted, title: "", message: "确定删除该照片吗?")
                    alert.addAction(action: .init(title: "删除", handler: { action in
                        var array = value.element!
                        array.removeLast()
                        self.imagesRelay.accept(array)
                        alert.dismiss()
                    }))
                    alert.addAction(action: .init(title: "取消", handler: { action in
                        alert.dismiss()
                    }))
                    alert.show()

                }
                if i == loopCount - 1{
                    if i == value.element!.count - 1 {
                        //最后一个,是照片
                        imageView.image = value.element![i]
                    }else{
                        //添加照片的+好
                        let image = UIImage(named: "add-image")?.resizeImageToSize(size: CGSize(width: 50, height: 50))
                        imageView.image = image
                        imageView.contentMode = .center
                        imageView.size = CGSize(width: imgWH, height: imgWH)
                        imageView.addDashLine(with: .kTextLightGray, width: 1, lineDashPattern: [5,5], cornerRadius: 5)

                        action = {
                            self.pickerTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: self) {[weak self] (assets, cutImage) in
                                guard let self = self else {return}
                                guard let image = cutImage else { return }
                                var raw = self.imagesRelay.value
                                raw.append(image)
                                self.imagesRelay.accept(raw)

                            }
                        }
                    }
                }else{
                    imageView.image = value.element![i]
                }
                let tap = UITapGestureRecognizer { _ in
                    action()
                }
                imageView.addGestureRecognizer(tap)
                imageStackView.addArrangedSubview(imageView)
            }
            
        }.disposed(by: disposeBag)
        
        
        let infoContainer = UIView()
        view.addSubview(infoContainer)
        infoContainer.snp.makeConstraints { make in
            make.top.equalTo(detailContainer.snp.bottom).offset(14)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        infoContainer.chain.backgroundColor(.white).corner(radius: 5).clipsToBounds(true)
        
        let priceInfoView = UIButton()
        infoContainer.addSubview(priceInfoView)
        priceInfoView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(48)
        }
        
        let priceLabel = UILabel()
        priceInfoView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(14)
        }
        priceLabel.chain.font(.semibold(14)).text(color: .kTextBlack).text("期望价格")
        
        priceValue = UITextField()
        priceInfoView.addSubview(priceValue)
        priceValue.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalTo(priceLabel)
            make.width.equalTo(72)
            make.height.equalTo(36)
        }
        
        
        priceValue.chain.font(.semibold(14)).text(color: .red).border(color: .kSepLineColor).border(width: 1).corner(radius: 4).leftInset(10).rightInset(10)
        priceValue.keyboardType = .numberPad
        
        
        let signView = UILabel()
        signView.chain.text(color: .red).font(.semibold(14)).text("¥")
        priceInfoView.addSubview(signView)
        signView.snp.makeConstraints { make in
            make.right.equalTo(priceValue.snp.left).offset(-5)
            make.centerY.equalTo(priceValue)
        }
        
        priceInfoView.addBlock(for: .touchUpInside) {[weak priceValue] _ in
            priceValue?.becomeFirstResponder()
        }
        
        
        let sep = UIView()
        infoContainer.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.top.equalTo(priceInfoView.snp.bottom)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(1)
        }
        sep.backgroundColor = .kSepLineColor
        
        
        let finessInfoView = UIButton()
        infoContainer.addSubview(finessInfoView)
        finessInfoView.snp.makeConstraints { make in
            make.top.equalTo(sep.snp.bottom)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(48)
        }
        let finessLabel = UILabel()
        finessInfoView.addSubview(finessLabel)
        finessLabel.snp.makeConstraints { make in
            make.top.equalTo(sep.snp.bottom).offset(16)
            make.left.equalTo(14)
            make.bottom.equalTo(-14)
        }
        finessLabel.chain.font(.semibold(14)).text(color: .kTextBlack).text("成色要求")
        
        let finessValue = UIButton()
        finessInfoView.addSubview(finessValue)
        finessValue.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalTo(finessLabel)
        }
        finessValue.chain.font(.semibold(14)).normalTitle(text: "全新").normalImage(.init(named: "arrow")).normalTitleColor(color: .kTextBlack)
        finessValue.setImagePosition(.right, spacing: 5)
        finessValue.isUserInteractionEnabled = false
        
        let titleMap = [ 1: "全新", 0.99 :"99新", 0.9: "9新以上", 0.8: "8新以上", 0: "不限"]
        
        lazy var finessPicker = SinglePicker(title: .init("全新", color: .white, font: .semibold(16)), data: [1,0.99,0.9,0.8,0]) {[weak self, weak finessValue] item, sender in
            let value = titleMap[item]
            printLog(value)
            finessValue?.chain.normalTitle(text: titleMap[item]!)
            finessValue?.setImagePosition(.right, spacing: 5)
            self?.finess = item
            sender.popDismiss()
        } titleForDatum: {
            return titleMap[$0]!
        }
        finessPicker.setSelectedData(1)
        
        finessPicker.snp.makeConstraints { make in
            make.height.equalTo(280)
            make.width.equalTo(kScreenWidth)
        }
        
        finessInfoView.addBlock(for: .touchUpInside) {_ in
            finessPicker.popFromBottom()
        }
        
        
        let publishBtn = UIButton()
        view.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-12 - kBottomSafeInset)
            make.width.equalTo(240)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        publishBtn.chain.normalTitle(text: "发布").font(.semibold(18)).normalTitleColor(color: .white).backgroundColor(.kThemeColor).corner(radius: 6).clipsToBounds(true)
        
        publishBtn.addTarget(self, action: #selector(publish), for: .touchUpInside)
        
    }
    
    @objc func publish(){
        if !titleField.text.isValid{
            "请输入求购的标题".hint()
            return
        }
        
        if !contentTextView.text.isValid{
            "请输入商品描述".hint()
            return
        }
        
        if !priceValue.text.isValid{
            "请输入想要求购的价格".hint()
            return
        }
        
        if imagesRelay.value.count == 0{
            "请添加至少一张照片".hint()
            return
        }
        
        let imageList = imagesRelay.value
        let listPicImage = imageList[0]
        let contentPics = Array(imageList.suffix(from: 1))
        
        userService.request(.addWish(name: titleField.text!, content: contentTextView.text, good_type: 0, price: Float(priceValue.text!)!, list_pic: listPicImage, content_pics: contentPics, new_ratio_name:Int(self.finess * 10))) {[weak self] result in
            result.hj_map2 { body in
                "发布求购成功 ~~".hint()
                NotificationCenter.default.post(name: .init("kUserMadeWish"), object: nil)
                self?.popOrDismiss()
            }
        }
        
        
    }
}
