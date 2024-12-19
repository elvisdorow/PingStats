//
//  SessionResult.swift
//
//  Created by Elvis Dorow on 11/09/24.
//

import Foundation

class Session {
    
    var parameters: SessionParam
    var connectionType: String
    
    var pingStat: PingStat? = nil
    
    private(set) var responses: [ICMPResponse]
    private(set) var pingLogs: [PingLog]
    
    let startDate: Date
    var endDate: Date?
    var elapsedTime: TimeInterval
    
    var resolvedIpOrHost: String?
    
    init(_ params: SessionParam) {
        parameters = params
        startDate = Date()
        endDate = nil
        elapsedTime = 0
        responses = []
        pingLogs = []
        connectionType = ""
    }
    
    func addResponse(_ response: ICMPResponse) -> PingLog {
        responses.append(response)
        return addPingLog(response)
    }
    
    func getInstantPingStat() -> PingStat {
        let numResponses = (parameters.pingCountStat == .countAll)
        ? responses.count : parameters.pingCountStat.rawValue
        
        return StatCalculator.getInstantStat(responses: responses, responsesCount: numResponses)
    }
    
    func generateFullTestPingStat() {
        pingStat = StatCalculator.getFullTestPingStat(responses: responses)
    }
    
    private func addPingLog(_ response: ICMPResponse) -> PingLog {
        let sequence = response.sequence
        
        if let error = response.error {
            var errorMessage = ""
            
            switch error {
                case .responseTimeout:
                errorMessage = "Response timeout"
                case .invalidLength(let received):
                errorMessage = "Invalid length: \(received)"
                case .checksumMismatch(let received, let calculated):
                errorMessage = "Checksum mismatch: \(received) != \(calculated)"
                case .invalidType(let received):
                errorMessage = "Invalid type: \(received)"
                case .invalidCode(let received):
                errorMessage = "Invalid code: \(received)"
                case .identifierMismatch(let received, let expected):
                errorMessage = "Identifier mismatch: \(received) != \(expected)"
                case .invalidSequenceIndex(let received, let expected):
                errorMessage = "Invalid sequence index: \(received) != \(expected)"
                case .unknownHostError:
                errorMessage = "Unknown host error"
                case .addressLookupError:
                errorMessage = "Address lookup error"
                case .hostNotFound:
                errorMessage = "Host not found"
                case .addressMemoryError:
                errorMessage = "Address memory error"
                case .requestError:
                errorMessage = "Request error"
                case .requestTimeout:
                errorMessage = "Request timeout"
                case .checksumOutOfBounds:
                errorMessage = "Checksum out of bounds"
                case .unexpectedPayloadLength:
                errorMessage =  "Unexpected payload length"
                case .packageCreationFailed:
                errorMessage = "Package creation failed"
                case .socketNil:
                errorMessage = "Socket nil"
                case .invalidHeaderOffset:
                errorMessage = "Invalid header offset"
                case .socketOptionsSetError(let err):
                errorMessage = "Socket options set error: \(err)"
            }
                
            let log = PingLog(sequence: sequence, error: errorMessage)            
            pingLogs.append(log)
            return log
        } else {
            let responseTime = response.duration * 1000
            
            let log = PingLog(
                sequence: sequence,
                bytes: response.bytes,
                timeToLive: response.timeToLive,
                duration: responseTime)
            
            pingLogs.append(log)
            return log
        }
    }
}
