//
//  GetStartedView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct GetStartedView: View {
    @StateObject var viewModel = GetStartedViewModel()
    
    var body: some View {
        ZStack(content: {
            Image("background", bundle: nil)
                .resizable()
                .ignoresSafeArea()
            VStack() {
                Spacer()
                TabView(selection: $viewModel.tabSelection) {
                    ForEach(viewModel.getStartedSteps) { step in
                        GetStartedStepView(step: step)
                            .frame(width: UIScreen.main.bounds.size.width)
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
                        .padding(.bottom, 20)
                }
            }
        })
        
    }
}

#Preview {
    GetStartedView()
}

struct GetStartedStepView: View {
    var step: GetStartedSteps
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(step.imageName(), bundle: nil)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity, height: 300)
            Text(step.title())
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(step.body())
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
    }
}
