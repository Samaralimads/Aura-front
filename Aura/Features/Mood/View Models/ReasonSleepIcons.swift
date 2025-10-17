//
//  ReasonSleepIcons.swift
//  Aura
//
//  Created by Samara Lima da Silva on 17/10/2025.
//

import SwiftUI

enum ReasonSleepIcons {
    static func image(forName name: String?, in reasons: [ReasonModel], sleeps: [SleepModel]) -> Image? {
        guard let name, !name.isEmpty else { return nil }

        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if let reason = reasons.first(where: {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == normalizedName
        }) {
            return fromAsset(reason.image)
        }

        if let sleep = sleeps.first(where: {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == normalizedName
        }) {
            return fromAsset(sleep.image)
        }

        return nil
    }

    static func fromAsset(_ name: String?) -> Image? {
        guard let name, !name.isEmpty else { return nil }
        return Image(name)
    }
}
