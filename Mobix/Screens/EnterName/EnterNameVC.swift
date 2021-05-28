// 

import UIKit

class EnterNameVC: UIViewController {
    private let mainView = EnterNameView()
    var onContinue: (()->())?
    
    let cancellable = Cosmos.shared.publisher.sink { (cosmosCoin) in
        print(cosmosCoin)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFullscreenView(mainView: mainView)
        mainView.continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
//        mainView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.setUpButtons()
    }
    
    @objc func continueButtonAction() {
        guard let username = mainView.textField.text,
              !username.isEmpty else {
            AlertPresenter.present(message: "Set Username", type: .warning)
            return}
        UserCache.shared.username = username
        onContinue?()
    }
    
}


class UserCache {
    private let userFileName = "username"
    static var shared = UserCache()
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    var username: String? {
        get {
            return getUsername()
        }
        set {
            saveUsername(newValue!)
        }
    }
    private init() {}
    
    private func saveUsername(_ name: String) {
        print("Saving username...")
        let encoder = JSONEncoder()
        do {
            guard let jsonData = try? encoder.encode(name) else {
                print("Failed to create data from username.")
                return
            }
            print(String(data: jsonData, encoding: .utf8)!)
            let fileURL = documentsURL.appendingPathComponent(userFileName)
            try jsonData.write(to: fileURL, options: .completeFileProtection)
            print("username saved successfully.")
        } catch {
            print("Could not save username to file.")
        }
    }
    
    private func getUsername() -> String? {
        print("Fetching username...")
        let fileUrl = documentsURL.appendingPathComponent(userFileName)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                let data = try Data(contentsOf: fileUrl)
                let username = try JSONDecoder().decode(String.self, from: data)
                print("Successfully fetched username.")
                return username
            } catch {
                print("Failed to fetch username.")
                return nil
            }
        }
        return nil
    }
}
