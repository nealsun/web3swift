//
//  RippleApi.swift
//  web3swift
//
//  Created by Dmitry on 21/12/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit
import CoreBlockchain

extension URL {
    static var xrpMainnet = URL(string: "https://s2.ripple.com:51234")!
    static var xrpTestnet = URL(string: "https://s.altnet.rippletest.net:51234")!
}

let ripple = RippleApi.mainnet
class RippleApi {
    let network: NetworkProvider
    let accounts: RippleAccountsApi
    
    init(network: NetworkProvider) {
        self.network = network
        self.accounts = RippleAccountsApi(network: network)
    }
    static var mainnet: RippleApi {
        return RippleApi(network: NetworkProvider(url: .xrpMainnet))
    }
    static var testnet: RippleApi {
        return RippleApi(network: NetworkProvider(url: .xrpTestnet))
    }
}

extension AnyReader {
    func uint() throws -> UInt {
        if let value = raw as? UInt {
            return value
        } else if let value = raw as? String {
            if value.isHex {
                guard let value = UInt(value.withoutHex, radix: 16) else { throw unconvertible(to: "UInt") }
                return value
            } else {
                guard let value = UInt(value) else { throw unconvertible(to: "UInt") }
                return value
            }
        } else {
            throw unconvertible(to: "UInt")
        }
    }
    func rippleAddress() throws -> RippleAddress {
        let string = try self.string()
        guard let address = RippleAddress(string) else { throw unconvertible(to: "base58 data") }
        return address
    }
    /// Returns bool if exists and false if not
    func bool(at key: String) throws -> Bool {
        return try optional(key)?.bool() ?? false
    }
}