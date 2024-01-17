//
//  GetStartedView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct GetStartedView: View {
    @StateObject var viewModel = GetStartedViewModel()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let padding: CGFloat = 40
    
    var body: some View {
        if viewModel.shouldGoToNextScreen {
            LoginInitialView()
                .transition(.slide)
        } else {
            ZStack(content: {
                Image("background", bundle: nil)
                    .resizable()
                    .ignoresSafeArea()
                VStack() {
                    Spacer()
                    TabView(selection: $viewModel.tabSelection) {
                        ForEach(viewModel.getStartedSteps) { step in
                            GetStartedStepView(step: step)
                                .frame(width: screenWidth)
                                .tag(step.rawValue)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    // https://stackoverflow.com/questions/61827496/swiftui-how-to-animate-a-tabview-selection
                    .animation(.easeOut(duration: 0.2), value: viewModel.tabSelection)
                    Spacer()
                    Button {
                        viewModel.goToNextSlide()
                    } label: {
                        CMButton(title: "Next")
                    }
                    .padding(.bottom, 20)
                }
            })
        }
    }
}

#Preview {
    GetStartedView()
}
