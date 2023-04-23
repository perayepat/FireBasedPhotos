
import SwiftUI

struct ContentView: View {
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            selectedImageView
            
            Button {
                isPickerShowing = true
            } label: {
                Text("Select a Photo")
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $isPickerShowing){
            ImagePicker()
        }
        .padding()
    }
    
    var selectedImageView: some View{
        VStack {
            if  selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
            } else{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray.opacity(0.5))
                    .overlay {
                        Text("Please select a Image")
                            .foregroundColor(.primary)
                    }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
