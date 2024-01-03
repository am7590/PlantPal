//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: store.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// Usage: instantiate `Plant_PlantServiceClient`, then call methods of this protocol to make API calls.
public protocol Plant_PlantServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? { get }

  func add(
    _ request: Plant_Plant,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_Plant, Plant_PlantResponse>

  func remove(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_PlantResponse>

  func get(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_Plant>

  func getWatered(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<SwiftProtobuf.Google_Protobuf_Empty, Plant_ListOfPlants>

  func updatePlant(
    _ request: Plant_PlantUpdateRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_PlantUpdateRequest, Plant_PlantUpdateResponse>

  func saveHealthCheckData(
    _ request: Plant_HealthCheckDataRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_HealthCheckDataRequest, Plant_HealthCheckDataResponse>

  func identificationRequest(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_PlantInformation>

  func healthCheckRequest(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_HealthCheckInformation>
}

extension Plant_PlantServiceClientProtocol {
  public var serviceName: String {
    return "plant.PlantService"
  }

  /// Create plant
  ///
  /// - Parameters:
  ///   - request: Request to send to Add.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func add(
    _ request: Plant_Plant,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_Plant, Plant_PlantResponse> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.add.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAddInterceptors() ?? []
    )
  }

  /// Remove plant
  ///
  /// - Parameters:
  ///   - request: Request to send to Remove.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func remove(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_PlantResponse> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.remove.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeRemoveInterceptors() ?? []
    )
  }

  /// Get plant 
  ///
  /// - Parameters:
  ///   - request: Request to send to Get.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func get(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_Plant> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.get.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetInterceptors() ?? []
    )
  }

  /// Get a list of plants that need to be watered (for APNs microservice)
  ///
  /// - Parameters:
  ///   - request: Request to send to GetWatered.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getWatered(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<SwiftProtobuf.Google_Protobuf_Empty, Plant_ListOfPlants> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.getWatered.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetWateredInterceptors() ?? []
    )
  }

  /// Update plant schedule/health check/id time
  ///
  /// - Parameters:
  ///   - request: Request to send to UpdatePlant.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func updatePlant(
    _ request: Plant_PlantUpdateRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_PlantUpdateRequest, Plant_PlantUpdateResponse> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.updatePlant.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdatePlantInterceptors() ?? []
    )
  }

  /// Save JSON health check
  ///
  /// - Parameters:
  ///   - request: Request to send to SaveHealthCheckData.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func saveHealthCheckData(
    _ request: Plant_HealthCheckDataRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_HealthCheckDataRequest, Plant_HealthCheckDataResponse> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.saveHealthCheckData.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSaveHealthCheckDataInterceptors() ?? []
    )
  }

  /// Caching
  ///
  /// - Parameters:
  ///   - request: Request to send to IdentificationRequest.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func identificationRequest(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_PlantInformation> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.identificationRequest.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeIdentificationRequestInterceptors() ?? []
    )
  }

  /// Unary call to HealthCheckRequest
  ///
  /// - Parameters:
  ///   - request: Request to send to HealthCheckRequest.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func healthCheckRequest(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Plant_PlantIdentifier, Plant_HealthCheckInformation> {
    return self.makeUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.healthCheckRequest.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeHealthCheckRequestInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Plant_PlantServiceClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Plant_PlantServiceNIOClient")
