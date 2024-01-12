//
//  ExploreFilterView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-04.
//

import SwiftUI

struct ExploreFilterView: View {
    @Binding var isPresentingFilter: Bool
    @EnvironmentObject var viewModel: ExploreFilterViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("")) {
                    MultiSelector(
                        label: Text("Fields"),
                        options: Field.list(),
                        optionToString: { $0.text() },
                        selected: $viewModel.fields
                    )
                    Button("Clear") {
                        viewModel.resetFields()
                    }
                }
                Section(header: Text("")) {
                    MultiSelector(
                        label: Text("Languages"),
                        options: Language.list(),
                        optionToString: { $0.text() },
                        selected: $viewModel.languages
                    )
                    Button("Clear") {
                        viewModel.resetLanguages()
                    }
                }
            }
            .navigationTitle("Explore filters")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresentingFilter = false
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreFilterView(isPresentingFilter: .constant(true)).environmentObject({() -> ExploreFilterViewModel in
        return ExploreFilterViewModel()
    }())
}
