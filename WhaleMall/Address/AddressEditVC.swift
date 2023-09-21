
import UIKit

class AddressEditVC: BaseVC {
    var phoneTF:UITextField!
    var nameTF:UITextField!
    var addressTF:UITextField!
    var onswitch:UISwitch!
    var cityLB:UILabel!
    
    var is_default: Bool = false
    
    var myCity: String?
    var myProvince: String?
    var myArea: String?
    
    var address: AddressModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configSubViews(){
        if self.address == nil{
            self.title = "新建地址"
        }else{
            self.title = "编辑地址"
        }
        
        
        let nameView = UIView()
        self.view.addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavBarMaxY)
            make.height.equalTo(62)
        }
        
        let  nameLB = UILabel.init(frame: CGRect.zero)
        nameLB.text = "收货人"
        nameLB.textColor = .kBlack
        nameLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameView.addSubview(nameLB)
        
        nameLB.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        nameTF = UITextField()
        nameTF.textColor = .kTextBlack
        
        let placeholderAttr = [NSAttributedString.Key.foregroundColor: UIColor.kLightGray]
        
        nameTF.attributedPlaceholder = NSAttributedString.init(string: "请填写姓名", attributes:placeholderAttr)
        nameTF.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        nameTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        nameView.addSubview(nameTF);
        nameTF.snp.makeConstraints { make in
            make.left.equalTo(94)
            make.centerY.equalToSuperview()
            make.right.equalTo(-14)
        }
        
        let nameLine = UIView.init(frame: CGRect.zero)
        nameLine.backgroundColor = .kSepLineColor
        nameView.addSubview(nameLine)
        nameLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(0.5)
        }
        
        
        let phoneView = UIView()
        self.view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(62)
        }
        
        let  phoneLB = UILabel()
        phoneLB.text = "手机号码"
        phoneLB.textColor = .kBlack
        phoneLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        phoneView.addSubview(phoneLB)
        
        phoneLB.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        phoneTF = UITextField()
        phoneTF.borderStyle = UITextField.BorderStyle.none
        phoneTF.textColor = .kBlack
        phoneTF.attributedPlaceholder = NSAttributedString.init(string: "请填写手机号码", attributes: placeholderAttr)
        
        phoneTF.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        phoneTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        phoneTF.keyboardType = UIKeyboardType.numberPad
        phoneTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        phoneView.addSubview(phoneTF);
        
        phoneTF.snp.makeConstraints { make in
            make.left.equalTo(94)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        let phoneLine = UIView.init(frame: CGRect.zero)
        phoneLine.backgroundColor = .kSepLineColor
        phoneView.addSubview(phoneLine)
        phoneLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(0.5)
        }
        
        
        let cityView = UIView()
        cityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(cityViewTapAction)))
        
        self.view.addSubview(cityView)
        cityView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(phoneView.snp.bottom)
            make.height.equalTo(62)
        }
        
        let  regionLB = UILabel()
        regionLB.text = "所在地区"
        regionLB.textColor = .kBlack
        regionLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        cityView.addSubview(regionLB)
        
        regionLB.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        cityLB = UILabel()
        cityLB.text = "请选择"
        cityLB.textColor = address == nil ? .kTextLightGray: .kBlack
        cityLB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cityView.addSubview(cityLB)
        
        cityLB.snp.makeConstraints { make in
            make.left.equalTo(94)
            make.right.equalTo(16)
            make.centerY.equalToSuperview()
        }
        let rightImage = UIImageView(image: .init(named:"settings_arrow"))
        cityView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.right.equalTo(-14)
            
            make.centerY.equalToSuperview()
        }
        
        let cityLine = UIView.init(frame: CGRect.zero)
        cityLine.backgroundColor = .kSepLineColor
        cityView.addSubview(cityLine)
        cityLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(0.5)
        }
        
        
        let addressView = UIView()
        self.view.addSubview(addressView)
        addressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cityView.snp.bottom)
            make.height.equalTo(62)
        }
        
        let  addressLB = UILabel()
        addressLB.text = "详细地址"
        addressLB.textColor = .kTextBlack
        addressLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        addressView.addSubview(addressLB)
        
        addressLB.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        addressTF = UITextField()
        addressTF.borderStyle = UITextField.BorderStyle.none
        addressTF.textColor = .kTextBlack
        addressTF.attributedPlaceholder = NSAttributedString.init(string: "街道、楼牌号等", attributes: placeholderAttr)
        addressTF.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        addressTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        addressTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        addressView.addSubview(addressTF);
        
        addressTF.snp.makeConstraints { make in
            make.left.equalTo(94)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        let addressLine = UIView()
        addressLine.backgroundColor = .kSepLineColor
        addressView.addSubview(addressLine)
        addressLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(16)
            make.height.equalTo(0.5)
        }
        
        let defaultView  = UIView()
        defaultView.backgroundColor = .gradient(fromColors: [.init(hexColor: "#B2FAFD"), .init(hexColor: "#FEF2FF")], size: CGSize(width: kScreenWidth - 28, height: 78))
        defaultView.layer.cornerRadius = 12
        defaultView.layer.masksToBounds = true
        self.view.addSubview(defaultView)
        defaultView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(addressView.snp.bottom).offset(27)
            make.height.equalTo(78)
        }
        
        let  defaultLB = UILabel.init(frame: CGRect.zero)
        defaultLB.text = "设置默认地址"
        defaultLB.textColor = .kBlack
        defaultLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        defaultView.addSubview(defaultLB)
        
        defaultLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.centerY.equalToSuperview().offset(-SCALE_HEIGTHS(value: 10))
        }
        
        let  hintLB = UILabel.init(frame: CGRect.zero)
        hintLB.text = "每次下单会默认推荐该地址"
        hintLB.textColor = .init(hexColor: "999999")
        hintLB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        defaultView.addSubview(hintLB)
        
        hintLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.centerY.equalToSuperview().offset(SCALE_HEIGTHS(value: 10))
        }
        
        onswitch = UISwitch()
        defaultView.addSubview(onswitch)
    
        onswitch.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        onswitch.isOn = is_default
        onswitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);//可以使用transform修改switch的大小
        onswitch.thumbTintColor = UIColor.white//滑块上小圆点的颜色
        onswitch.onTintColor = .init(hexColor: "#E481F7") //设置开启状态显示的颜色
        onswitch.tintColor = .white //设置关闭状态的颜色
        
        onswitch.addTarget(self, action: #selector(switchClick), for: .valueChanged)
        
        let addressBtn = UIButton.init(frame: CGRect.zero)
        addressBtn.backgroundColor = .kPinkColor
        addressBtn.layer.cornerRadius = 12
        addressBtn.layer.masksToBounds = true
        addressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addressBtn.setTitleColor( .white, for: .normal)
        addressBtn.setTitle(self.address != nil ? "修改收货地址" : "确定", for: .normal)
        addressBtn.addTarget(self, action: #selector(addressBtnClickAction), for: .touchUpInside)
        
        self.view.addSubview(addressBtn);
        addressBtn.snp.makeConstraints { make in
            make.height.equalTo(47)
            make.width.equalTo(263)
            make.bottom.equalTo(-30 - kBottomSafeInset)
            make.centerX.equalToSuperview()
            
        }
        
        if let address = self.address{
            phoneTF.text = address.phone
            nameTF.text = address.uname
            cityLB.text = address.address_area
            addressTF.text = address.address_detail
        }else{
                
        }

    }
    
    
    
    @objc func switchClick(){
        is_default = onswitch.isOn
    }
    
    //新增收货地址
    @objc private func addressBtnClickAction() {
        guard let name = nameTF.text, name.count > 0 else {
            "请填写收货人姓名".hint()
            return
        }
        
        guard let phone = phoneTF.text, phone.count > 0 else {
            "请填写手机号码".hint()
            return
        }
        
        guard let area = cityLB.text, area.count > 0 else {
            "请选择所在地区".hint()
            return
        }
        
        guard let addressDetial = addressTF.text, addressDetial.count > 0 else {
            "请填写详细地址".hint()
            return
        }
        
        
       
        
        if let address = self.address{
            userService.request(.updateAddress(id: address.id, uname: name, phone: phone, address_area: area, address_detail: addressDetial, is_default: is_default)) { result in
                result.hj_map2(IgnoreData.self) { body, error in
                    if let error = error {
                        error.msg.hint()
                        return
                    }
                    "修改成功".hint()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                
            }
            
        }else {
            userService.request(.addAddress(uname: name, phone: phone, address_area: area, address_detail: addressDetial, is_default: is_default)) { result in
                result.hj_map2(IgnoreData.self) { body, error in
                    if let error = error {
                        error.msg.hint()
                        return
                    }
                    "添加地址成功".hint()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    @objc private func cityViewTapAction() {
        let address = KLCityPickerView()
        address.pickerLabelTextCoclor = .kTextBlack
        address.areaPickerViewWithProvince(province: self.myProvince, city: self.myCity, area: self.myArea) {[weak self] (province, city, area) in
            guard let self = self else {return}
            self.myProvince = province
            self.myCity = city
            self.myArea = area

            self.cityLB.text = [province, city, area].joined()
        }
    }
}
