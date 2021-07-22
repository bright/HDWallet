
import UIKit

class Passcode: UIView, UITextInputTraits {
    var keyboardType: UIKeyboardType = .numberPad

    var didFinishedEnterCode:((String)-> Void)?
    
    var code: String = "" {
        didSet {
            updateStack(by: code)
            if code.count == maxLength, let didFinishedEnterCode = didFinishedEnterCode {
                self.resignFirstResponder()
                didFinishedEnterCode(code)
            }
        }
    }
    var maxLength = 6
    
    //MARK: - UI
    let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        showKeyboardIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Passcode {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    private func showKeyboardIfNeeded() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    @objc private func showKeyboard() {
        self.becomeFirstResponder()
    }
}


extension Passcode: UIKeyInput {
    var hasText: Bool {
        return code.count > 0
    }
    func insertText(_ text: String) {
        if code.count == maxLength {
            return
        }
        code.append(contentsOf: text)
    }
    
    func deleteBackward() {
        if hasText {
            code.removeLast()
        }
    }
    
}

extension Passcode {
    private func setupUI() {
        addSubview(stack)
        self.backgroundColor = .clear
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        updateStack(by: code)
    }
    
    private func emptyPin() -> UIView {
        let pin = Pin()
        pin.pin.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return pin
    }
    
    private func pin() -> UIView {
        let pin = Pin()
        pin.pin.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        return pin
    }
    
    private func updateStack(by code: String) {
        var emptyPins:[UIView] = Array(0..<maxLength).map{_ in emptyPin()}
        let userPinLength = code.count
        let pins:[UIView] = Array(0..<userPinLength).map{_ in pin()}
        
        for (index, element) in pins.enumerated() {
            emptyPins[index] = element
        }
        stack.removeAllArrangedSubviews()
        for view in emptyPins {
            stack.addArrangedSubview(view)
        }
        layoutIfNeeded()
    }

}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
