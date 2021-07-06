
import UIKit

struct ConfirmTransactionViewModel {
    let image: UIImage?
    let amount: String
    let token: String
    let description: String?
    let transactionCostDescription: String?
    let bottomButtonText: String
}

class ConfirmTransactionView: UIView {
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let currencyLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let ethSymbol = UIImageView(image: UIImage(named: "Ethereum"))
    private let costLabel = UILabel()
    lazy var ethCostStack = UIStackView(arrangedSubviews: [ethSymbol, costLabel])
    let slider = MTSlideToOpenView(frame: CGRect(x: 26, y: 400, width: 317, height: 56))
    let bottomButton = UIButton()
    let doneButton = DefaultButton(color: Colors.buttonsColor1)
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        addSubviews()
        applyConstraints()
        setUpSlider()
        setUpLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(currencyLabel)
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(ethCostStack)
        addSubview(slider)
        addSubview(bottomButton)
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        currencyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(amountLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(currencyLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        ethCostStack.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(descriptionLabel)
        }
        slider.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(ethCostStack.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalTo(bottomButton.snp.top).offset(-10)
        }
        bottomButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func configureCommon(with viewModel: ConfirmTransactionViewModel) {
        imageView.image = viewModel.image
        amountLabel.text = viewModel.amount
        currencyLabel.text = viewModel.token
        descriptionLabel.text = viewModel.description
        let bottomButtonText = NSAttributedString(string: viewModel.bottomButtonText, attributes: [.foregroundColor : Colors.buttonsTextColor, .underlineStyle: NSUnderlineStyle.single.rawValue, .font: Fonts.robotoCondensedBold.withSize(18)])
        bottomButton.setAttributedTitle(bottomButtonText, for: UIControl.State.normal)
    }
    
    func configureToConfirm(with viewModel: ConfirmTransactionViewModel) {
        configureCommon(with: viewModel)
        costLabel.text = viewModel.transactionCostDescription
    }
    
    func configureConfirmed(with viewModel: ConfirmTransactionViewModel) {
        configureCommon(with: viewModel)
        doneButton.setTitle("done".localized, for: .normal)
        addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalTo(bottomButton.snp.top).offset(-10)
        }
        slider.removeFromSuperview()
        ethCostStack.isHidden = true
    }
    
    private func setUpSlider() {
        slider.sliderViewTopDistance = 0
        slider.sliderCornerRadius = 24
        slider.thumbnailViewStartingDistance = 2
        slider.thumbnailColor = .white
        slider.sliderBackgroundColor = .white
        slider.backgroundColor = .clear
        slider.thumbnailViewTopDistance = 2
        slider.thumbnailViewTrailingDistance = 2
        slider.slidingColor = Colors.slidingColor
        slider.labelText = "swipe_to_confirm".localized
        slider.sliderTextLabel.font = Fonts.robotoCondensedRegular.withSize(18)
        slider.textLabel.font = Fonts.robotoCondensedRegular.withSize(18)
        slider.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        slider.layer.shadowColor = UIColor.black.cgColor
        slider.layer.shadowOpacity = 0.2
        slider.layer.shadowOffset = CGSize(width: 2, height: 2)
        slider.layer.shadowRadius = 1
    }
    
    private func setUpLabels() {
        titleLabel.text = "confirm_to_send".localized
        descriptionLabel.textColor = Colors.secondaryBackgroundText
        descriptionLabel.numberOfLines = 0
        amountLabel.font = Fonts.quicksandMedium.withSize(40)
        currencyLabel.font = Fonts.robotoCondensedRegular.withSize(14)
        titleLabel.font = Fonts.quicksandRegular.withSize(22)
        descriptionLabel.font = Fonts.robotoCondensedRegular.withSize(18)
        descriptionLabel.textAlignment = .center
        titleLabel.textColor = Colors.secondaryBackgroundText
        amountLabel.textColor = Colors.secondaryBackgroundText
        currencyLabel.textColor = Colors.secondaryBackgroundText
        costLabel.font = Fonts.robotoCondensedBold.withSize(18)
        ethCostStack.spacing = 10
        ethSymbol.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        costLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        costLabel.minimumScaleFactor = 0.7
        costLabel.adjustsFontSizeToFitWidth = true
    }
}

