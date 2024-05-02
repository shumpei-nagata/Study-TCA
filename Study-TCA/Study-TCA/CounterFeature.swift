//
//  CounterFeature.swift
//  Study-TCA
//
//  Created by Shumpei Nagata on 2024/05/02.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    enum Action {
        case decrementButtonTapped
        case factButtonTapped
        case incrementButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                let (data, _) = try await URLSession.shared
                          .data(from: URL(string: "http://numbersapi.com/\(state.count)")!)
                // 🛑 'async' call in a function that does not support concurrency
                // 🛑 Errors thrown from here are not handled
                
                state.fact = String(decoding: data, as: UTF8.self)
                state.isLoading = false
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}

struct CounterView: View {
  let store: StoreOf<CounterFeature>
  
  var body: some View {
    VStack {
      Text("\(store.count)")
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      HStack {
        Button("-") {
          store.send(.decrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
        
        Button("+") {
          store.send(.incrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      }
        
        Button("Fact") {
                store.send(.factButtonTapped)
              }
              .font(.largeTitle)
              .padding()
              .background(Color.black.opacity(0.1))
              .cornerRadius(10)
        
        if store.isLoading {
                ProgressView()
              } else if let fact = store.fact {
                Text(fact)
                  .font(.largeTitle)
                  .multilineTextAlignment(.center)
                  .padding()
              }
    }
  }
}

#Preview {
    let store = Store(initialState: .init()) {
        CounterFeature()
    }
    return CounterView(store: store)
}
