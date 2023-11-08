//
//  GRPCManager.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 10/31/23.
//

import Foundation
import NIO
import GRPC

class GRPCManager {
    private var eventLoopGroup: MultiThreadedEventLoopGroup!
    
    static let shared = GRPCManager()
    
    init() {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    }
    
    func createChannel() -> ClientConnection {
        return ClientConnection.insecure(group: self.eventLoopGroup).connect(host: "localhost", port: 9001)
    }
    
    deinit {
        try? eventLoopGroup.syncShutdownGracefully()
    }
}
