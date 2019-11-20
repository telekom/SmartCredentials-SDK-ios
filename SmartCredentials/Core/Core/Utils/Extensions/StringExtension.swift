//
//  StringExtension.swift
//  Core
//
//  Created by Catalin Haidau on 20/11/2019.
//  Copyright © 2019 Andrei Moldovan. All rights reserved.
//

extension String {

    public func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error)
            }
        }
        return nil
    }
}
