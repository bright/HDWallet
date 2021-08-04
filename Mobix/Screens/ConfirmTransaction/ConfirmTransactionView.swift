
import UIKit

struct ConfirmTransactionViewModel {
    var title: String
    let image: UIImage?
    let amount: String
    let token: String
    let description: String?
    let bottomButtonText: String
}

class ConfirmTransactionView: UIView {
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    let slider = MTSlideToOpenView(frame: CGRect(x: 26, y: 400, width: 317, height: 56))
    let doneButton = DefaultButton(color: Colors.buttonsColor1)
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        addSubviews()
        applyConstraints()
        setUpSlider()
        setUpLabels()
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(slider)
    }
    
    private func applyConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(amountLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        slider.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalToSuperview().inset(60)
        }

    }
    
    private func configureCommon(with viewModel: ConfirmTransactionViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        amountLabel.text = viewModel.amount
        descriptionLabel.text = viewModel.description
    }
    
    func configureToConfirm(with viewModel: ConfirmTransactionViewModel) {
        configureCommon(with: viewModel)
    }
    
    func configureConfirmed(with viewModel: ConfirmTransactionViewModel) {
        configureCommon(with: viewModel)
        doneButton.setTitle("done".localized, for: .normal)
        addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalToSuperview().inset(70)
        }
        slider.removeFromSuperview()
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
        slider.sliderTextLabel.font = Fonts.barlowRegular.withSize(18)
        slider.textLabel.font = Fonts.barlowRegular.withSize(18)
        slider.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        slider.layer.shadowColor = UIColor.black.cgColor
        slider.layer.shadowOpacity = 0.2
        slider.layer.shadowOffset = CGSize(width: 2, height: 2)
        slider.layer.shadowRadius = 1
    }
    
    private func setUpLabels() {
        descriptionLabel.textColor = Colors.textMain
        descriptionLabel.numberOfLines = 0
        amountLabel.font = Fonts.barlowBold.withSize(40)
        titleLabel.font = Fonts.barlowBold.withSize(40)
        descriptionLabel.font = Fonts.barlowRegular.withSize(18)
        descriptionLabel.textAlignment = .center
        titleLabel.textColor = Colors.textMain
        amountLabel.textColor = Colors.textMain
        amountLabel.textAlignment = .center
    }
}

