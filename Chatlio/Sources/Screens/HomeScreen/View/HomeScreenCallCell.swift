//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

struct HomeScreenCallCell: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let room: HomeScreenRoom
    let mediaProvider: MediaProviderProtocol!
    let action: @MainActor (HomeScreenViewAction) -> Void
    
    private let verticalInsets = 12.0
    private let horizontalInsets = 16.0
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                if let roomID = room.roomID {
                    action(.selectRoom(roomIdentifier: roomID))
                }
            } label: {
                HStack(spacing: 16.0) {
                    avatar
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(room.name)
                            .font(.compound.bodyLGSemibold)
                            .foregroundColor(.compound.textPrimary)
                            .lineLimit(1)
                        
                        HStack(spacing: 4) {
                            // Call direction icon (simplified for now)
                            CompoundIcon(\.voiceCall, size: .xSmall, relativeTo: .compound.bodySM)
                                .foregroundColor(.compound.textSecondary)
                            
                            if let timestamp = room.timestamp {
                                Text(timestamp)
                                    .font(.compound.bodySM)
                                    .foregroundColor(.compound.textSecondary)
                            }
                        }
                    }
                    .padding(.vertical, verticalInsets)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            HStack(spacing: 20) {
                Button {
                    if let roomID = room.roomID {
                        action(.startCall(roomIdentifier: roomID, audioOnly: true))
                    }
                } label: {
                    CompoundIcon(\.voiceCall)
                        .foregroundColor(.compound.textActionAccent)
                }
                .buttonStyle(.plain)
                
                Button {
                    if let roomID = room.roomID {
                        action(.startCall(roomIdentifier: roomID, audioOnly: false))
                    }
                } label: {
                    CompoundIcon(\.videoCallSolid)
                        .foregroundColor(.compound.textActionAccent)
                }
                .buttonStyle(.plain)
            }
            .padding(.trailing, horizontalInsets)
        }
        .padding(.leading, horizontalInsets)
        .background(Color.compound.bgCanvasDefault)
        .rowDivider(horizontalInsets: horizontalInsets)
    }
    
    @ViewBuilder @MainActor
    private var avatar: some View {
        RoomAvatarImage(avatar: room.avatar,
                        avatarSize: .room(on: .chats),
                        mediaProvider: mediaProvider)
            .accessibilityHidden(true)
    }
}
