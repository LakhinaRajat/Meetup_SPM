
import SwiftUI
import LiveKit
import SFSafeSymbols
import WebRTC
import Logging

let adaptiveMin = 170.0
let toolbarPlacement: ToolbarItemPlacement = .bottomBar


extension CIImage {
    // helper to create a `CIImage` for both platforms
    convenience init(named name: String) {
        self.init(cgImage: UIImage(named: name)!.cgImage!)
        
    }
}

extension RTCIODevice: Identifiable {
    
    public var id: String {
        deviceId
    }
}

public typealias V = View

public protocol RoomViewDelegates {
    func enableVideoClicked()
    func enableAudioClicked()
    func switchCameraClicked()
    func startShareScreenClicked()
    func stopShareScreenClicked()
    func enableSpeakerClicked()
    func disableSpeakerClicked()
    func disconnetRoomClicked()
}

public extension Notification.Name {
    static let uIKitToSwiftUI = Notification.Name("UIKitToSwiftUI")
    static let getRoomViewObject = Notification.Name("GetRoomViewObject")
    static let getRoomObject = Notification.Name("GetRoomObject")
    static let updateRoomObject = Notification.Name("UpdateRoomObject")
    static let getMessages = Notification.Name("GetMessages")
    static let disconnectRoom = Notification.Name("DisconnectRoom")
    static let localParticipant = Notification.Name("LocalParticipant")
}


public struct RoomView: View {
    
    @EnvironmentObject var appCtx: AppContext
    @EnvironmentObject public var roomCtx: RoomContext
    @EnvironmentObject var room: Room
    
    @State public var isHiddenTools = true
    @State private var screenPickerPresented = false
    @State private var showConnectionTime = false
    
    let maxGridCount = UIScreen.main.bounds.size.width < 400 ? 4 : 6
    
