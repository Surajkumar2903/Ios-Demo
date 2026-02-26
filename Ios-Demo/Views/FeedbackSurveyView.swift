//
//  FeedbackSurveyView.swift
//  Ios-Demo
//
//  Created by Suraj Kumar
//

import SwiftUI

struct FeedbackSurveyView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var answers: [String?] = Array(repeating: nil, count: 4)
    @State private var currentPage = 0
    
    // We measure content height dynamically per page
    @State private var pageHeights: [Int: CGFloat] = [:]
    
    var currentHeight: CGFloat {
        pageHeights[currentPage] ?? 480
    }
    
    let questions = [
        SurveyQuestion(title: "Why are you leaving?", options: [
            "I found better pricing somewhere else",
            "I can't find my flight details",
            "I'm facing some issue booking/using the app",
            "My plan got changed"
        ]),
        SurveyQuestion(title: "What was the main problem?", options: [
            "App is too slow / crashes",
            "Confusing interface / hard to navigate",
            "Missing features I need",
            "Bad customer support experience"
        ]),
        SurveyQuestion(title: "How would you rate your experience?", options: [
            "Very poor 😞",
            "Poor 😕",
            "Okay 🤔",
            "Good 🙂",
            "Excellent 🔥"
        ]),
        SurveyQuestion(title: "Anything else you'd like to tell us?", options: [
            "Voice recording feedback (tap to record)",
            "I'll write a short message later",
            "No – nothing more"
        ])
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 20)
                .padding(.top, 12)
            }
            
            // ── TabView ──
            TabView(selection: $currentPage) {
                ForEach(Array(questions.enumerated()), id: \.offset) { index, question in
                    questionView(for: question, at: index)
                        .tag(index)
                        // Measure height per page
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: PageHeightKey.self, value: geo.size.height)
                                    .onPreferenceChange(PageHeightKey.self) { height in
                                        pageHeights[index] = height + 60  // padding/buffer
                                    }
                            }
                        )
                        // Block forward swipe gesture per page (right-to-left = forward)
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged { value in
                                    // value.translation.width < 0 → user trying to swipe LEFT (forward/next)
                                    if value.translation.width < -30 && answers[index] == nil {
                                        // Do nothing → gesture gets consumed → blocks TabView scroll
                                    }
                                }
                        )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.orange
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.4)
            }
            .onDisappear {
                UIPageControl.appearance().currentPageIndicatorTintColor = nil
                UIPageControl.appearance().pageIndicatorTintColor = nil
            }
            .padding(.horizontal, 16)
            
            // Bottom buttons
            if currentPage < questions.count - 1 {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                } label: {
                    Text("Next")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(answers[currentPage] != nil ? Color.orange : .gray.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(answers[currentPage] == nil)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            } else {
                Button {
                    print("Submitted answers:", answers)
                    dismiss()
                } label: {
                    Text("Submit Feedback")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(answers.allSatisfy { $0 != nil } ? Color.orange : .gray.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(answers.contains { $0 == nil })
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        // Dynamic sheet height based on current page
        .presentationDetents([.height(currentHeight)])
        .presentationDragIndicator(.hidden)
        .interactiveDismissDisabled(true)
        .presentationCornerRadius(28)
        .presentationBackground(.regularMaterial)
    }
    
    @ViewBuilder
    private func questionView(for question: SurveyQuestion, at index: Int) -> some View {
        VStack(spacing: 20) {
            Text(question.title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            
            Text("This will help us improve your experience.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                ForEach(question.options, id: \.self) { option in
                    OptionRow(
                        option: option,
                        isSelected: answers[index] == option,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                answers[index] = option
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 4)
            
            Spacer(minLength: 40)
        }
        .padding(.top, 12)
    }
}

// ── OptionRow (fixed overlay syntax for iOS 14 compatibility) ──
struct OptionRow: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Circle()
                .strokeBorder(isSelected ? Color.orange : .gray.opacity(0.5), lineWidth: 2.2)
                .frame(width: 26, height: 26)
                .overlay {
                    if isSelected {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 16)
                    }
                }
            
            Text(option)
                .font(.body)
                .foregroundStyle(isSelected ? .primary : Color(.gray
                                                              ))
            
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6).opacity(0.7))
        )
        .overlay(   // parentheses version - works on iOS 14
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.orange.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// Models & Keys
struct SurveyQuestion {
    let title: String
    let options: [String]
}

private struct PageHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Preview
#Preview {
    FeedbackSurveyView()
}
