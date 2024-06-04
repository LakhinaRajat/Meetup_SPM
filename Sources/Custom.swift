import SwiftUI
import SwiftUI
import LiveKit
import AVFoundation
import WebRTC
import CoreImage.CIFilterBuiltins
import ReplayKit


struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

// Default button style for this example
struct LKButton: View {

    let title: String
    let action: () -> Void

    var body: some View {

        Button(action: action,
               label: {
                Text(title.uppercased())
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
               }
        )
        .background(Color.lkRed)
        .cornerRadius(8)
    }
}

#if os(iOS)
extension LKTextField.`Type` {
    func toiOSType() -> UIKeyboardType {
        switch self {
        case .default: return .default
        case .URL: return .URL
        case .ascii: return .asciiCapable
        }
    }
}
#endif

struct LKTextField: View {

    enum `Type` {
        case `default`
        case URL
        case ascii
    }

    let title: String
    @Binding var text: String
    var type: Type = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(title)
                .fontWeight(.bold)

            TextField("", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                // TODO: add iOS unique view modifiers
                // #if os(iOS)
                // .autocapitalization(.none)
                // .keyboardType(type.toiOSType())
                // #endif
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(Color.white.opacity(0.3),
                                          style: StrokeStyle(lineWidth: 1.0)))

        }.frame(maxWidth: .infinity)
    }
}


extension Participant {

    public var subVideoPublication: TrackPublication? {
        firstCameraPublication
    }

    public var mainVideoPublication: TrackPublication? {
        firstScreenSharePublication ?? firstCameraPublication
    }

    public var mainVideoTrack: VideoTrack? {
        firstScreenShareVideoTrack ?? firstCameraVideoTrack
    }
  
    public var subVideoTrack: VideoTrack? {
        firstScreenShareVideoTrack != nil ? firstCameraVideoTrack : nil
    }

    public func participant(_ participant: Participant, didUpdate permissions: ParticipantPermissions) {
        print("participant: \(participant), permissions: \(permissions)")
    }
}

public struct ExampleRoomMessage: Identifiable, Equatable, Hashable, Codable {
    // Identifiable protocol needs param named id
    public var id: String {
        messageId
    }

    // message id
    public let messageId: String

    public let senderSid: String
    public let senderIdentity: String
    public let text: String

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.messageId == rhs.messageId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
}


public struct WaitingRoomParticipant: Identifiable {
    public let id: String = "\(UUID())"
    public let participant: Participant
    public let isAllowed: Bool
}

public struct ExampleRoomMessageNew: Identifiable, Equatable, Hashable, Codable {
    // Identifiable protocol needs param named id
    public var id: String {
        messageId
    }
    
    public let messageId: String = UUID().uuidString
    public let text: String
    public let senderSid: String?
    public let senderIdentity: String?
    public let type: String?
    public let createdAt: Int?
    public let byUser: ByUser?

    
    enum CodingKeys: String, CodingKey {
        case text = "message"
        case senderSid
        case senderIdentity
        case type
        case createdAt = "created_at"
        case byUser = "by"
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.messageId == rhs.messageId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
}


// MARK: - By
public struct ByUser: Codable {
    
    public let name: String?
    public let username: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case username = "username"
    }
}

