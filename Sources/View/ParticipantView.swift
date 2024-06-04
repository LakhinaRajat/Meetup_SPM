import SwiftUI
import LiveKit
import SFSafeSymbols



public struct ParticipantView: View {
    
    @ObservedObject public var participant: Participant
    @State var appCtx: AppContext = GlobalConfig.appCtx
    
    public var isForceCamera: Bool = false
    var onTap: ((_ participant: Participant) -> Void)?
    
    @State private var isRendering: Bool = false
    @State private var dimensions: Dimensions?
    @State private var videoTrackStats: TrackStats?

    func bgView(systemSymbol: SFSymbol, geometry: GeometryProxy) -> some View {
        Image(systemSymbol: systemSymbol)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.lkGray2)
            .frame(width: min(geometry.size.width, geometry.size.height) * 0.3)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
    }
    
    func bgNameView(imageURL: String, geometry: GeometryProxy) -> some View {
        
        NetworkImage(url: URL(string: imageURL), showName: true, participantName: (participant as? RemoteParticipant != nil) ? participant.name : GlobalConfig.localPartcipantName)
            .frame(maxWidth : geometry.size.width/2.5, maxHeight: geometry.size.width/2.5, alignment: .center)
            .cornerRadius(geometry.size.width/5)
            .padding()
    }
    
    public var body: some View {
        GeometryReader { geometry in

            ZStack(alignment: .center) {
                
                // Background color of local and remote participant
//                participant as? RemoteParticipant != nil ? Color.lkGray1 :((participant.isScreenShareEnabled() == true && isForceCamera == false) ? Color.lkGray2 : Color.lkGray3)
                Color.lkGray1

                // VideoView for the Participant
                if let publication = isForceCamera ? participant.subVideoPublication : participant.mainVideoPublication,
                   !publication.muted,
                   let track = publication.track as? VideoTrack,
                   appCtx.videoViewVisible {
                    ZStack(alignment: .topLeading) {
                        SwiftUIVideoView(track,
                                         layoutMode: participant as? RemoteParticipant != nil ? .fit : .fill,
                                         mirrorMode: appCtx.videoViewMirrored ? .mirror : .auto,
                                         debugMode: appCtx.showInformationOverlay,
                                         isRendering: $isRendering,
                                         dimensions: $dimensions,
                                         trackStats: $videoTrackStats)
                                            
                        if !isRendering, participant.mainVideoPublication?.source != .screenShareVideo {
//                            ProgressView().progressViewStyle(CircularProgressViewStyle())
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    }
                } else if let publication = participant.mainVideoPublication as? RemoteTrackPublication,
                          case .notAllowed = publication.subscriptionState {
                    // Show no permission icon
                    bgView(systemSymbol: .exclamationmarkCircle, geometry: geometry)
                } else {
                    
                    // Show no camera icon
                    let image = ImageURL.getUserImage(name: (participant as? RemoteParticipant != nil) ? participant.identity : GlobalConfig.localPartcipantUsername, env: GlobalConfig.environment == .dev ? .dev : GlobalConfig.environment == .staging ? .staging : .prod)
                    bgNameView(imageURL: image ,geometry: geometry)
                }

                // Bottom user info bar
                if (participant as? RemoteParticipant != nil) {
                    VStack {
                        Spacer()
                        HStack {
                            HStack {
                                Text("\(participant.name)") //  (\(participant.publish ?? "-"))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .scaledToFill()
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .font(.custom("WorkSans-Regular", size: (geometry.size.width * 0.13 > 17 ? 17 : geometry.size.width * 0.13)))

                                if let publication = participant.firstAudioPublication,
                                   !publication.muted {
                                    // is remote
                                    if let remotePub = publication as? RemoteTrackPublication {
                                        Menu {
                                            if case .subscribed = remotePub.subscriptionState {
                                                Button {
                                                    remotePub.set(subscribed: false)
                                                } label: {
                                                    Text("Unsubscribe")
                                                }
                                            } else if case .unsubscribed = remotePub.subscriptionState {
                                                Button {
                                                    remotePub.set(subscribed: true)
                                                } label: {
                                                    Text("Subscribe")
                                                }
                                            }
                                        } label: {
                                            if case .subscribed = remotePub.subscriptionState {
                                                Image(systemSymbol: .micFill)
                                                    .foregroundColor(Color.white)
                                                    .font(.system(size: geometry.size.width * 0.12 > 17 ? 17 : geometry.size.width * 0.12))
                                            } else if case .notAllowed = remotePub.subscriptionState {
                                                Image(systemSymbol: .exclamationmarkCircle)
                                                    .foregroundColor(Color.red)
                                                    .font(.system(size: geometry.size.width * 0.12 > 17 ? 17 : geometry.size.width * 0.12))
                                            } else {
                                                Image(systemSymbol: .micSlashFill)
                                                    .foregroundColor(Color.white)
                                                    .font(.system(size: geometry.size.width * 0.12 > 17 ? 17 : geometry.size.width * 0.12))
                                            }
                                        }
                                        .menuStyle(BorderlessButtonMenuStyle())
                                        .fixedSize()
                                    } else {
                                        // local
                                        Image(systemSymbol: .micFill)
                                            .foregroundColor(Color.white)
                                            .font(.system(size: geometry.size.width * 0.12 > 17 ? 17 : geometry.size.width * 0.12))
                                    }

                                } else {
                                    Image(systemSymbol: .micSlashFill)
                                        .foregroundColor(Color.white)
                                        .font(.system(size: geometry.size.width * 0.12 > 17 ? 17 : geometry.size.width * 0.12))
                                }

                            }.padding(8)
                                .frame(alignment: .leading)
                                .frame(maxHeight: geometry.size.width * 0.17 > 30 ? 30 : geometry.size.width * 0.18)
                                .background(participant.isSpeaking ?
                                            Color(red: 0.400, green: 0.725, blue: 0.518) :
                                                Color.black.opacity(0.6))
                                .cornerRadius(20)
                            HStack {
                                Spacer()
                                    .background(Color.clear)
                            }
                        } .padding(5)
                            .frame(alignment: .leading)
                    }
                }
            }
            .cornerRadius(participant as? RemoteParticipant != nil ? 5 : 0)
            // Glow the border when the participant is speaking
            .overlay(
                participant.isSpeaking && participant as? RemoteParticipant != nil ?
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(red: 0.400, green: 0.725, blue: 0.518), lineWidth: 1.0)
                : RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.lkGray3, lineWidth: 1.0)
            )
        }

//        .overlay(
//            participant as? RemoteParticipant != nil ?
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(Color(red: 0.439, green: 0.439, blue: 0.439), lineWidth: 1.0)
//            : RoundedRectangle(cornerRadius: 5)
//                .stroke(Color.clear, lineWidth: 1.0)
//
//        )
        
        .navigationBarHidden(true)
    }
}
