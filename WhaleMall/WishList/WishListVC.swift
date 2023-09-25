//
//  WishListVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/13.
//

import UIKit
import MJRefresh
import FTPopOverMenu_Swift

func finessDiscirption(_ finess: Int) -> String{
    if finess == 8{
        return "8成新"
    }
    if finess == 9{
        return "9成新"
    }
    if finess == 10{
        return "全新"
    }
    return "成色不限"
}


class PostBlackListManager {
    
    static var blackList : [Int] {
        return UserDefaults.standard.array(forKey: "PostBlackList") as? [Int] ?? [Int]()
    }
    
    static func addPost(id : Int){
        var list = self.blackList
        list.append(id)
        UserDefaults.standard.set(list, forKey: "PostBlackList")
        UserDefaults.standard.synchronize()
    }
}


class WishCell: UITableViewCell{
    
    var product: Product?{
        didSet {
            guard let product = product else {return}
            cover.image = product.list_pic_base64.toImage()
            titleLabel.text = product.name
            contentTitleLabel.text = product.detail_content
            finessLabel.text = finessDiscirption(product.new_ratio_name)
            
            let timeDiff = Int(Date().timeIntervalSince(product.create_time))
            
            let dayDiff = timeDiff / 86400
            let hourDiff = timeDiff / 3600
            let miniteDiff = timeDiff / 60
            
            if dayDiff > 0{
                timeLabel.text = "\(kAppName)用户求购于 \(dayDiff) 天前"
            }else if hourDiff > 0 {
                timeLabel.text = "\(kAppName)用户求购于 \(hourDiff) 小时前"
            }else if miniteDiff > 0{
                timeLabel.text = "\(kAppName)用户求购于 \(miniteDiff) 分钟前"
            }else{
                timeLabel.text = "\(kAppName)用户刚刚发布求购"
            }
            
            let count = product.wish_count
            if count > 0{
                countLabel.text = "其它\(product.name.hashMapToInt(10))名用户也在求购"
            }else{
                countLabel.text = nil
            }
        }
    }
    
    
    
    var cover: UIImageView!
    var titleLabel: UILabel!
    var contentTitleLabel: UILabel!
    var finessLabel: UILabel!
    var timeLabel: UILabel!
    var countLabel: UILabel!
    
    var menuClickHandler : IntBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubview(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        cover = .init()
        
        let container = UIView()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(0)
        }
        container.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        container.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.height.width.equalTo(100)
        }
        cover.chain.corner(radius: 5).clipsToBounds(true).contentMode(.scaleAspectFill)
        
        titleLabel = .init()
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(cover.snp.right).offset(14)
            //make.right.equalTo(-14)
        }
        titleLabel.chain.text(color: .kTextBlack).font(.semibold(14)).numberOfLines(2)
        
        
        let reportBtn = UIButton()
        container.addSubview(reportBtn)
        reportBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalTo(-14)
            make.bottom.equalTo(titleLabel.snp.firstBaseline)
            make.width.height.equalTo(16)
        }
        reportBtn.chain.normalImage(.init(named: "more"))
        reportBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        
        contentTitleLabel = .init()
        container.addSubview(contentTitleLabel)
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.right.equalTo(-14)
        }
        contentTitleLabel.chain.text(color: .kTextDrakGray).font(.normal(12)).numberOfLines(3)
        
        let finessTitleLabel = UILabel()
        container.addSubview(finessTitleLabel)
        finessTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        finessTitleLabel.chain.text(color: .kTextDrakGray).font(.normal(12)).text("成色要求:")
        
        finessLabel = .init()
        container.addSubview(finessLabel)
        finessLabel.snp.makeConstraints { make in
            make.left.equalTo(finessTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(finessTitleLabel)
        }
        finessLabel.chain.text(color: .kTextPink).font(.semibold(12))
        
        let sep = UIView()
        container.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(1)
        }
        sep.backgroundColor = .kSepLineColor
        
        timeLabel = .init()
        container.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(sep.snp.bottom).offset(12)
            make.right.equalTo(-14)
            make.bottom.equalTo(-12)
        }
        
        timeLabel.chain.text(color: .kTextDrakGray).font(.normal(12))
        
        countLabel = .init()
        container.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalTo(timeLabel)
        }
        countLabel.chain.text(color: .kTextDrakGray).font(.normal(12))
    }
    
    
    @objc func moreAction(sender: UIButton){
        let configuration = FTConfiguration()
        configuration.textAlignment = .center
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["举报", "不喜欢"],
                                    config: configuration,
                                    done: {[weak self] (selectedIndex) -> () in
            
            self?.menuClickHandler?(selectedIndex)
        }) {
            
        }
    }
    
}

