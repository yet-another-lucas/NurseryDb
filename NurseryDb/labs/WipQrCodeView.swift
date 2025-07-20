import SwiftUI

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

// works when I scan the ugly qr codes with my phone
// but it converts everything to ascii right now, but
// later will need json or something
struct WipQrCodeView: View {
    @State private var qrCodeImage: UIImage?
    @State private var inputText: String = "hello world"
    
    var body: some View {
        VStack {
            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("No QR Code Generated")
                    .foregroundColor(.gray)
            }
            
            TextField("Enter text for QR Code", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: generateQRCode) {
                Text("Generate QR Code")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if qrCodeImage != nil {
                Button(action: printQRCode) {
                    Text("Print QR Code")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    private func generateQRCode() {
        let data = inputText.data(using: .ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                qrCodeImage = UIImage(cgImage: cgImage)
            }
        }
    }
    //one
    private func printQRCode() {
        guard let qrCodeImage = qrCodeImage else { return }
        
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = "QR Code Print"
        printController.printInfo = printInfo
        
        printController.printingItem = qrCodeImage
        
        printController.present(animated: true, completionHandler: nil)
    }
}
