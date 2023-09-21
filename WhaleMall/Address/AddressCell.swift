

import UIKit

class AddressCell: UITableViewCell {
    
    var nameLB:UILabel!
    var phoneLB:UILabel!
    var addressLB:UILabel!
    var revampImage:UIButton!
    var newImgView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addressUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var address:AddressModel?{
        didSet{
            guard let data = address else { return }
            nameLB.text = data.uname
            phoneLB.text = data.phone
            addressLB.text = data.address_area
                .appending(data.address_detail)
            newImgView.isHidden = !data.is_default
        }
    }
    
    func addressUI(){
        self.contentView.backgroundColor = .white
        nameLB = UILabel(frame: CGRect.zero)
        nameLB.textColor = .kBlack
        nameLB.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(nameLB)
        nameLB.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(20)
        }
        
        phoneLB = UILabel(frame: CGRect.zero)
        
        phoneLB.textColor = .kBlack
        phoneLB.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(phoneLB)
        phoneLB.snp.makeConstraints { make in
            make.left.equalTo(nameLB.snp.right).offset(10)
            make.top.equalTo(nameLB)
        }
        
        addressLB = UILabel(frame: CGRect.zero)
        addressLB.textColor = .kTextLightGray
        addressLB.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        contentView.addSubview(addressLB)
        addressLB.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(nameLB.snp.bottom).offset(9)
            make.bottom.equalTo(-20)
        }
        
        revampImage = UIButton()
        revampImage.chain.normalImage(.init(named: "address_edit"))
        contentView.addSubview(revampImage)
        revampImage.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
        }
        
        newImgView = UIImageView(image: UIImage(named: "address_default"))
        newImgView.isHidden = true
        contentView.addSubview(newImgView)
        newImgView.snp.makeConstraints { make in
            make.left.equalTo(phoneLB.snp.right).offset(6)
            make.centerY.equalTo(phoneLB)
        }
        
        
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = .kSepLineColor
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
   
}
