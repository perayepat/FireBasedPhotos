
import SwiftUI

struct ContentView: View {
    @State var isPickerShowing = false
    
    var body: some View {
        VStack {
            Button {
                isPickerShowing = true
            } label: {
                Text("Select a Photo")
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $isPickerShowing){
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