    public init() {
        
        if(!GlobalConfig.isLoginInitialise) {
            GlobalConfig.isLoginInitialise = true
            
            LoggingSystem.bootstrap({
                var logHandler = StreamLogHandler.standardOutput(label: $0)
                logHandler.logLevel = .debug
                return logHandler
            })
        }
    }
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                
                // content(geometry: geometry)
        
            }.onLoad {
                
                print("onLoad")
                NotificationCenter.default.post(name: .getRoomObject, object: room)
                NotificationCenter.default.post(name: .getRoomViewObject, object: self)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    NotificationCenter.default.post(name: .localParticipant, object: getLocalParticipant())
                    NotificationCenter.default.post(name: .updateRoomObject, object: nil)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func content(geometry: GeometryProxy) -> some View {
        
        VStack {
            HorVStack(axis: geometry.isTall ? .vertical : .horizontal, spacing: 5) {
                Group {
                    ParticipantLayout(sortedPrimaryParticipants(), spacing: 10) { participant  in
                        if let partic = participant as? Participant {
                            ParticipantView(participant: partic) { participant in
                            }
                        }
                        
                        else if let particView = participant as? ParticipantView {
                            particView
                        }
                    }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity
                )
            }
        }
        .padding(0)
    }
    
    
    func messageView(_ message: ExampleRoomMessageNew) -> some View {
        
        let isMe = message.senderSid == room.localParticipant?.sid
        
        return HStack {
            if isMe {
                Spacer()
            }
            Text(message.text)
                .padding(8)
                .background(isMe ? Color.lkRed : Color.lkGray3)
                .foregroundColor(Color.white)
                .cornerRadius(18)
            if !isMe {
                Spacer()
            }
        }.padding(.vertical, 5)
            .padding(.horizontal, 10)
    }
    
    func scrollToBottom(_ scrollView: ScrollViewProxy) {
        guard let last = roomCtx.messages.last else { return }
        withAnimation {
            scrollView.scrollTo(last.id)
        }
    }
    
    
    func messagesView(geometry: GeometryProxy) -> some View {
        
        VStack(spacing: 0) {
            ScrollViewReader { scrollView in
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(roomCtx.messages) {
                            messageView($0)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 7)
                }
                .onAppear(perform: {
                    // Scroll to bottom when first showing the messages list
                    scrollToBottom(scrollView)
                })
                .onChange(of: roomCtx.messages, perform: { _ in
                    // Scroll to bottom when there is a new message
                    scrollToBottom(scrollView)
                })
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
            HStack(spacing: 0) {
                
                TextField("Enter message", text: $roomCtx.textFieldString)
                    .textFieldStyle(PlainTextFieldStyle())
                    .disableAutocorrection(true)
                // TODO: add iOS unique view modifiers
                // #if os(iOS)
                // .autocapitalization(.none)
                // .keyboardType(type.toiOSType())
                // #endif
                
                //                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                //                                .strokeBorder(Color.white.opacity(0.3),
                //                                              style: StrokeStyle(lineWidth: 1.0)))
                
                Button {
                    roomCtx.sendMessage()
                } label: {
                    Image(systemSymbol: .paperplaneFill)
                        .foregroundColor(roomCtx.textFieldString.isEmpty ? nil : Color.lkRed)
                }
                .buttonStyle(.borderless)
                
            }
            .padding()
            .background(Color.lkGray2)
        }
        .background(Color.lkGray1)
        .cornerRadius(8)
        .frame(
            minWidth: 0,
            maxWidth: geometry.isTall ? .infinity : 320
        )
    }
    
    public func sortedPrimaryParticipants() -> [Any] {
        var allPart = sortedParticipants()
        
        if(allPart.count > maxGridCount){
            allPart = Array(allPart [0..<maxGridCount])
        }
        
        return allPart
    }
    
    public func sortedSecondaryParticipants() -> [ParticipantView] {
        var allPart = sortedParticipants()
        
        if(allPart.count > maxGridCount){
            allPart = Array(allPart [maxGridCount..<allPart.count])
        }else {
            allPart = []
        }
        
        var allParticipants : [ParticipantView] = []
        allPart.forEach {
            participant in
            
            if let partic = participant as? Participant {
                allParticipants.append(
                    ParticipantView(participant: partic) { participant in
                    })
            }
            
            else if let particView = participant as? ParticipantView {
                allParticipants.append(particView)
            }
        }
        return allParticipants
    }
    
    func sortedParticipants(isCallNotifier: Bool = true) -> [Any] {
        
        print("sortedParticipants")
        
        if(GlobalConfig.lastRemoteParticipantCount != room.remoteParticipants.count) {
            NotificationCenter.default.post(name: .updateRoomObject, object: nil)
        }
        
        if let screenShareParticipant = room.remoteParticipants.filter({$0.value.firstScreenSharePublication != nil}).first?.value {
            print("screenShareParticipant -> \(screenShareParticipant)")
            var allParticipant: [Any] = []
            var allRemotePart : [Participant] =  room.remoteParticipants.filter{$0.value.permissions.canSubscribe == true }.values.sorted { p1, p2 in
                return (p1.joinedAt ?? Date()) < (p2.joinedAt ?? Date())
            }
            
            allRemotePart.sort{ $0.isSpeaking && !$1.isSpeaking }
            allParticipant = allRemotePart
            
            // CODE FOR SHOW REMOTE PARTICIPANT SHARE SCREEN VIEW
            let parti = ParticipantView(participant: screenShareParticipant,
                                        isForceCamera:true) { participant in
            }
            allParticipant.append(parti)
            
            /*
             print("CHECK LOCAL USER PERMISSION -> name : \(room.localParticipant?.name), canSubscribe : \(room.localParticipant?.permissions.canSubscribe), canPublish : \(room.localParticipant?.permissions.canPublish), canPublishData : \(room.localParticipant?.permissions.canPublishData)")
             
             room.remoteParticipants.map {
             print("CHECK REMOTE USER PERMISSION -> name : \($0.value.name), canSubscribe : \($0.value.permissions.canSubscribe), canPublish : \($0.value.permissions.canPublish), canPublishData : \($0.value.permissions.canPublishData)")
             }
             */
            
            GlobalConfig.lastRemoteParticipantCount = allParticipant.count
            return allParticipant
            
        } else {
            
            var allRemotePart : [Participant] =  room.remoteParticipants.filter{$0.value.permissions.canSubscribe == true }.values.sorted { p1, p2 in
                return (p1.joinedAt ?? Date()) < (p2.joinedAt ?? Date())
            }
            /*
             print("CHECK LOCAL USER PERMISSION -> name : \(room.localParticipant?.name), canSubscribe : \(room.localParticipant?.permissions.canSubscribe), canPublish : \(room.localParticipant?.permissions.canPublish), canPublishData : \(room.localParticipant?.permissions.canPublishData)")
             
             room.remoteParticipants.map {
             print("CHECK REMOTE USER PERMISSION -> name : \($0.value.name), canSubscribe : \($0.value.permissions.canSubscribe), canPublish : \($0.value.permissions.canPublish), canPublishData : \($0.value.permissions.canPublishData)")
             }
             */
            
            allRemotePart.sort{ $0.isSpeaking && !$1.isSpeaking }
            //allRemotePart.sort{ ($0.firstCameraPublication != nil)  && ($1.firstCameraPublication == nil) }
            
            GlobalConfig.lastRemoteParticipantCount = allRemotePart.count
            return allRemotePart
        }
    }
    
    func getLocalParticipant() -> any View {
        
        if let localParticipant = room.localParticipant {
            return ParticipantView(participant: localParticipant,isForceCamera:true) { participant in
            }
        }else {
            return GeometryReader { geometry in}
        }
        
    }
    
    public func getRemoteParticipant() -> [ParticipantView] {
        
        var allParticipants : [ParticipantView] = []
        
        room.remoteParticipants.filter{$0.value.permissions.canSubscribe == true}.values.forEach {
            participant in
            
            allParticipants.append(
                ParticipantView(participant: participant) { participant in
                }
            )
        }
        
        allParticipants = allParticipants.sorted { $0.participant.isSpeaking && !$1.participant.isSpeaking }
        
        // CODE FOR SHOW REMOTE PARTICIPANT SHARE SCREEN VIEW FOR SPEAKER VIEW
        
        if let screenShareParticipant = room.remoteParticipants.filter({$0.value.firstScreenSharePublication != nil }).first?.value {
            
            let parti = ParticipantView(participant: screenShareParticipant,
                                        isForceCamera:true) { participant in
            }
            allParticipants.append(parti)
        }
        
        
        // CODE FOR SHOW LOCAL PARTICIPANT SHARE SCREEN VIEW FOR SPEAKER VIEW
        //        if let localP = room.room.localParticipant , localP.firstScreenSharePublication != nil, localP.firstScreenSharePublication != nil {
        //            let parti = ParticipantView(participant: localP,
        //                                        videoViewMode: appCtx.videoViewMode) { participant in
        //                room.focusParticipant = participant
        //            }
        //            allParticipants.append(parti)
        //        }
        
        
        //        if(allParticipants.count == 0){
        //            if let localP = room.room.localParticipant {
        //                return [ParticipantView(participant: localP) { participant in
        //                                    room.focusParticipant = participant } ]
        //            }
        //        }
        
        return allParticipants
    }
    
    public func getRemoteObservableParticipants() -> [Participant] {
        return room.remoteParticipants.map { (sid, participant) in
            return participant
        }
    }
}


