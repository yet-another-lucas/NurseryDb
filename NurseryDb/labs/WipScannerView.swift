//
//  WipScanner.swift
//  NurseryDb
//
//  Created by lucas schwarz on 2/23/25.
//

import Foundation

import SwiftUI
import CodeScanner

struct WipScannerView: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world3!")
            
            if let scannedCode = scannedCode {
                Text("Scanned QR Code: \(scannedCode)")
                    .padding()
                    .foregroundColor(.green)
            }
            
            Button(action: {
                isShowingScanner = true
            }) {
                Text("Scan QR Code")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "https://example.com") { response in
                switch response {
                case .success(let result):
                    scannedCode = result.string
                    isShowingScanner = false
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
