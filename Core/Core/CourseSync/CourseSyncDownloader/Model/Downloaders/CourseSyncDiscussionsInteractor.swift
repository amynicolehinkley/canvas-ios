//
// This file is part of Canvas.
// Copyright (C) 2023-present  Instructure, Inc.
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

import Combine

public protocol CourseSyncDiscussionsInteractor: CourseSyncContentInteractor {}
public extension CourseSyncDiscussionsInteractor {
    var associatedTabType: TabName { .discussions }
}

public class CourseSyncDiscussionsInteractorLive: CourseSyncDiscussionsInteractor {
    let htmlParser: HTMLParser

    public init(htmlParser: HTMLParser) {
        self.htmlParser = htmlParser
    }

    public func getContent(courseId: String) -> AnyPublisher<Void, Error> {
        Self.fetchTopics(courseId: courseId, htmlParser: htmlParser)
            .flatMap { $0.publisher }
            .filter { $0.discussionSubEntryCount > 0 && $0.anonymousState == nil }
            .flatMap { [htmlParser] in Self.getDiscussionView(courseId: courseId, topicId: $0.id, htmlParser: htmlParser) }
            .collect()
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    public func cleanContent(courseId: String) -> AnyPublisher<Void, Never> {
        let rootURL = URL.Paths.Offline.courseSectionFolderURL(
            sessionId: htmlParser.sessionId,
            courseId: courseId,
            sectionName: htmlParser.sectionName
        )

        return FileManager.default.removeItemPublisher(at: rootURL)
    }

    // MARK: - Private Methods

    private static func fetchTopics(
        courseId: String,
        htmlParser: HTMLParser
    ) -> AnyPublisher<[DiscussionTopic], Error> {

        return ReactiveStore(useCase: GetDiscussionTopics(context: .course(courseId)))
            .getEntities(ignoreCache: true)
            .eraseToAnyPublisher()
    }

    private static func getDiscussionView(
        courseId: String,
        topicId: String,
        htmlParser: HTMLParser
    ) -> AnyPublisher<Void, Error> {

        return ReactiveStore(useCase: GetDiscussionView(context: .course(courseId), topicID: topicId))
            .getEntities(ignoreCache: true)
            .mapToVoid()
            .eraseToAnyPublisher()
    }
}
