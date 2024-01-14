//
//  EditTopicView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-13.
//

import SwiftUI

struct EditTopicView: View {
    private enum FormTextField {
        case title, keywords, description, mood, maxTimeLength, priceHour, currency
    }
    
    @StateObject var viewModel: EditTopicViewModel
    @Binding var navigationPath: [ScreenNames]
    @FocusState private var focusedTextField: FormTextField?
    
    init(myProfile: UserProfile, topic: Topic?, navigationPath: Binding<[ScreenNames]>) {
        _viewModel = StateObject(wrappedValue: EditTopicViewModel(myProfile: myProfile, topic: topic))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        ZStack {
            Form {
                VStack(alignment: .leading) {
                    TextField("Title", text: $viewModel.title)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .focused($focusedTextField, equals: .title)
                        .onSubmit {
                            focusedTextField = .description
                    }
                    if let titleError = viewModel.titleError, !titleError.isEmpty {
                        CMErrorLabel(titleError)
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $viewModel.description)
                        .focused($focusedTextField, equals: .description)
                        .foregroundStyle(.primary)
                        .frame(height: 200)
                        .keyboardType(.alphabet)
                    
                    if let descriptionError = viewModel.descriptionError, !descriptionError.isEmpty {
                        CMErrorLabel(descriptionError)
                    }
                }
                
                Picker(selection: $viewModel.mood, label: Text("Category")) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        Text(mood.text()).tag(mood as Mood?)
                    }
                }
                .focused($focusedTextField, equals: .mood)
                
                
                Picker("Max session time", selection: $viewModel.topicLength) {
                    ForEach(TopicLengthChoice.list(), id: \.self) { choice in
                        Text(choice.text()).tag(choice as TopicLengthChoice?)
                    }
                }
                .focused($focusedTextField, equals: .maxTimeLength)
                
                Section("Price / hour") {
                    TextField("$", text: $viewModel.dollarPriceHour)
                        .keyboardType(.decimalPad)
                        .focused($focusedTextField, equals: .priceHour)
                    if let dollarPriceHourError = viewModel.dollarPriceHourError, !dollarPriceHourError.isEmpty {
                        CMErrorLabel(dollarPriceHourError)
                    }
                    
                    Picker("Currency", selection: $viewModel.currency) {
                        ForEach(Currency.list(), id: \.self) { choice in
                            Text(choice.text())
                                .tag(choice as Currency?)
                        }
                    }
                    .focused($focusedTextField, equals: .currency)
                }
                
                Section("Keywords") {
                    ForEach(Array(viewModel.keywords.enumerated()), id: \.offset) { index, keyword in
                        Text(keyword)
                            .font(.body)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.keywords.remove(at: index)
                                } label: {
                                    Label("Delete", systemImage: "xmark.bin")
                                }
                            }
                    }
                    
                    if let addKeywordError = viewModel.addKeywordError, !addKeywordError.isEmpty {
                        CMErrorLabel(addKeywordError)
                    }
                    
                    Button("Add keyword") {
                        viewModel.isShowingAddKeywordDialog = true
                    }
                }
                
                if viewModel.topic != nil {
                    Button("Delete topic") {
                        viewModel.isShowingDeleteTopicDialog = true
                    }
                    .foregroundStyle(.red)
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            Text("")
                .alert(isPresented: $viewModel.isShowingSubmissionErrorDialog) {
                    Alert(title: Text("Submission error"),
                          message: Text(viewModel.submissionError ?? ""),
                          dismissButton: .default(Text("Ok")))
                }
            
            Text("")
                .alert("Type a new keyword", isPresented: $viewModel.isShowingAddKeywordDialog) {
                    TextField("keyword", text: $viewModel.newKeyword)
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                    Button("Add") {
                        viewModel.handleAddNewKeyword()
                    }
                    Button("Cancel", role: .cancel) {
                        viewModel.handleCancelAddNewKeyword()
                    }
                }
            
            Text("")
                .alert("Delete this topic?", isPresented: $viewModel.isShowingDeleteTopicDialog) {
                    Button("Delete", role: .destructive) {
                        viewModel.handleDeleteTopic()
                    }
                    Button("Cancel", role: .cancel) {
                        
                    }
                }
        }
        .navigationTitle(viewModel.topic == nil ? "New topic" : "Edit topic")
        .toolbar() {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Save") {
                    viewModel.handleSaveButton()
                }
            }
        }
        .onChange(of: viewModel.submissionComplete) { submissionComplete in
            if submissionComplete {
                navigationPath.removeLast()
            }
        }
        .onAppear(){
            viewModel.initValues()
        }
    }
}

#Preview {
    ClickAPI.shared.apiKey = MockData.mockUser2().apiKey
    
    return NavigationView {
        EditTopicView(myProfile: MockData.mockProfile2(), topic: MockData.mockTopic(), navigationPath: .constant([]))
    }
}
