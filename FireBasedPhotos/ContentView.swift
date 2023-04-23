
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct ContentView: View {
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    
    var body: some View {
        VStack {
            selectedImageView
            
            Button {
                isPickerShowing = true
            } label: {
                Text("Select a Photo")
            }
            .buttonStyle(.bordered)
            uploadImageView
            
            Divider()
            ScrollView(.horizontal,showsIndicators: false) {
                HStack{
                    ForEach(retrievedImages,id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
        .sheet(isPresented: $isPickerShowing){
            ImagePicker(selectedImage: $selectedImage,isPickerShowing: $isPickerShowing)
        }
        .padding()
        .onAppear{
            retrievePhotos()
        }
        
     
    }
    
    var selectedImageView: some View{
        VStack {
            if  selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
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
    var uploadImageView: some View{
        VStack {
            if selectedImage != nil{
                Button {
                    uploadPhoto()
                    
                } label: {
                    Text("Upload photo")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView{
    func uploadPhoto(){
        guard let safeImage = selectedImage else {return}
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Turn image into data
        let imageData = safeImage.jpegData(compressionQuality: 0.6)
        guard let safeImageData = imageData else {return}
        
        let path = "images/\(UUID().uuidString).jpg"
        //file path and name
        let imageRef = storageRef.child(path)
        
        let uploadTask = imageRef.putData(safeImageData) { metadata, error in
            if error == nil && metadata != nil {
                
            }
            
            let db = Firestore.firestore()
            db.collection("images").document()
                .setData(["url":path]) { error in
                    guard error == nil else { return}
                    DispatchQueue.main.async {
                        retrievePhotos()
                    }
                }
        }
    }
    
    func retrievePhotos(){
        // Get the data from the database
        retrievedImages = []

        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in
            guard error == nil else { return}
            guard let safeSnapshot = snapshot else {return}
            var paths = [String]()
            
            for document in safeSnapshot.documents {
                // get the file path
                paths.append(document["url"] as! String)
            }
            
            for path in paths {
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(path)
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    guard error == nil else { return}
                    guard let safeData = data else {return}
                    
                    if let image = UIImage(data: safeData){
                        DispatchQueue.main.async {
                            retrievedImages.append(image)
                        }
                    }
                }
            }
        }
        
        // Get the image data in storage
        
        //Display images
    }
}
