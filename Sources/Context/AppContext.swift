import SwiftUI
import LiveKit
import WebRTC
import Combine

extension ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    func notify() {
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
}

// This class contains the logic to control behavior of the whole app.
public class AppContext: ObservableObject {

    private let store: ValueStore<Preferences>

    @Published var videoViewVisible: Bool = true {
        didSet { store.value.videoViewVisible = videoViewVisible }
    }

    @Published var showInformationOverlay: Bool = false {
        didSet { store.value.showInformationOverlay = showInformationOverlay }
    }

    @Published var preferMetal: Bool = true {
        didSet { store.value.preferMetal = preferMetal }
    }

    @Published var videoViewMode: VideoView.LayoutMode = .fit {
        didSet { store.value.videoViewMode = videoViewMode }
    }

    @Published var videoViewMirrored: Bool = false {
        didSet { store.value.videoViewMirrored = videoViewMirrored }
    }

    @Published var outputDevice: RTCIODevice = RTCIODevice.defaultDevice(with: .output) {
        didSet {
            print("didSet outputDevice: \(String(describing: outputDevice))")
            //Room.audioDeviceModule.outputDevice = outputDevice
        }
    }

    @Published var inputDevice: RTCIODevice = RTCIODevice.defaultDevice(with: .input) {
        didSet {
            print("didSet inputDevice: \(String(describing: inputDevice))")
            //Room.audioDeviceModule.inputDevice = inputDevice
        }
    }


    @Published var preferSpeakerOutput: Bool = true {
        didSet { AudioManager.shared.preferSpeakerOutput = preferSpeakerOutput }
    }

    public init(store: ValueStore<Preferences>) {
        self.store = store

        self.videoViewVisible = store.value.videoViewVisible
        self.showInformationOverlay = store.value.showInformationOverlay
        self.preferMetal = store.value.preferMetal
        self.videoViewMode = store.value.videoViewMode
        self.videoViewMirrored = store.value.videoViewMirrored

//        Room.audioDeviceModule.setDevicesUpdatedHandler {
//            print("devices did update")
//            // force UI update for outputDevice / inputDevice
//            DispatchQueue.main.async {
//
//                // set to default device if selected device is removed
//                if !Room.audioDeviceModule.outputDevices.contains(where: { self.outputDevice == $0 }) {
//                    self.outputDevice = RTCAudioDevice.defaultDevice(with: .output)
//                }
//
//                // set to default device if selected device is removed
//                if !Room.audioDeviceModule.inputDevices.contains(where: { self.inputDevice == $0 }) {
//                    self.inputDevice = RTCAudioDevice.defaultDevice(with: .input)
//                }
//
//                self.objectWillChange.send()
//            }
//        }
    }
    
    public func remove(){
        store.remove()
    }
}
