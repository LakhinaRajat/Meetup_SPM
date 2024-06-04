//
//  File.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 29/07/23.
//

import Foundation
import Combine
import SwiftUI

public struct NetworkImage: View {
    @StateObject private var viewModel = ViewModel()
    
    var url: URL? = nil
    var showName: Bool? = nil
    var participantName: String = ""
    
    init(url: URL? = nil, showName: Bool? = nil, participantName: String = "") {
        self.url = url
        self.showName = showName
        self.participantName = participantName
    }

    public var body: some View {
        Group {
            if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if viewModel.isLoading {
                // ProgressView()
            } else {
                
                if(showName ?? false){
                    InitialsUI(text: .constant(participantName),randomBackground: false)
                        .aspectRatio(1, contentMode: .fill)
                } else {
                    Image(systemName: "photo")
                }
            }
        }
        .onAppear {
            viewModel.imageData = nil
            viewModel.loadImage(from: url)
        }
        .onChange(of: url) { newURL in
            // Reset imageData when the URL changes
            viewModel.imageData = nil
            viewModel.loadImage(from: newURL)
        }
    }
}

public extension NetworkImage {
    class ViewModel: ObservableObject {
        @Published var imageData: Data?
        @Published var isLoading = false
        
        private static let cache = NSCache<NSURL, NSData>()
        
        private var cancellables = Set<AnyCancellable>()
        
        func loadImage(from url: URL?) {
            isLoading = true
            guard let url = url else {
                isLoading = false
                return
            }
            
            var tURL = url.absoluteString
            if tURL.hasSuffix("/")
            {
                tURL = String(tURL.dropLast())
                tURL = tURL + ".jpg"
            }
            
            if let newURL = URL(string: tURL), let data = Self.cache.object(forKey: newURL as NSURL) {
                imageData = data as Data
                isLoading = false
                return
            }
            
            var request = URLRequest(url: url)
            if !GlobalConfig.accessToken.isEmpty {
                request.addValue("Bearer \(GlobalConfig.accessToken)", forHTTPHeaderField: "Authorization")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                URLSession.shared.dataTaskPublisher(for: request)
                    .map { $0.data }
                    .replaceError(with: nil)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in
                        if let data = $0 {
                            var tURL = url.absoluteString
                            if tURL.hasSuffix("/")
                            {
                                tURL = String(tURL.dropLast())
                                tURL = tURL + ".jpg"
                            }
                            
                            if let newURL = URL(string: tURL) {
                                Self.cache.setObject(data as NSData, forKey: newURL as NSURL)
                            }
                            
                            self?.imageData = data
                        }
                        self?.isLoading = false
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
}