extension RoomView : RoomViewDelegates {
    
    public func enableVideoClicked() {
        roomCtx.toggleCameraEnabled()
    }
    
    public func enableAudioClicked() {
        roomCtx.toggleMicrophoneEnabled()
    }
    
    public func switchCameraClicked() {
        roomCtx.switchCameraPosition()
    }
    
    public func startShareScreenClicked() {
        roomCtx.toggleScreenShareEnablediOS()
    }
    
    public func stopShareScreenClicked() {
        Task{
            await roomCtx.toggleScreenShareDisablediOS()
        }
    }
    
    public func enableSpeakerClicked() {
        AudioManager.shared.preferSpeakerOutput = true
    }
    
    public func disableSpeakerClicked() {
        AudioManager.shared.preferSpeakerOutput = false
    }
    
    public func disconnetRoomClicked() {
        Task {
            try await roomCtx.disconnect()
        }
    }
}


// FOR GENERATE ROOM GRID/LAYOUT

public struct ParticipantLayout<Content: View>: View {
    
    let views: [AnyView]
    let spacing: CGFloat
    
    init<Data: RandomAccessCollection>(
        _ data: Data,
        id: KeyPath<Data.Element, Data.Element> = \.self,
        spacing: CGFloat,
        @ViewBuilder content: @escaping (Data.Element) -> Content) {
            self.spacing = spacing
            self.views = data.map { AnyView(content($0[keyPath: id])) }
        }
    
    func computeColumn(with geometry: GeometryProxy) -> (x: Int, y: Int) {
        let sqr = Double(views.count).squareRoot()
        let r: [Int] = [Int(sqr.rounded()), Int(sqr.rounded(.up))]
        let c = geometry.isTall ? r : r.reversed()
        return (x: c[0], y: c[1])
    }
    
    func grid(axis: Axis, geometry: GeometryProxy) -> some View {
        ScrollView([ axis == .vertical ? .vertical : .horizontal ]) {
            HorVGrid(axis: axis, columns: [GridItem(.flexible())], spacing: spacing) {
                ForEach(0..<views.count, id: \.self) { i in
                    views[i]
                }
            }
            .padding(axis == .horizontal ? [.leading, .trailing] : [.top, .bottom],
                     max(0, ((axis == .horizontal ? geometry.size.width : geometry.size.height)
                             - ((axis == .horizontal ? geometry.size.height : geometry.size.width) * CGFloat(views.count)) - (spacing * CGFloat(views.count - 1))) / 2))
        }
    }
    
    func gridSmallOdd(axis: Axis, geometry: GeometryProxy) -> some View {
        ScrollView([ axis == .vertical ? .vertical : .horizontal ]) {
            
            HorVGrid(axis: axis, columns: [GridItem(.flexible()),GridItem(.flexible())], spacing: spacing) {
                ForEach(0..<views.count-1, id: \.self) { i in
                    views[i]
                }
            }
            views[views.count-1]
                .frame(height: geometry.size.width/2)
            
            
                .padding(axis == .horizontal ? [.leading, .trailing] : [.top, .bottom],
                         max(0, ((axis == .horizontal ? geometry.size.width : geometry.size.height)
                                 - ((axis == .horizontal ? geometry.size.height : geometry.size.width) * CGFloat(views.count)) - (spacing * CGFloat(views.count - 1))) / 2))
        }
    }
    
