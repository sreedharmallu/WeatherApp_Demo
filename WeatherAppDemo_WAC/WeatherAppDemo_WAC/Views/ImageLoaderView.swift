//
//  ImageLoaderView.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//

import SwiftUI
import Combine

struct ImageLoaderView: View {
    let url: URL
    @State private var image: UIImage?
    @State private var isSuccessfull: Bool?
    @State private var cancellabels: Set<AnyCancellable> = .init()
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "hourglass")
                    .resizable()
                    .scaledToFit()
            }
        }.onAppear {
            if image == nil  {
                ImageLoader.shared.loadImage(from: url)
                    .sink(receiveValue: { image in
                        self.image = image
                    })
                    .store(in: &cancellabels)
            }
        }
    }
}
