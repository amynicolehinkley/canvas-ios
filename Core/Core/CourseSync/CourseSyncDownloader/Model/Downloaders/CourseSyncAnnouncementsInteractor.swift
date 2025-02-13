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
import Foundation

public protocol CourseSyncAnnouncementsInteractor: CourseSyncContentInteractor {}

extension CourseSyncAnnouncementsInteractor {
    public var associatedTabType: TabName { .announcements }
}

public final class CourseSyncAnnouncementsInteractorLive: CourseSyncAnnouncementsInteractor {
    let htmlParser: HTMLParser

    public init(htmlParser: HTMLParser) {
        self.htmlParser = htmlParser
    }

    public func getContent(courseId: String) -> AnyPublisher<Void, Error> {
        Publishers
            .Zip4(fetchColors(),
                  fetchCourse(courseId: courseId),
                  fetchAnnouncements(courseId: courseId),
                  fetchFeatureFlags(courseId: courseId))
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetchColors() -> AnyPublisher<Void, Error> {
        fetchUseCase(GetCustomColors())
    }

    private func fetchCourse(courseId: String) -> AnyPublisher<Void, Error> {
        fetchUseCase(GetCourse(courseID: courseId))
    }

    private func fetchAnnouncements(courseId: String) -> AnyPublisher<Void, Error> {
        return ReactiveStore(useCase: GetAnnouncements(context: .course(courseId)))
            .getEntities(ignoreCache: true)
            .parseHtmlContent(attribute: \.message, id: \.id, courseId: courseId, baseURLKey: \.htmlURL, htmlParser: htmlParser)
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetchFeatureFlags(courseId: String) -> AnyPublisher<Void, Error> {
        fetchUseCase(GetEnabledFeatureFlags(context: .course(courseId)))
    }

    private func fetchUseCase<U: UseCase>(_ useCase: U) -> AnyPublisher<Void, Error> {
        ReactiveStore(useCase: useCase)
            .getEntities(ignoreCache: true)
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
}