    func gridSmallEven(axis: Axis, geometry: GeometryProxy) -> some View {
        ScrollView([ axis == .vertical ? .vertical : .horizontal ]) {
            HorVGrid(axis: axis, columns: [GridItem(.flexible()),GridItem(.flexible())], spacing: spacing) {
                ForEach(0..<views.count, id: \.self) { i in
                    views[i]
                }
            }
            .padding(axis == .horizontal ? [.leading, .trailing] : [.top, .bottom],
                     max(0, ((axis == .horizontal ? geometry.size.width : geometry.size.height)
                             - ((axis == .horizontal ? geometry.size.height : geometry.size.width) * CGFloat(views.count)) - (spacing * CGFloat(views.count - 1))) / 2))
        }
    }
    
    
    public var body: some View {
        GeometryReader { geometry in
            
            if views.isEmpty {
                EmptyView()
            } else if geometry.size.width <= 300 {
                grid(axis: .vertical, geometry: geometry)
            } else if geometry.size.height <= 300 {
                grid(axis: .horizontal, geometry: geometry)
            } else {
                
                let verticalWhenTall: Axis = geometry.isTall ? .vertical : .horizontal
                let horizontalWhenTall: Axis = geometry.isTall ? .horizontal : .vertical
                
                switch views.count {
                    // simply return first view
                case 1: views[0]
                case 3: HorVStack(axis: verticalWhenTall, spacing: spacing) {
                    HorVStack(axis: horizontalWhenTall, spacing: spacing) {
                        views[1]
                        views[2]
                    }
                    views[0]
                    
                }
                case 5: HorVStack(axis: verticalWhenTall, spacing: spacing) {
                    if geometry.isTall {
                        HStack(spacing: spacing) {
                            views[1]
                            views[2]
                        }
                        HStack(spacing: spacing) {
                            views[3]
                            views[4]
                            
                        }
                    } else {
                        VStack(spacing: spacing) {
                            views[1]
                            views[3]
                        }
                        VStack(spacing: spacing) {
                            views[2]
                            views[4]
                        }
                    }
                    views[0]
                    
                }
                    
                case 2, 4, 6 :
                    
                    let c = computeColumn(with: geometry)
                    VStack(spacing: spacing) {
                        ForEach(0...(c.y - 1), id: \.self) { y in
                            HStack(spacing: spacing) {
                                ForEach(0...(c.x - 1), id: \.self) { x in
                                    let index = (y * c.x) + x
                                    if index < views.count {
                                        views[index]
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    //            case 6:
                    //                if geometry.isTall {
                    //                    VStack {
                    //                        HStack {
                    //                            views[0]
                    //                            views[1]
                    //                        }
                    //                        HStack {
                    //                            views[2]
                    //                            views[3]
                    //                        }
                    //                        HStack {
                    //                            views[4]
                    //                            views[5]
                    //                        }
                    //                    }
                    //                } else {
                    //                    VStack {
                    //                        HStack {
                    //                            views[0]
                    //                            views[1]
                    //                            views[2]
                    //                        }
                    //                        HStack {
                    //                            views[3]
                    //                            views[4]
                    //                            views[5]
                    //                        }
                    //                    }
                    //                }
                default:
                    
                    if(views.count % 2 == 0){
                        gridSmallEven(axis: .vertical, geometry: geometry)
                    } else {
                        gridSmallOdd(axis: .vertical, geometry: geometry)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HorVStack<Content: View>: View {
    let axis: Axis
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    init(axis: Axis = .horizontal,
         horizontalAlignment: HorizontalAlignment = .center,
         verticalAlignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.axis = axis
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        Group {
            if axis == .vertical {
                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
            }
        }
        .navigationBarHidden(true)
    }
}

struct HorVGrid<Content: View>: View {
    let axis: Axis
    let spacing: CGFloat?
    let content: () -> Content
    let columns: [GridItem]
    
    init(axis: Axis = .horizontal,
         columns: [GridItem],
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.axis = axis
        self.spacing = spacing
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        Group {
            if axis == .vertical {
                LazyVGrid(columns: columns, spacing: spacing, content: content)
            } else {
                LazyHGrid(rows: columns, spacing: spacing, content: content)
            }
        }
        .navigationBarHidden(true)
    }
}

extension GeometryProxy {
    
    public var isTall: Bool {
        size.height > size.width
    }
    
    var isWide: Bool {
        size.width > size.height
    }
}

