import SwiftUI

struct PagerManager<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    //Set the initial values for the variables
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    //Set the animation
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)

                
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}

struct ContentView: View {
    @State private var currentPage = 0
    
    var body: some View {
        
        //Pager Manager
        VStack{
            PagerManager(pageCount: 2, currentIndex: $currentPage) {
                Text("First page")
                Text("Second page")
            }
            
            Spacer()
            
            //Page Control
            HStack{
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPage==1 ? Color.gray:Color.white)
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPage==1 ? Color.white:Color.gray)
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
