////
////  MinePersonalVC.swift
////  Shella
////
////  Created by wjj on 2023/7/11.
////
//
import UIKit
import CLImagePickerTool
class MinePersonalVC: BaseVC {
    var nameLabel: UILabel!
    var sexLabel: UILabel!
    var birthdayLabel: UILabel!
    var headImageView:UIImageView!
    var  imagePickTool:CLImagePickerTool?
    var bottomPickerView:UIView!
    var datePicker:UIDatePicker!
    var name :String!
    var sexString :String!
    var birthdayString :String!
    
    lazy var currentUser = UserStore.currentUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        
        name = currentUser.nickname
//        sexString =  currentUser.gender
//        birthdayString =  currentUser.birthday
        
        showImageViewUI(rightTitle: "头像", headimageStr: "user_avatar", top: NAV_HEIGHT) { imageView in
            headImageView = imageView
        } clickHandler: { [weak self] _ in
            self?.imagePickHandler()
            
        }

        
        showCellViewUI(rightTitle: "昵称", contentStr: name, top: NAV_HEIGHT + 80) { label in
            nameLabel = label
        } clickHandler: { [weak self] _  in
            self?.TextFieldHandler()
           
        }
        
//        showCellViewUI(rightTitle: "性别", contentStr: sexString, top: NAV_HEIGHT + 134) { label in
//            sexLabel = label
//        } clickHandler: { [weak self] _  in
//            self?.AlertHandler()
//        }
//
//        showCellViewUI(rightTitle: "生日", contentStr: birthdayString, top: NAV_HEIGHT + 188) { label in
//            birthdayLabel = label
//        } clickHandler: { [weak self] _  in
//            self?.PickerViewUI()
//        }
//
       
    }
    
    func showCellViewUI(rightTitle: String,contentStr:String,top:CGFloat,rightLBCallback:(UILabel)->(),clickHandler: @escaping (Any)->()) {
        let collectView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(collectView)
        collectView.addGestureRecognizer(UITapGestureRecognizer(actionBlock: clickHandler))
        collectView.backgroundColor = UIColor.white
        collectView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(SCALE_HEIGTHS(value: top))
            make.height.equalTo(SCALE_HEIGTHS(value: 55))
        }
        
        let lineView = UIView.init(frame: CGRect.zero)
        lineView.backgroundColor = UIColor(hexString: "F5F6F7")
        collectView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 20))
            make.right.equalTo(-SCALE_WIDTHS(value: 20))
            make.top.equalToSuperview()
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
        }
        
        let collectLB = UILabel.init(frame: CGRect.zero)
        collectLB.text = rightTitle
        collectLB.textColor = .init(hexColor: "333333")
        collectLB.font = .systemFont(ofSize: 15)
        collectView.addSubview(collectLB)
        collectLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 10))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
        let rightImage = UIImageView.init(frame: CGRect.zero)
        let rightimage = UIImage(named:"icon_right")
        rightImage.image = rightimage
        collectView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 13))
            make.height.equalTo(SCALE_WIDTHS(value: 14))
            make.width.equalTo(SCALE_WIDTHS(value: 14))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
        
        
        let rightLB = UILabel.init(frame: CGRect.zero)
        rightLBCallback(rightLB)
        rightLB.text = contentStr
        rightLB.textColor = .init(hexColor:"999999")
        rightLB.font = .systemFont(ofSize: 13)
        collectView.addSubview(rightLB)
        rightLB.snp.makeConstraints { make in
            make.right.equalTo(rightImage.snp.right).offset(-SCALE_WIDTHS(value: 10))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
    }

    func showImageViewUI(rightTitle: String,headimageStr:String,top:CGFloat,headImageCallback:(UIImageView)->(),clickHandler: @escaping (Any)->()) {
        let collectView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(collectView)
        collectView.addGestureRecognizer(UITapGestureRecognizer(actionBlock: clickHandler))
        collectView.backgroundColor = UIColor.white
        collectView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(SCALE_HEIGTHS(value: top))
            make.height.equalTo(SCALE_HEIGTHS(value: 80))
        }
        let collectLB = UILabel.init(frame: CGRect.zero)
        collectLB.text = rightTitle
        collectLB.textColor = .init(hexColor:"333333")
        collectLB.font = .systemFont(ofSize: 15)
        collectView.addSubview(collectLB)
        collectLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 10))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
        let rightImage = UIImageView.init(frame: CGRect.zero)
        let rightimage = UIImage(named:"arrow")
        rightImage.image = rightimage
        collectView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 13))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
        
        
        
        let headImage = UIImageView.init(frame: CGRect.zero)
        headImageCallback(headImage)
        headImage.image = currentUser.photo
        

        
        headImage.layer.cornerRadius = SCALE_WIDTHS(value: 20)
        headImage.layer.masksToBounds  = true
        collectView.addSubview(headImage)
        headImage.snp.makeConstraints { make in
            make.right.equalTo(rightImage.snp.right).offset(-SCALE_WIDTHS(value: 10))
            make.height.equalTo(SCALE_WIDTHS(value: 40))
            make.width.equalTo(SCALE_WIDTHS(value: 40))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
        
    }
    
    func AlertHandler(){
        let alertController = UIAlertController(title: "选择性别", message: "", preferredStyle: .actionSheet)
        let cancelaction = UIAlertAction(title: "取消", style: .cancel)
        let manAction = UIAlertAction(title: "男", style: .default) { [weak self] action in
            guard let self = self else {return}
            self.sexLabel.text = action.title
            self.currentUser.gender = action.title
            UserStore.updateUserCutomProperties(self.currentUser)
            
        }
        let woAction = UIAlertAction(title: "女", style: .default) { [weak self] action in
            guard let self = self else {return}
            self.sexLabel.text = action.title
            self.currentUser.gender = action.title
            UserStore.updateUserCutomProperties(self.currentUser)
        }
        alertController.addAction(cancelaction)
        alertController.addAction(manAction)
        alertController.addAction(woAction)
        UIViewController.getCurrent()?.present(alertController, animated: true)
       
    }
    
    func TextFieldHandler(){
        let alertController = UIAlertController(title: "修改昵称", message: "", preferredStyle: .alert)
        
        alertController.addTextField { nicknameTextField in
            nicknameTextField.placeholder = "昵称不能超过10个字符!"
        }
        let cancelaction = UIAlertAction(title: "取消", style: .cancel)
        let okAction = UIAlertAction(title: "确定", style: .default) { [weak self] action in
            guard let self = self else {return}
            let nicknameText = alertController.textFields?[0]
            self.nameLabel.text = nicknameText?.text
            self.currentUser.realname = nicknameText?.text
            UserStore.updateUserCutomProperties(self.currentUser)
//            NotificationCenter.default.post(name: .init(rawValue: CWZ_ChangeImageNotification), object: nil)
            
        }
       
        alertController.addAction(cancelaction)
        alertController.addAction(okAction)
        
        UIViewController.getCurrent()?.present(alertController, animated: true)
       
    }
    
    func imagePickHandler(){
        //修改图像
           imagePickTool = CLImagePickerTool.init()
         imagePickTool?.isHiddenVideo = true
        imagePickTool?.cameraOut = true //设置相机选择在外部
        imagePickTool?.singleImageChooseType = .singlePicture //单选模式
        imagePickTool?.singleModelImageCanEditor = true //设置单选模式下图片可以编辑涂鸦

        //使用asset来转化自己想要的指定压缩大小的图片，cutImage只有在单选剪裁的情况下才返回,其他情况返回nil
        imagePickTool?.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: self) {[weak self] (assets, cutImage) in

            print("当前选择的内容 assets == \(assets)  cutImage == \(cutImage!)")
            guard let self = self else {return}
            guard let image = cutImage else { return }
            self.headImageView.image = image
            
            self.currentUser.photo = image
            UserStore.updateUserCutomProperties(self.currentUser)
            NotificationCenter.default.post(name: .init(rawValue: "ChangeImageNotification"), object: nil)
         
        }
    }
    
    
    func PickerViewUI()  {
         
        bottomPickerView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(bottomPickerView)
        bottomPickerView.backgroundColor = .init(hexColor:"000000", alpha: 0.5)
        bottomPickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let introduceView = UIView.init(frame: CGRect.zero)
        introduceView.backgroundColor = UIColor.white
        introduceView.layer.cornerRadius = SCALE_HEIGTHS(value: 15)
        introduceView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        bottomPickerView.addSubview(introduceView)
        introduceView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(SCALE_HEIGTHS(value: 285))
        }
        
        let cancelBtn = UIButton.init(frame: CGRect.zero)
        cancelBtn.titleLabel?.font = .medium(16)
        cancelBtn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.isUserInteractionEnabled = true
        cancelBtn.addTarget(self, action: #selector(cancelBtnClickAction), for: .touchUpInside)
        introduceView.addSubview(cancelBtn);
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCALE_WIDTHS(value: 20))
            make.top.equalToSuperview().offset(SCALE_HEIGTHS(value: 7))
           
        }
        
        let finishBtn = UIButton.init(frame: CGRect.zero)
        finishBtn.titleLabel?.font = .medium(16)
        finishBtn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        finishBtn.setTitle("完成", for: .normal)
        finishBtn.isUserInteractionEnabled = true
        finishBtn.addTarget(self, action: #selector(finishBtnClickAction), for: .touchUpInside)
        introduceView.addSubview(finishBtn);
        finishBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-SCALE_WIDTHS(value: 20))
            make.top.equalToSuperview().offset(SCALE_HEIGTHS(value: 7))
           
        }
        
        let  titlelabel = UILabel.init(frame: CGRect.zero)
        titlelabel.font = .medium(18)
        titlelabel.textColor = .init(hexColor: "333333")
        titlelabel.textAlignment = .left
        titlelabel.text = "选择出生日期"
        introduceView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SCALE_HEIGTHS(value: 10))
            make.centerX.equalToSuperview()
        }
        
        datePicker = UIDatePicker(frame: CGRect.zero)
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
         
        introduceView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(SCALE_HEIGTHS(value: 230))
        }
        
    }
    
    //点击完成按钮
    @objc private func finishBtnClickAction() {
    
        bottomPickerView.removeFromSuperview()
        
        let formatter =  DateFormatter ()
        formatter.dateFormat = "yyyy-MM-dd"
        birthdayLabel.text = formatter.string(from: datePicker.date)
        UserDefaults.standard.setValue(birthdayLabel.text, forKey: "birthday")
        
    }
    
    //点击取消按钮
    @objc private func cancelBtnClickAction() {
        print("点击取消按钮")
        bottomPickerView.removeFromSuperview()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
