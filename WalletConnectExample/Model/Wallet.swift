//
//  Wallet.swift
//  WalletConnectExample
//
//  Created by Lev Baklanov on 12.06.2022.
//

import Foundation
import UIKit
import WalletConnectSwift

struct Wallet: Hashable {
    let name: String
    let mainUrl: String
    let appStoreLink: String
    let universalScheme: String
    let nativeScheme: String
    let linkForOpenOnly: String
    
    func formWcDeepLink(connectionUrl: String) -> String {
        formEmptyDeepLink() + "wc?uri=\(connectionUrl)"
    }
    
    func formEmptyDeepLink() -> String {
        if !universalScheme.isEmpty {
            return "\(universalScheme)/"
        } else {
            return "\(nativeScheme)://"
        }
    }
    
    func formLinkForOpen() -> String {
        return linkForOpenOnly.isEmpty ? formEmptyDeepLink() : linkForOpenOnly
    }
}

struct Wallets {

    static let TrustWallet = Wallet(
        name: "Trust Wallet",
        mainUrl: "https://trustwallet.com",
        appStoreLink: "https://apps.apple.com/app/apple-store/id1288339409",
        universalScheme: "https://link.trustwallet.com",
        nativeScheme: "trust",
        linkForOpenOnly: "https://link.trustwallet.com/open_coin?asset=c966"
    )

    static let Metamask = Wallet(
        name: "MetaMask",
        mainUrl: "https://metamask.io",
        appStoreLink: "https://apps.apple.com/app/metamask/id1438144202",
        universalScheme: "https://metamask.app.link",
        nativeScheme: "metamask",
        linkForOpenOnly: ""
    )
    
    static let All = [TrustWallet, Metamask]
    
    static func available() -> [Wallet] {
        var res: [Wallet] = []
        for wallet in All {
            let nativeLink = "\(wallet.nativeScheme)://"
            if let url = URL(string: nativeLink), UIApplication.shared.canOpenURL(url) {
                res.append(wallet)
            }
        }
        return res
    }
    
    static func bySession(session: Session?) -> Wallet? {
        guard let session = session else { return nil }
        let name = session.walletInfo?.peerMeta.name
        let url = session.walletInfo?.peerMeta.url
        if let name = name, let wallet = All.first(where: { $0.name == name }) {
            return wallet
        }
        if let url = url?.absoluteString, let wallet = All.first(where: { $0.mainUrl == url } ) {
            return wallet
        }
        return nil
    }
}
