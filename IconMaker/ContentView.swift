//
//  ContentView.swift
//  IconMaker
//
//  Created by main on 2023/10/01.
//

import SwiftUI
import Photos

struct ContentView: View {
    var iconName = "pencil.and.outline"
    var iconColor = Color.orange.gradient
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Spacer()
            AppIconView(systemName: iconName, color: iconColor)
                .frame(width: 300, height: 300)
            Text(iconName)
            Spacer()
            Button("Save Image") {
                saveToPhotos()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveToPhotos() {
        DispatchQueue.main.async {
            let viewSize = CGSize(width: 1024, height: 1024)
            
            let hostingController = UIHostingController(
                rootView: AppIconView(systemName: iconName, color: iconColor)
                    .frame(width: viewSize.width, height: viewSize.height)
                    .offset(CGSize(width: 0, height: -12))
                    .background(iconColor)
            )
            
            hostingController.view.frame = CGRect(origin: .zero, size: viewSize)
            hostingController.view.backgroundColor = .clear
            
            let image = hostingController.snapshot(viewSize: viewSize)
            
            // PNGとしてカメラロールに保存
            if let data = image.pngData() {
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: data, options: nil)
                }) { success, error in
                    if let error = error {
                        alertMessage = "Error saving the image: \(error)"
                        showAlert = true
                    } else {
                        alertMessage = "Success saving image"
                        showAlert = true
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func snapshot(viewSize: CGSize) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: viewSize, format: rendererFormat)
        
        let image = renderer.image { _ in
            let context = UIGraphicsGetCurrentContext()!
            context.interpolationQuality = .high
            view.drawHierarchy(in: CGRect(origin: .zero, size: viewSize), afterScreenUpdates: true)
        }
        
        return image
    }
}

#Preview {
    ContentView()
}

