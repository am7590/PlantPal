//
//  GRPCManager.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 10/31/23.
//

import Foundation
import NIO
import GRPC

// Singleton that manages the gRPC channel
class GRPCManager {
    private var eventLoopGroup: MultiThreadedEventLoopGroup!
    
    static let shared = GRPCManager()
    
    public var userDeviceToken = "" {
        didSet {
            print("$$ \(userDeviceToken)")
        }
    }
    public var useriCloudToken = ""
    
    init() {
        // Needs to be in background or priority inversion will occur
        Task(priority: .background) {
            self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        }
    }
    
    func createChannel() -> ClientConnection {
        return ClientConnection.insecure(group: self.eventLoopGroup).connect(host: "127.0.0.1", port: 9001)
    }
    
    deinit {
        try? eventLoopGroup.syncShutdownGracefully()
    }
}
