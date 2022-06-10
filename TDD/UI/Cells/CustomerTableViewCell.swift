//
//  CustomerTableViewCell.swift
//  TDD
//
//  Created by Mickael Belhassen on 17/03/2022.
//

import UIKit

class CustomerTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var nameLbl: UILabel!

    var customer: Customer? {
        didSet {
            reloadView()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Configure view

private extension CustomerTableViewCell {

    func reloadView() {
        nameLbl.text = customer?.name.rawValue
    }

}
