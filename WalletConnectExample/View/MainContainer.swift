//
//  MainContainer.swift
//  WalletConnectExample
//
//  Created by Lev Baklanov on 12.06.2022.
//

import SwiftUI

struct MainContainer: View {
    
    @EnvironmentObject
    var viewModel: ExampleViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.session == nil {
                Text("Connect to:")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                
                Button {
                    viewModel.connect(wallet: Wallets.TrustWallet)
                } label: {
                    HStack {
                        Spacer()
                        Text(Wallets.TrustWallet.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(32)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 24)
                
                Button {
                    viewModel.connect(wallet: Wallets.Metamask)
                } label: {
                    HStack {
                        Spacer()
                        Text(Wallets.Metamask.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(32)
                }
                .padding(.horizontal, 30)
            } else {
                
                Text("Connected to \(viewModel.walletName)")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                
                Text("Address: \(viewModel.walletAccount ?? "")")
                    .font(.system(size: 13))
                    .fontWeight(.regular)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                if viewModel.isWrongChain {
                    Text("Connected to wrong chain. Please connect to Polygon")
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.top, 30)
                } else {
                    Button {
                        viewModel.sendTx(to: "0x89e7d8Fe0140523EcfD1DDc4F511849429ecB1c2")
                    } label: {
                        HStack {
                            Spacer()
                            Text("Send tx")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(32)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                }
                
                Button {
                    viewModel.disconnect()
                } label: {
                    HStack {
                        Spacer()
                        Text("Disconnect")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .background(Color.red)
                    .cornerRadius(32)
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
            }
        }
    }
}
