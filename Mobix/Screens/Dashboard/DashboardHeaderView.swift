// 

import Foundation
import UIKit

struct DashboardHeaderViewModel {
    let balance: String
}

class DashboardHeaderView: UIView {
    private let balanceLabel = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        setUpButtons()
        setUpLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: DashboardHeaderViewModel) {
        balanceLabel.text = viewModel.balance
    }
    
    private func addSubviews() {
        addSubview(balanceLabel)
    }
    
    private func applyConstraints() {
        
    }
    
    private func setUpLabels() {
        
    }
    
    private func setUpButtons() {
    }
}

