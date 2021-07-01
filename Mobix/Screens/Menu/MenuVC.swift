// 

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var onHome: (()->())?
    var onCredentialsIssued: (()->())?
    var onCredentialVerification: (()->())?
    var onSettings: (()->())?
    var onFAQ: (()->())?
    let tableView = UITableView()
    let versionLabel = UILabel()
    var lastSlectedIndexPath = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        navigationController?.isNavigationBarHidden = true
        setUpHeader()
        setUpFullscreenView(mainView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = -UIApplication.shared.statusBarFrame.height
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview().inset(30)
        }
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        versionLabel.text = "v.\(appVersion) build:\(appBuild)"
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        if indexPath.row == 0 {
            cell.label.text = "wallet".localized
            return cell
        }  else if indexPath.row == 1 {
            cell.label.text = "get_free_mobix".localized
            return cell
        } else if indexPath.row == 2 {
            cell.label.text = "faq".localized
            return cell
        } else if indexPath.row == 3 {
            cell.label.text = "app_settings".localized
            return cell
        }
//        else if indexPath.row == 3 {
//            cell.label.text = "settings".localized
//            return cell
//        } else if indexPath.row == 4 {
//            cell.label.text = "faq".localized
//            return cell
//        }
        else {
            fatalError("not implemented")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            onHome?()
            lastSlectedIndexPath = indexPath
        } else if indexPath.row == 1 {
            onCredentialsIssued?()
            lastSlectedIndexPath = indexPath
        } else if indexPath.row == 2 {
            onCredentialVerification?()
            lastSlectedIndexPath = indexPath
        } else if indexPath.row == 3 {
            tableView.selectRow(at: lastSlectedIndexPath, animated: true, scrollPosition: .top)
        }
//        else if indexPath.row == 3 {
//            onSettings?()
//        } else if indexPath.row == 4 {
//            onFAQ?()
//        }
    }
    
    func setUpHeader() {
        let headerView = MenuHeaderView()
        headerView.configure()
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
    

}
