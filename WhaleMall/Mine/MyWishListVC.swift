//
//  MyWishListVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/21.
//

import Foundation
import MJRefresh

class MyWishListVC: BaseVC{
    var productListRelay = BehaviorRelay(value: [Product]())
    var tableView: UITableView!
    var didLoadData = false
    
    
    override func configNavigationBar() {
        self.navigationItem.title = "我的求购"
    }
    
    
    override func networkRequest() {
        tableView.mj_header?.beginRefreshing()
    }
    
    func loadData(){
        userService.request(.goodsList(data_type: 1, me_publish: true)) {[weak self] result in
            self?.didLoadData = true
            self?.tableView.mj_header?.endRefreshing()
            result.hj_map2(Product.self) { body in
                let products = body.decodedObjList!
                self?.productListRelay.accept(products)
            }
        }
    }
    
    override func configSubViews() {
        self.edgesForExtendedLayout = .bottom
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(WishCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        
        productListRelay.bind(to: tableView.rx.items(cellIdentifier: "cellId", cellType: WishCell.self)) {index, element ,cell in
            cell.product = element
        }.disposed(by: disposeBag)
        
        productListRelay.subscribe {[weak self] products in
            guard let self = self else {return}
            if products.count == 0 && self.didLoadData{
                self.tableView.showStatus(.noData)
            }else{
                self.tableView.hideStatus()
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
        
        
        
        
    }
}


