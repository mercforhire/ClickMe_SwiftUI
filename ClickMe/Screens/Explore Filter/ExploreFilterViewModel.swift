//
//  ExploreFilterViewModel.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import Foundation

final class ExploreFilterViewModel: ObservableObject, Equatable {
    @Published var fields: Set<Field> = []
    @Published var languages: Set<Language> = []
    
    static func == (lhs: ExploreFilterViewModel, rhs: ExploreFilterViewModel) -> Bool {
        return lhs.fields == rhs.fields && lhs.languages == rhs.languages
    }
    
    func resetFields() {
        fields.removeAll()
    }
    
    func resetLanguages() {
        languages.removeAll()
    }
    
    func toExploreUsersParams() -> ExploreUsersParams {
        var params = ExploreUsersParams()
        
        if !fields.isEmpty {
            params.fields = []
            params.fields?.append(contentsOf: fields)
        }
        
        if !languages.isEmpty {
            params.languages = []
            params.languages?.append(contentsOf: languages)
        }
        
        return params
    }
}
