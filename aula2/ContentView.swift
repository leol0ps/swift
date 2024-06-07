//
//  ContentView.swift
//  aula2
//
//  Created by Turma01-9 on 07/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var name: String = "name"
    var body: some View {
        ZStack{
            VStack{
                Text("Bem vind, \(name)")
                Spacer()
                TextField("name: ", text : $name)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                
                
                Spacer()
                
                Image(.rua)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
            }
            VStack{
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 100,height: 100)
                Image(.truck)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                
            }
            
            
                
        }
    }
}

#Preview {
    ContentView()
}
