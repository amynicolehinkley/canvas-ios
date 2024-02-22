//
// This file is part of Canvas.
// Copyright (C) 2024-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation

public class UpdateConversationState: APIUseCase {
    public var cacheKey: String?
    public typealias Model = Conversation
    public let id: String
    public let state: ConversationWorkflowState

    public var request: PutConversationRequest {
        return PutConversationRequest(id: id, workflowState: state)
    }

    public init(id: String, state: ConversationWorkflowState) {
        self.id = id
        self.state = state
    }
}
