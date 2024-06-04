import SwiftUI
import Logging
import LiveKit
import KeychainAccess


public let sync = ValueStore<Preferences>(store: Keychain(service: "com.loktantramediatech.khulke"),
                                          key: "preferences",
                                          default: Preferences())
public struct RoomContextView: View {
    
    @EnvironmentObject var appCtx: AppContext
    @StateObject var roomCtx = RoomContext(store: sync)

    public var shouldShowRoomView: Bool {
        roomCtx.room.connectionState.isConnected || roomCtx.room.connectionState.isReconnecting
    }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.black
            
            if shouldShowRoomView {
                RoomView()
            }
            
        }
        .environment(\.colorScheme, .dark)
        .foregroundColor(Color.white)
        .environmentObject(roomCtx)
        .environmentObject(roomCtx.room)
        .navigationBarHidden(true)
        .onAppear{
            
        }
        .onLoad {
            roomCtx.url = GlobalConfig.lkEnvironment.baseURL
            roomCtx.token = GlobalConfig.liveKitToken
            
            Task {
                let room = try await roomCtx.connect()
            }
            
        }
        .onDisappear {
            print("\(String(describing: type(of: self))) onDisappear")
        }
        .navigationBarHidden(true)
    }
}

extension Decimal {
    mutating func round(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) {
        var localCopy = self
        NSDecimalRound(&self, &localCopy, scale, roundingMode)
    }
    
    func rounded(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, roundingMode)
        return result
    }
    
    func remainder(of divisor: Decimal) -> Decimal {
        let s = self as NSDecimalNumber
        let d = divisor as NSDecimalNumber
        let b = NSDecimalNumberHandler(roundingMode: .down,
                                       scale: 0,
                                       raiseOnExactness: false,
                                       raiseOnOverflow: false,
                                       raiseOnUnderflow: false,
                                       raiseOnDivideByZero: false)
        let quotient = s.dividing(by: d, withBehavior: b)
        
        let subtractAmount = quotient.multiplying(by: d)
        return s.subtracting(subtractAmount) as Decimal
    }
}

@main
public struct LiveKitMeetUp: App {
    
    @StateObject var appCtx = AppContext(store: sync)
    
    func nearestSafeScale(for target: Int, scale: Double) -> Decimal {
        
        let p = Decimal(sign: .plus, exponent: -3, significand: 1)
        let t = Decimal(target)
        var s = Decimal(scale).rounded(3, .down)
        
        while (t * s / 2).remainder(of: 2) != 0 {
            s = s + p
        }
        
        return s
    }
    
    public init() {
        LoggingSystem.bootstrap({
            var logHandler = StreamLogHandler.standardOutput(label: $0)
            logHandler.logLevel = .debug
            return logHandler
        })
    }
    
    public var body: some Scene {
        WindowGroup {
            RoomContextView()
                .environmentObject(appCtx)
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
}
