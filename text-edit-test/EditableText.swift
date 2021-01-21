//
//  EditableText.swift
//  sequence-editor
//
//  Created by david silver on 1/20/21.
//

import SwiftUI

let Ux_Notification_FocusChange = NSNotification.Name(rawValue: "I got focus, so you let go of it now!")
let kFrom = "From"
let kTo   = "To"
let kNull = ""

/*
 * start of a set of controls to "edit in place". This is a text view, overlaid with a TextField when the text is tapped. When
 */
struct EditableText: View {
    
    @Binding       var theText: String                // the text to edit, bound to the parent
    
    @State private var editMode         = false                 // which mode we are in
                   var id               = UUID().uuidString     // unique ID for focus changing. The parent can set this if desired
                   var nextTab          = kNull                 // where to tab to, this is a constant, so should not take up loads of space as it will be reused
                   var maxWidth:CGFloat = 0.0
    
    /*
     * the view.
     *
     * the Group is used as we need *something* to pin the .onReceive() to.
     */
    var body: some View {
        
        Group() {
            if editMode {
                // edit mode so replace the text view with the text field
                //
                TextField( theText, text: $theText,
                    onEditingChanged: { editingChanged in
                        if editingChanged == false {
                            
                            // no longer editing. This is NOT the same as losing focus.  Simply tapping on another view does not cause this to trigger
                            //
                            self.editMode = false                                                                                           // 1. change our edit mode
                            NotificationCenter.default.post(name: Ux_Notification_FocusChange, object: [kFrom:self.id, kTo:self.nextTab] )  // 2. let anyone else know.
                                                                                                                                            //    Might use optional closure instead (.saveConfirmed
                        }
                    },
                    onCommit: {
                        // the return key got tapped (NOT the tab key
                        //
                        self.editMode = false
                })
                    .frame( minWidth: 0, maxWidth: self.maxWidth > 0.0 ?self.maxWidth : .infinity )
            }
            else {
                Text( theText )
                    .onTapGesture {
                        
                        // put this control into edit mode, and tell any other control to lose "focus".
                        //
                        self.editMode = true
                        NotificationCenter.default.post(name: Ux_Notification_FocusChange, object: [kFrom:self.id, kTo:self.id] )
                    }
                    .frame( minWidth: 0, maxWidth: self.maxWidth > 0.0 ?self.maxWidth : .infinity )
            }
        }
        .onReceive( NotificationCenter.default.publisher( for: Ux_Notification_FocusChange) ) { msg in
            
            // focus change either to or from the control. The first "if" should not be nessacary but it's safer.
            //
            if let dict = msg.object as? [String:String] {
                
                // if this did not come from this control, then put the control back into display mode
                //
                if dict[kFrom] != self.id && self.editMode {
                    self.editMode = false
                }
                
                //  if this is a transfer, then put the contrrol into edit mode
                //
                if dict[kTo] == self.id && self.editMode == false {
                    self.editMode = true
                }
            }
        }
    }
}


//struct ContentView: View {
//    @State var location: String = ""
//
//    var body: some View {
//        let binding = Binding<String>(get: {
//            self.location
//        }, set: {
//            self.location = $0
//            // do whatever you want here
//        })
//
//        return VStack {
//            Text("Current location: \(location)")
//            TextField("Search Location", text: binding)
//        }
//
//    }
//}
