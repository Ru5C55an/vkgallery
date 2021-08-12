//
//  AuthVC.swift
//  vkgallery
//
//  Created by Руслан Садыков on 09.08.2021.
//

import UIKit

final class AuthVC: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let titleLabelText = "Mobile Up\nGallery"
        static let titleLabelFont: UIFont? = .sfProDisplay(ofSize: 48, weight: .bold)
        static let titleLabelColor: UIColor = .primaryColor
        
        static let authBtnTitle = NSLocalizedString(LocalizedStringKeys.kAuthTitle, comment: "Вход через VK")
        static let authBtnFont: UIFont? = .sfProDisplay(ofSize: 18, weight: .medium)
        static let authBtnBgColor: UIColor = .primaryColor
        static let authBtnTitleColor: UIColor = .btnTitleColor
        static let authBtnHeight: CGFloat = 56
        static let authBtnCornerRadius: CGFloat = 8
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleLabelFont
        label.text = Constants.titleLabelText
        label.textColor = Constants.titleLabelColor
        label.numberOfLines = 0
        return label
    }()
    
    private let authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.authBtnTitle, for: UIControl.State())
        button.titleLabel?.font = Constants.authBtnFont
        button.backgroundColor = Constants.authBtnBgColor
        button.setTitleColor(Constants.authBtnTitleColor, for: UIControl.State())
        button.layer.cornerRadius = Constants.authBtnCornerRadius
        button.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private let authService = AuthService.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrsints()
    }
    
    // MARK: - Setup views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(authButton)
        view.addSubview(titleLabel)
    }
    
    // MARK: - Setup constraints
    private func setupConstrsints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(117)
            make.left.right.equalToSuperview().inset(24)
        }
        
        authButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(Constants.authBtnHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    // MARK: - Handlers
    @objc private func authAction() {
        authService.wakeUpSession()
    }
}