public final class Plant_PlantServiceClient: Plant_PlantServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the plant.PlantService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Plant_PlantServiceNIOClient: Plant_PlantServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the plant.PlantService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Plant_PlantServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? { get }

  func makeAddCall(
    _ request: Plant_Plant,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_Plant, Plant_PlantResponse>

  func makeRemoveCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_PlantResponse>

  func makeGetCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_Plant>

  func makeGetWateredCall(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<SwiftProtobuf.Google_Protobuf_Empty, Plant_ListOfPlants>

  func makeUpdatePlantCall(
    _ request: Plant_PlantUpdateRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_PlantUpdateRequest, Plant_PlantUpdateResponse>

  func makeSaveHealthCheckDataCall(
    _ request: Plant_HealthCheckDataRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_HealthCheckDataRequest, Plant_HealthCheckDataResponse>

  func makeIdentificationRequestCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_PlantInformation>

  func makeHealthCheckRequestCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_HealthCheckInformation>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Plant_PlantServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Plant_PlantServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeAddCall(
    _ request: Plant_Plant,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_Plant, Plant_PlantResponse> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.add.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAddInterceptors() ?? []
    )
  }

  public func makeRemoveCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_PlantResponse> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.remove.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeRemoveInterceptors() ?? []
    )
  }

  public func makeGetCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_Plant> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.get.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetInterceptors() ?? []
    )
  }

  public func makeGetWateredCall(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<SwiftProtobuf.Google_Protobuf_Empty, Plant_ListOfPlants> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.getWatered.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetWateredInterceptors() ?? []
    )
  }

  public func makeUpdatePlantCall(
    _ request: Plant_PlantUpdateRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_PlantUpdateRequest, Plant_PlantUpdateResponse> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.updatePlant.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdatePlantInterceptors() ?? []
    )
  }

  public func makeSaveHealthCheckDataCall(
    _ request: Plant_HealthCheckDataRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_HealthCheckDataRequest, Plant_HealthCheckDataResponse> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.saveHealthCheckData.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSaveHealthCheckDataInterceptors() ?? []
    )
  }

  public func makeIdentificationRequestCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_PlantInformation> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.identificationRequest.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeIdentificationRequestInterceptors() ?? []
    )
  }

  public func makeHealthCheckRequestCall(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Plant_PlantIdentifier, Plant_HealthCheckInformation> {
    return self.makeAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.healthCheckRequest.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeHealthCheckRequestInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Plant_PlantServiceAsyncClientProtocol {
  public func add(
    _ request: Plant_Plant,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_PlantResponse {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.add.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAddInterceptors() ?? []
    )
  }

  public func remove(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_PlantResponse {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.remove.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeRemoveInterceptors() ?? []
    )
  }

  public func get(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_Plant {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.get.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetInterceptors() ?? []
    )
  }

  public func getWatered(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_ListOfPlants {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.getWatered.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetWateredInterceptors() ?? []
    )
  }

  public func updatePlant(
    _ request: Plant_PlantUpdateRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_PlantUpdateResponse {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.updatePlant.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdatePlantInterceptors() ?? []
    )
  }

  public func saveHealthCheckData(
    _ request: Plant_HealthCheckDataRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_HealthCheckDataResponse {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.saveHealthCheckData.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSaveHealthCheckDataInterceptors() ?? []
    )
  }

  public func identificationRequest(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_PlantInformation {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.identificationRequest.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeIdentificationRequestInterceptors() ?? []
    )
  }

  public func healthCheckRequest(
    _ request: Plant_PlantIdentifier,
    callOptions: CallOptions? = nil
  ) async throws -> Plant_HealthCheckInformation {
    return try await self.performAsyncUnaryCall(
      path: Plant_PlantServiceClientMetadata.Methods.healthCheckRequest.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeHealthCheckRequestInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Plant_PlantServiceAsyncClient: Plant_PlantServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Plant_PlantServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Plant_PlantServiceClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'add'.
  func makeAddInterceptors() -> [ClientInterceptor<Plant_Plant, Plant_PlantResponse>]

  /// - Returns: Interceptors to use when invoking 'remove'.
  func makeRemoveInterceptors() -> [ClientInterceptor<Plant_PlantIdentifier, Plant_PlantResponse>]

  /// - Returns: Interceptors to use when invoking 'get'.
  func makeGetInterceptors() -> [ClientInterceptor<Plant_PlantIdentifier, Plant_Plant>]

  /// - Returns: Interceptors to use when invoking 'getWatered'.
  func makeGetWateredInterceptors() -> [ClientInterceptor<SwiftProtobuf.Google_Protobuf_Empty, Plant_ListOfPlants>]

  /// - Returns: Interceptors to use when invoking 'updatePlant'.
  func makeUpdatePlantInterceptors() -> [ClientInterceptor<Plant_PlantUpdateRequest, Plant_PlantUpdateResponse>]

  /// - Returns: Interceptors to use when invoking 'saveHealthCheckData'.
  func makeSaveHealthCheckDataInterceptors() -> [ClientInterceptor<Plant_HealthCheckDataRequest, Plant_HealthCheckDataResponse>]

  /// - Returns: Interceptors to use when invoking 'identificationRequest'.
  func makeIdentificationRequestInterceptors() -> [ClientInterceptor<Plant_PlantIdentifier, Plant_PlantInformation>]

  /// - Returns: Interceptors to use when invoking 'healthCheckRequest'.
  func makeHealthCheckRequestInterceptors() -> [ClientInterceptor<Plant_PlantIdentifier, Plant_HealthCheckInformation>]
}

public enum Plant_PlantServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "PlantService",
    fullName: "plant.PlantService",
    methods: [
      Plant_PlantServiceClientMetadata.Methods.add,
      Plant_PlantServiceClientMetadata.Methods.remove,
      Plant_PlantServiceClientMetadata.Methods.get,
      Plant_PlantServiceClientMetadata.Methods.getWatered,
      Plant_PlantServiceClientMetadata.Methods.updatePlant,
      Plant_PlantServiceClientMetadata.Methods.saveHealthCheckData,
      Plant_PlantServiceClientMetadata.Methods.identificationRequest,
      Plant_PlantServiceClientMetadata.Methods.healthCheckRequest,
    ]
  )

  public enum Methods {
    public static let add = GRPCMethodDescriptor(
      name: "Add",
      path: "/plant.PlantService/Add",
      type: GRPCCallType.unary
    )

    public static let remove = GRPCMethodDescriptor(
      name: "Remove",
      path: "/plant.PlantService/Remove",
      type: GRPCCallType.unary
    )

    public static let get = GRPCMethodDescriptor(
      name: "Get",
      path: "/plant.PlantService/Get",
      type: GRPCCallType.unary
    )

    public static let getWatered = GRPCMethodDescriptor(
      name: "GetWatered",
      path: "/plant.PlantService/GetWatered",
      type: GRPCCallType.unary
    )

    public static let updatePlant = GRPCMethodDescriptor(
      name: "UpdatePlant",
      path: "/plant.PlantService/UpdatePlant",
      type: GRPCCallType.unary
    )

    public static let saveHealthCheckData = GRPCMethodDescriptor(
      name: "SaveHealthCheckData",
      path: "/plant.PlantService/SaveHealthCheckData",
      type: GRPCCallType.unary
    )

    public static let identificationRequest = GRPCMethodDescriptor(
      name: "IdentificationRequest",
      path: "/plant.PlantService/IdentificationRequest",
      type: GRPCCallType.unary
    )

    public static let healthCheckRequest = GRPCMethodDescriptor(
      name: "HealthCheckRequest",
      path: "/plant.PlantService/HealthCheckRequest",
      type: GRPCCallType.unary
    )
  }
}

/// To build a server, implement a class that conforms to this protocol.
public protocol Plant_PlantServiceProvider: CallHandlerProvider {
  var interceptors: Plant_PlantServiceServerInterceptorFactoryProtocol? { get }

  /// Create plant
  func add(request: Plant_Plant, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_PlantResponse>

  /// Remove plant
  func remove(request: Plant_PlantIdentifier, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_PlantResponse>

  /// Get plant 
  func get(request: Plant_PlantIdentifier, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_Plant>

  /// Get a list of plants that need to be watered (for APNs microservice)
  func getWatered(request: SwiftProtobuf.Google_Protobuf_Empty, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_ListOfPlants>

  /// Update plant schedule/health check/id time
  func updatePlant(request: Plant_PlantUpdateRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_PlantUpdateResponse>

  /// Save JSON health check
  func saveHealthCheckData(request: Plant_HealthCheckDataRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_HealthCheckDataResponse>

  /// Caching
  func identificationRequest(request: Plant_PlantIdentifier, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_PlantInformation>

  func healthCheckRequest(request: Plant_PlantIdentifier, context: StatusOnlyCallContext) -> EventLoopFuture<Plant_HealthCheckInformation>
}

extension Plant_PlantServiceProvider {
  public var serviceName: Substring {
    return Plant_PlantServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Add":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_Plant>(),
        responseSerializer: ProtobufSerializer<Plant_PlantResponse>(),
        interceptors: self.interceptors?.makeAddInterceptors() ?? [],
        userFunction: self.add(request:context:)
      )

    case "Remove":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_PlantResponse>(),
        interceptors: self.interceptors?.makeRemoveInterceptors() ?? [],
        userFunction: self.remove(request:context:)
      )

    case "Get":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_Plant>(),
        interceptors: self.interceptors?.makeGetInterceptors() ?? [],
        userFunction: self.get(request:context:)
      )

    case "GetWatered":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SwiftProtobuf.Google_Protobuf_Empty>(),
        responseSerializer: ProtobufSerializer<Plant_ListOfPlants>(),
        interceptors: self.interceptors?.makeGetWateredInterceptors() ?? [],
        userFunction: self.getWatered(request:context:)
      )

    case "UpdatePlant":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantUpdateRequest>(),
        responseSerializer: ProtobufSerializer<Plant_PlantUpdateResponse>(),
        interceptors: self.interceptors?.makeUpdatePlantInterceptors() ?? [],
        userFunction: self.updatePlant(request:context:)
      )

    case "SaveHealthCheckData":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_HealthCheckDataRequest>(),
        responseSerializer: ProtobufSerializer<Plant_HealthCheckDataResponse>(),
        interceptors: self.interceptors?.makeSaveHealthCheckDataInterceptors() ?? [],
        userFunction: self.saveHealthCheckData(request:context:)
      )

    case "IdentificationRequest":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_PlantInformation>(),
        interceptors: self.interceptors?.makeIdentificationRequestInterceptors() ?? [],
        userFunction: self.identificationRequest(request:context:)
      )

    case "HealthCheckRequest":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_HealthCheckInformation>(),
        interceptors: self.interceptors?.makeHealthCheckRequestInterceptors() ?? [],
        userFunction: self.healthCheckRequest(request:context:)
      )

    default:
      return nil
    }
  }
}

