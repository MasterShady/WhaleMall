//
//  SettingsVC.swift
//  FRMall
//
//  Created by 刘思源 on 2023/8/9.
//

import UIKit
import Kingfisher

class SettingsVC: BaseVC {
    
    var logoutBtn: UIButton!
    var deregisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarMaxY + 15)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        
        let resumeView = UIButton()
        resumeView.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        stackView.addArrangedSubview(resumeView)
        
        let resumeLabel = UILabel()
        resumeView.addSubview(resumeLabel)
        resumeLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        resumeLabel.chain.text(color: .kBlack).font(.systemFont(ofSize: 15)).text("个人资料")
        
        let resumeArrow = UIImageView(image: .init(named: "arrow"))
        resumeView.addSubview(resumeArrow)
        resumeArrow.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
        }
        
        resumeView.addBlock(for: .touchUpInside) {[weak self] _ in
            UserStore.checkLoginStatusThen {
                self?.navigationController?.pushViewController(MinePersonalVC(), animated: true)
            }
        }
        
        
        let addressView = UIButton()
        addressView.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        stackView.addArrangedSubview(addressView)
        
        let addressLabel = UILabel()
        addressView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        addressLabel.chain.text(color: .kBlack).font(.systemFont(ofSize: 15)).text("收货地址")
        
        let addressArrow = UIImageView(image: .init(named: "arrow"))
        addressView.addSubview(addressArrow)
        addressArrow.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
        }
        
        addressView.addBlock(for: .touchUpInside) {[weak self] _ in
            UserStore.checkLoginStatusThen {
                self?.navigationController?.pushViewController(AddressListVC(), animated: true)
            }
        }
        
        
        let cleanCacheView = UIView()
        cleanCacheView.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        let cleanLabel = UILabel()
        cleanCacheView.addSubview(cleanLabel)
        cleanLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        cleanLabel.chain.text(color: .kBlack).font(.systemFont(ofSize: 15)).text("清除缓存")
        
        let cleanValueLabel = UILabel()
        cleanCacheView.addSubview(cleanValueLabel)
        cleanValueLabel.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
        }
        cleanValueLabel.chain.text(color: .init(hexColor: "#A1A0AB")).font(.systemFont(ofSize: 14))
        
        let updateCache = {
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    let megabytes = Double(size) / (1024 * 1024)
                    cleanValueLabel.text = "\(megabytes.toString(decimalPlaces: 2)) MB"
                    break
                case .failure(_): break
                    
                }
            }
        }
        
        cleanCacheView.chain.tap {
            ImageCache.default.clearDiskCache {
                updateCache()
            }
        }
        updateCache()
        
        stackView.addArrangedSubview(cleanCacheView)
        
        
        let sep = UIView()
        sep.snp.makeConstraints { make in
            make.height.equalTo(10)
        }
        stackView.addArrangedSubview(sep)
        sep.chain.backgroundColor(.kExLightGray)
        
        let versionView = UIButton()
        versionView.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        stackView.addArrangedSubview(versionView)
        
        let versionLabel = UILabel()
        versionView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        versionLabel.chain.text(color: .kBlack).font(.systemFont(ofSize: 15)).text("当前版本号")
        
        let versionValueLabel = UILabel()
        versionView.addSubview(versionValueLabel)
        versionValueLabel.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
        }
        versionValueLabel.chain.text(color: .init(hexColor: "#A1A0AB")).font(.systemFont(ofSize: 14)).text(kAppVersion)
        
        deregisterBtn = UIButton()
        deregisterBtn.snp.makeConstraints { make in
            make.height.equalTo(51)
        }
        stackView.addArrangedSubview(deregisterBtn)
        deregisterBtn.chain.normalTitle(text: "注销账号").normalTitleColor(color: .red).font(.systemFont(ofSize: 14))
        deregisterBtn.addTarget(self, action: #selector(deregister), for: .touchUpInside)
        
        
        
        logoutBtn = UIButton()
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-kBottomSafeInset - 14)
            make.centerX.equalToSuperview()
        }
        logoutBtn.chain.font(.systemFont(ofSize:16)).normalTitle(text: "退出登录").normalTitleColor(color: .kTextBlack)
        logoutBtn.addBlock(for: .touchUpInside) { _ in
            UserStore.currentUser = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                "退出登录成功".hint()
            }
        }
        logoutBtn.isHidden = !UserStore.isLogin
        
    }
    
    override func onUserChanged() {
        logoutBtn.isHidden = !UserStore.isLogin
        deregisterBtn.isHidden = !UserStore.isLogin
    }
    
    @objc func deregister(){
        AEAlertView.show(title: "确定要注销账号吗?", message: "注销后账号资料会全部销毁,请谨慎选择", actions: ["确定注销","我再想想"]) { action in
            if action.title == "确定注销"{
                apiProvider.request(.any(path: "setParam/deRegister", params: [:], method: .post)) { result in
                    result.hj_map2(IgnoreData.self) { body, error in
                        if error == nil{
                            UserStore.currentUser = nil
                            "注销成功".hint()
                        }
                    }
                }
            }
        }
    }
    
    
}
