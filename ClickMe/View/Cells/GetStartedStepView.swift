//
//  GetStartedStepView.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-01.
//

import SwiftUI

struct GetStartedStepView: View {
    @State var step: GetStartedSteps
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(step.imageName(), bundle: nil)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth, height: 300)
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

#Preview {
    GetStartedStepView(step: .one)
}