/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Plant_PlantServiceAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Plant_PlantServiceServerInterceptorFactoryProtocol? { get }

  /// Create plant
  func add(
    request: Plant_Plant,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_PlantResponse

  /// Remove plant
  func remove(
    request: Plant_PlantIdentifier,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_PlantResponse

  /// Get plant 
  func get(
    request: Plant_PlantIdentifier,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_Plant

  /// Get a list of plants that need to be watered (for APNs microservice)
  func getWatered(
    request: SwiftProtobuf.Google_Protobuf_Empty,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_ListOfPlants

  /// Update plant schedule/health check/id time
  func updatePlant(
    request: Plant_PlantUpdateRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_PlantUpdateResponse

  /// Save JSON health check
  func saveHealthCheckData(
    request: Plant_HealthCheckDataRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_HealthCheckDataResponse

  /// Caching
  func identificationRequest(
    request: Plant_PlantIdentifier,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_PlantInformation

  func healthCheckRequest(
    request: Plant_PlantIdentifier,
    context: GRPCAsyncServerCallContext
  ) async throws -> Plant_HealthCheckInformation
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Plant_PlantServiceAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Plant_PlantServiceServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return Plant_PlantServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: Plant_PlantServiceServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Add":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_Plant>(),
        responseSerializer: ProtobufSerializer<Plant_PlantResponse>(),
        interceptors: self.interceptors?.makeAddInterceptors() ?? [],
        wrapping: { try await self.add(request: $0, context: $1) }
      )

    case "Remove":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_PlantResponse>(),
        interceptors: self.interceptors?.makeRemoveInterceptors() ?? [],
        wrapping: { try await self.remove(request: $0, context: $1) }
      )

    case "Get":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_Plant>(),
        interceptors: self.interceptors?.makeGetInterceptors() ?? [],
        wrapping: { try await self.get(request: $0, context: $1) }
      )

    case "GetWatered":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SwiftProtobuf.Google_Protobuf_Empty>(),
        responseSerializer: ProtobufSerializer<Plant_ListOfPlants>(),
        interceptors: self.interceptors?.makeGetWateredInterceptors() ?? [],
        wrapping: { try await self.getWatered(request: $0, context: $1) }
      )

    case "UpdatePlant":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantUpdateRequest>(),
        responseSerializer: ProtobufSerializer<Plant_PlantUpdateResponse>(),
        interceptors: self.interceptors?.makeUpdatePlantInterceptors() ?? [],
        wrapping: { try await self.updatePlant(request: $0, context: $1) }
      )

    case "SaveHealthCheckData":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_HealthCheckDataRequest>(),
        responseSerializer: ProtobufSerializer<Plant_HealthCheckDataResponse>(),
        interceptors: self.interceptors?.makeSaveHealthCheckDataInterceptors() ?? [],
        wrapping: { try await self.saveHealthCheckData(request: $0, context: $1) }
      )

    case "IdentificationRequest":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_PlantInformation>(),
        interceptors: self.interceptors?.makeIdentificationRequestInterceptors() ?? [],
        wrapping: { try await self.identificationRequest(request: $0, context: $1) }
      )

    case "HealthCheckRequest":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Plant_PlantIdentifier>(),
        responseSerializer: ProtobufSerializer<Plant_HealthCheckInformation>(),
        interceptors: self.interceptors?.makeHealthCheckRequestInterceptors() ?? [],
        wrapping: { try await self.healthCheckRequest(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

public protocol Plant_PlantServiceServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'add'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeAddInterceptors() -> [ServerInterceptor<Plant_Plant, Plant_PlantResponse>]

  /// - Returns: Interceptors to use when handling 'remove'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeRemoveInterceptors() -> [ServerInterceptor<Plant_PlantIdentifier, Plant_PlantResponse>]

  /// - Returns: Interceptors to use when handling 'get'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGetInterceptors() -> [ServerInterceptor<Plant_PlantIdentifier, Plant_Plant>]

  /// - Returns: Interceptors to use when handling 'getWatered'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGetWateredInterceptors() -> [ServerInterceptor<SwiftProtobuf.Google_Protobuf_Empty, Plant_ListOfPlants>]

  /// - Returns: Interceptors to use when handling 'updatePlant'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeUpdatePlantInterceptors() -> [ServerInterceptor<Plant_PlantUpdateRequest, Plant_PlantUpdateResponse>]

  /// - Returns: Interceptors to use when handling 'saveHealthCheckData'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSaveHealthCheckDataInterceptors() -> [ServerInterceptor<Plant_HealthCheckDataRequest, Plant_HealthCheckDataResponse>]

  /// - Returns: Interceptors to use when handling 'identificationRequest'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeIdentificationRequestInterceptors() -> [ServerInterceptor<Plant_PlantIdentifier, Plant_PlantInformation>]

  /// - Returns: Interceptors to use when handling 'healthCheckRequest'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeHealthCheckRequestInterceptors() -> [ServerInterceptor<Plant_PlantIdentifier, Plant_HealthCheckInformation>]
}

public enum Plant_PlantServiceServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "PlantService",
    fullName: "plant.PlantService",
    methods: [
      Plant_PlantServiceServerMetadata.Methods.add,
      Plant_PlantServiceServerMetadata.Methods.remove,
      Plant_PlantServiceServerMetadata.Methods.get,
      Plant_PlantServiceServerMetadata.Methods.getWatered,
      Plant_PlantServiceServerMetadata.Methods.updatePlant,
      Plant_PlantServiceServerMetadata.Methods.saveHealthCheckData,
      Plant_PlantServiceServerMetadata.Methods.identificationRequest,
      Plant_PlantServiceServerMetadata.Methods.healthCheckRequest,
    ]
  )

  public enum Methods {
    public static let add = GRPCMethodDescriptor(
      name: "Add",
      path: "/plant.PlantService/Add",
      type: GRPCCallType.unary
    )

    public static let remove = GRPCMethodDescriptor(
      name: "Remove",
      path: "/plant.PlantService/Remove",
      type: GRPCCallType.unary
    )

    public static let get = GRPCMethodDescriptor(
      name: "Get",
      path: "/plant.PlantService/Get",
      type: GRPCCallType.unary
    )

    public static let getWatered = GRPCMethodDescriptor(
      name: "GetWatered",
      path: "/plant.PlantService/GetWatered",
      type: GRPCCallType.unary
    )

    public static let updatePlant = GRPCMethodDescriptor(
      name: "UpdatePlant",
      path: "/plant.PlantService/UpdatePlant",
      type: GRPCCallType.unary
    )

    public static let saveHealthCheckData = GRPCMethodDescriptor(
      name: "SaveHealthCheckData",
      path: "/plant.PlantService/SaveHealthCheckData",
      type: GRPCCallType.unary
    )

    public static let identificationRequest = GRPCMethodDescriptor(
      name: "IdentificationRequest",
      path: "/plant.PlantService/IdentificationRequest",
      type: GRPCCallType.unary
    )

    public static let healthCheckRequest = GRPCMethodDescriptor(
      name: "HealthCheckRequest",
      path: "/plant.PlantService/HealthCheckRequest",
      type: GRPCCallType.unary
    )
  }
}