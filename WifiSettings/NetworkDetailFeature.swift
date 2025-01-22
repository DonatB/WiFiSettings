//
//  NetworkDetailFeature.swift
//  WifiSettings
//
//  Created by Ptera on 1/20/25.
//

import Foundation
import Observation
import UIKit
import UIKitNavigation

@MainActor
@Perceptible
class NetworkDetailModel {
    var forgetAlertIsPresented = false
    let onConfirmForget: () -> Void
    let network: Network
    
    init(network: Network, onConfirmForget: @escaping () -> Void) {
        self.network = network
        self.onConfirmForget = onConfirmForget
    }
    
    func forgetNetworkButtonTapped() {
        forgetAlertIsPresented = true
    }
    
    func confirmForgetNetworkButtonTapped() {
        onConfirmForget()
    }
}

final class NetworkDetailsViewController: UIViewController {
    @UIBindable var model: NetworkDetailModel
    
    init(model: NetworkDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = model.network.name
        
        let forgetButton = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            print("Tapperooski")
            model.forgetNetworkButtonTapped()
        })
        forgetButton.setTitle("Forget network", for: .normal)
        forgetButton.setTitleColor(.systemMint, for: .normal)
        forgetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forgetButton)
        NSLayoutConstraint.activate([
            forgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        present(
            isPresented: $model.forgetAlertIsPresented,
            content: { [model] in
                let controller = UIAlertController(
                    title: "Forget Wi-Fi Network \(model.network.name)",
                    message: """
                    Your iPhone and other devices using iCloud keychain will no longer join the Wi-Fi network
                    """,
                    preferredStyle: .alert
                )
                controller.addAction(
                    UIAlertAction(
                        title: "Cancel",
                        style: .cancel
                    )
                )
                controller
                    .addAction(
                        UIAlertAction(
                            title: "Forget",
                            style: .destructive,
                            handler: { _ in
                                model.confirmForgetNetworkButtonTapped()
                            }
                        )
                    )
                return controller
            }
        )
    }
}

import SwiftUI
#Preview{
    UIViewControllerRepresenting {
        UINavigationController(
            rootViewController: NetworkDetailsViewController(
                model: NetworkDetailModel(
                    network: Network(name: "Blob's WiFi"),
                    onConfirmForget: {}
                )
            )
        )
    }
}
