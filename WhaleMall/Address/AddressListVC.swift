

import UIKit
import MJRefresh

/*
 屏幕宽度
 */
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

/*
 屏幕高度
 */
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/*
 状态栏高度
 */
public let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
/*
 导航栏高度
 */
public let NAV_HEIGHT = UIApplication.shared.statusBarFrame.height + 44.0
/*
 底部TableBar高度
 */
public let TABLEBAR_HEIGHT:CGFloat  = UIApplication.shared.statusBarFrame.height > 20 ? 83.0 : 49.0
/*
 底部下巴高度
 */
public let BOTTOM_HEIGHT:CGFloat  = UIApplication.shared.statusBarFrame.height > 20 ? 34.0 : 0.0

public let BASE_HEIGHT_SCALE = (SCREEN_HEIGHT / 667.0)
 
public let BASE_WIDTH_SCALE = (SCREEN_WIDTH / 375.0)

/*
 导航栏基础高度
 */
public let NAVBAR_BASE_HEIGHT = CGFloat(44.0)

/*
 比例计算宽度(宽度)
 */
public func SCALE_WIDTHS(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let numFloat = width.truncatingRemainder(dividingBy: 1)
          let newWidth = width - numFloat
          return newWidth
}

/*
 比例计算高度(高度)
 */
public func SCALE_HEIGTHS(value:CGFloat) -> CGFloat {
    let width = value * BASE_WIDTH_SCALE
    let numFloat = width.truncatingRemainder(dividingBy: 1)
          let newWidth = width - numFloat
          return newWidth
}

class AddressListVC: BaseVC {
    var dataList = [AddressModel]()
    var didSelectComplete: ((AddressModel) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAdress()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的地址"
        tableView.register(AddressCell.self, forCellReuseIdentifier: NSStringFromClass(AddressCell.self))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(kNavBarMaxY)
        }
        
        let addressBtn = UIButton.init(frame: CGRect.zero)
        addressBtn.backgroundColor = .kPinkColor
//        addressBtn.backgroundColor = .gradient(colors: [.init(hexColor: "#F4BEF7"), .init(hexColor: "#E481F7")], from: CGPoint(x: 263/2.0, y: 0), to: CGPoint(x: 263/2.0, y: 47), size: CGSize(width: 263, height: 47))
        addressBtn.layer.cornerRadius = 12
        addressBtn.layer.masksToBounds = true
        addressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addressBtn.setTitleColor( .white, for: .normal)
        addressBtn.setTitle("新增收货地址", for: .normal)
        addressBtn.addTarget(self, action: #selector(addressBtnClickAction), for: .touchUpInside)
         
        self.view.addSubview(addressBtn);
        addressBtn.snp.makeConstraints { make in
            make.width.equalTo(263)
             make.height.equalTo(48)
            make.bottom.equalTo(-30 - kBottomSafeInset)
            make.centerX.equalToSuperview()
             
         }
        
        
    }
    
    
    lazy var tableView:UITableView = {
        let addressListTableView = UITableView()
        addressListTableView.separatorStyle = .none
        addressListTableView.delegate = self
        addressListTableView.dataSource = self
        addressListTableView.backgroundColor = .clear
        addressListTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadAdress()
        })
        return addressListTableView
    }()
    
    //新增收货地址
    @objc private func addressBtnClickAction() {
        let addressVC = AddressEditVC()
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    
    
    func loadAdress() {
        userService.request(.getAddressList) { result in
            result.hj_map2(AddressModel.self) {[weak self] body, error in
                guard let self = self else {
                    return
                }
                self.dataList = body?.decodedObjList ?? []
                CRAddressManager.shared.defaultAddressModel = self.dataList.first(where:{ $0.is_default})
                self.configNoData()
                self.tableView.reloadData()
                self.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
    func configNoData() {
        if self.dataList.count > 0 {
            self.tableView.hideStatus()
        } else {
            self.tableView.showStatus(.noData, offset: CGPoint(x: 0, y: -100))
        }
    }
}

extension AddressListVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AddressCell.self), for: indexPath) as! AddressCell
        cell.address = dataList[indexPath.row]
        
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let didSelectComplete = didSelectComplete {
            didSelectComplete(dataList[indexPath.row])
            UIViewController.getCurrent().navigationController?.popViewController(animated: true)
            return
        }
        
        let data = self.dataList[indexPath.row]
        let addressVC = AddressEditVC()
        addressVC.address = data
        self.navigationController?.pushViewController(addressVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let deleteAction = UIContextualAction(style: .normal, title: "删除") { [weak self] (action, view, resultClosure) in
                guard let self = self else {return}
                AEAlertView.show(title: "确定删除吗?", message: "删除后无法恢复", actions: ["删除","取消"]) {[weak self] action in
                    if action.title == "删除"{
                        guard let self = self else {return}
                        let model = self.dataList[indexPath.row]
                        self.dataList.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        
                        userService.request(.deleteAddress(id:model.id)) { result in
                            
                        }
                    }else{
                        
                    }
                }
            }
            deleteAction.backgroundColor = .red
            let actions = UISwipeActionsConfiguration(actions: [deleteAction])
            actions.performsFirstActionWithFullSwipe = false; // 禁止侧滑到最左边触发删除回调事件
            return actions
        }
    
    
    
    
   
}