class WishListVC: BaseVC {
    
    var productListRelay = BehaviorRelay(value: [Product]())
    var tableView: UITableView!
    

    
    override func configNavigationBar() {
        self.navigationItem.title = "心愿广场"
    }
    
    
    override func networkRequest() {
        tableView.mj_header?.beginRefreshing()
    }
    
    func loadData(){
        userService.request(.goodsList(data_type: 1)) {[weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            result.hj_map2(Product.self) { body in
                let rawList = body.decodedObjList!
                let filteredList = rawList.filter { product in
                    return !PostBlackListManager.blackList.contains(product.id)
                }
                self?.productListRelay.accept(filteredList)
            }
        }
    }
    
    override func configData() {
        NotificationCenter.default.addObserver(self, selector: #selector(onRefresh), name: .init("kUserMadeWish"), object: nil)
    }
    
    @objc func onRefresh(){
        tableView.mj_header?.beginRefreshing()
    }
    
    override func configSubViews() {
        self.edgesForExtendedLayout = .bottom
        tableView = UITableView()
        tableView.backgroundColor = .clear
        //tableView.contentInsetAdjustmentBehavior = .always
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(WishCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        
        productListRelay.bind(to: tableView.rx.items(cellIdentifier: "cellId", cellType: WishCell.self)) {index, element ,cell in
            cell.product = element
            cell.menuClickHandler = { [weak self] index in
                guard let self = self else {return}
                if index == 0{
                    //举报
                    let reportView = ReportView()
                    reportView.dismissHandler = {[weak self] result in
                        guard let self = self else {return}
                        if result{
                            PostBlackListManager.addPost(id: element.id)
                            "感谢您的反馈,我们将进行审核".hint()
                            let rawList = self.productListRelay.value
                            let filteredList = rawList.filter { product in
                                return !PostBlackListManager.blackList.contains(product.id)
                            }
                            self.productListRelay.accept(filteredList)
                        }
                    }
                    reportView.popView(fromDirection: .center, tapToDismiss: false)
                }else{
                    //不喜欢
                    PostBlackListManager.addPost(id: element.id)
                    "感谢您的反馈,我们将减少此类推荐".hint()
                    let rawList = self.productListRelay.value
                    let filteredList = rawList.filter { product in
                        return !PostBlackListManager.blackList.contains(product.id)
                    }
                    self.productListRelay.accept(filteredList)
                }
            }
        }.disposed(by: disposeBag)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadData()
        })
        
        tableView.rx.itemSelected.subscribe {[weak self] indexPath in
            guard let self = self else {return}
             let product = self.productListRelay.value[indexPath.row]
             let vc = WishDetailVC(product: product)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        
        let makeWishBtn = UIButton()
        view.addSubview(makeWishBtn)
        makeWishBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-17 - kTabbarHeight)
            make.centerX.equalToSuperview()
        }
        makeWishBtn.chain.normalImage(.init(named: "make_wish_list"))
        
        makeWishBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            UserStore.checkLoginStatusThen {
                let vc = CreatePostVC()
                let nav = NavVC(rootViewController: vc)
                self?.present(nav, animated: true)
            }
        }
        
    }
    
    deinit {
        printLog("die")
    }
}
