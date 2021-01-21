//
//  ContentView.swift
//  text-edit-test
//
//  Created by david silver on 1/20/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var testText1  = "Hello"
    @State private var testText2  = "Hello"
    @State private var showEditor = true
    @State private var normalText = "Monkey"
    
    var body: some View {
        
        VStack {
            Button(action: { self.showEditor = (self.showEditor == false )} , label: {
                Text("Switch")
            })
            
            HStack {
                Text( "Hello you sexy thing" )
                if showEditor {
                    VStack {
                        Text("Editable below") .padding() .overlay( RoundedRectangle(cornerRadius: 10) .stroke(Color.black, lineWidth: 2) )
                        
                        EditableText( theText:$testText1, id:"poop",   nextTab:"Monkey" )                .padding() .overlay( RoundedRectangle(cornerRadius: 10) .stroke(Color.black, lineWidth: 2) )
                        EditableText( theText:$testText2, id:"Monkey", nextTab:"poop",   maxWidth: 100 ) .padding() .overlay( RoundedRectangle(cornerRadius: 10) .stroke(Color.black, lineWidth: 2) )
                        TextField( normalText, text:$normalText ) .padding() .overlay( RoundedRectangle(cornerRadius: 10) .stroke(Color.black, lineWidth: 2) )
                            .keyboardType( .default )
                    }
                }
                else {
                    Text("Second Screen")
                }
                RoundedRectangle(cornerRadius: 10) .frame(width: 120, height: 220, alignment: .center) .foregroundColor(.red)
            }
            Text( "And another control" )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
