//
//  ContentView.swift
//  WalletConnectExample
//
//  Created by Lev Baklanov on 12.06.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject
    var viewModel = ExampleViewModel()
    
    var body: some View {
        MainContainer()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.initWalletConnect()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
