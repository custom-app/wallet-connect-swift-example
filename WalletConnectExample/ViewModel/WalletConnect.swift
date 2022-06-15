//
//  WalletConnect.swift
//  WalletConnectExample
//
//  Created by Lev Baklanov on 12.06.2022.
//

import Foundation
import WalletConnectSwift

class WalletConnect {
    
    static let sessionKey = "session_key"
    
    var client: Client!
    var session: Session!
    var delegate: WalletConnectDelegate
 
    init(delegate: WalletConnectDelegate) {
        self.delegate = delegate
    }

    func connect() -> String {
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://safe-walletconnect.gnosis.io/")!,
                           key: randomKey())
        let clientMeta = Session.ClientMeta(name: "Test app",
                                            description: "Wallet connect test app",
                                            icons: [],
                                            url: URL(string: "https://medium.com")!)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString,
                                        peerMeta: clientMeta,
                                        chainId: 137) // Polygon chain
        client = Client(delegate: self, dAppInfo: dAppInfo)
        try! client.connect(to: wcUrl)
        return wcUrl.fullyPercentEncodedStr
    }

    func reconnectIfNeeded() {
        if let sessionObject = UserDefaults.standard.object(forKey: WalletConnect.sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: sessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }
    
    func haveOldSession() -> Bool {
        if let sessionObject = UserDefaults.standard.object(forKey: WalletConnect.sessionKey) as? Data,
           let _ = try? JSONDecoder().decode(Session.self, from: sessionObject) {
            return true
        }
        return false
    }

    private func randomKey() -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            return ""
        }
    }
}

protocol WalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didUpdate(session: Session)
    func didDisconnect(isReconnecting: Bool)
    func didSubscribe(url: WCURL)
}

extension WalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        print("failed to connect")
        delegate.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        print("did connect (url)")
    }
    
    func client(_ client: Client, didSubscribe url: WCURL) {
        print("did subscribe after new connection")
        delegate.didSubscribe(url: url)
    }

    func client(_ client: Client, didConnect session: Session) {
        print("did connect")
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: WalletConnect.sessionKey)
        delegate.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session, isReconnecting: Bool) {
        print("did disconnect, reconnecting: \(isReconnecting)")
        if !isReconnecting {
            UserDefaults.standard.removeObject(forKey: WalletConnect.sessionKey)
        }
        delegate.didDisconnect(isReconnecting: isReconnecting)
    }

    func client(_ client: Client, didUpdate session: Session) {
        print("did update")
        delegate.didUpdate(session: session)
    }
}
