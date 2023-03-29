import SwiftUI



struct WholesaleOrdersView: View {
    @EnvironmentObject var storeViewModel: StoreViewModel
    @State private var showPredictionText = "Hide History"
    @State private var showPredictionView = true
    @State private var bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.56
    
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        
        
        ZStack {
            VStack {
                Common.SubPageHeader(label: "All Wholesale Orders")
                
                Common.BigNumber(number: storeViewModel.calculateTotalSpent(), label: "Total Spent").foregroundColor(.red)
                
                
                HStack{
                    Spacer()
                    Button(action: {
                        StoreViewModel().selectionHaptic()
                        
                        
                        
                        withAnimation(.easeInOut(duration: 0.15)) {
                            showPredictionView.toggle()
                            bottomSheetHeight = showPredictionView ? UIScreen.main.bounds.height * 0.56 : 0
                            showPredictionText = showPredictionView ? "Hide History" : "Show History"
                        }
                    }, label: {
                        HStack {
                            if showPredictionView {
                                Image(systemName: "eye.slash")
                                    .foregroundColor(.primary)
                            } else {
                                Image(systemName: "note.text")
                                    .foregroundColor(.primary)
                            }
                            
                            Text(showPredictionText)
                                .font(Font.custom("IBMPlexSansHebrew-SemiBold", size: 14))
                                .foregroundColor(.primary)
                            
                        }
                        
                        
                        
                    })
                }.padding(.horizontal, 20)
                
                
                PredictionView()
                Spacer()
                
            }.onAppear{
                storeViewModel.loadData()
            }
            
            
            if showPredictionView {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
                    .onTapGesture {
                        withAnimation {
                            showPredictionView.toggle()
                            bottomSheetHeight = 0
                            showPredictionText = "Show History"
                        }
                    }
            }
            
            
            
            
            
            
            VStack {
                Spacer()
                Group {
                    if showPredictionView {
                        bottomSheetContent
                    }
                }
                .frame(height: bottomSheetHeight)
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    var bottomSheetContent: some View {
        

        VStack {
            Spacer()
            ScrollView (showsIndicators: false){
                
                
                
                
                ForEach(storeViewModel.storedWholesaleOrders.sorted(by: { $0.date.formatted() > $1.date.formatted() }), id: \.self) { wholesale in
                    
                    VStack (alignment: .leading){
                        
                        HStack {
                            
                            
                            //THIS VSTACK
                            VStack (alignment: .leading){
                                
                                
                                Text("\(wholesale.quantity ?? 000)  | \(wholesale.date.formatted())")
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(red: 0.518, green: 0.518, blue: 0.518))
                                    .font(Font.custom("IBMPlexSansHebrew-Regular", size: 12))
                                
                                
                                
                                
                                
                                Text(wholesale.storeName)
                                    .font(Font.custom("IBMPlexSansHebrew-Bold", size: 20))
                                    .foregroundColor(colorScheme == .dark ? Color(red: 0.824, green: 0.824, blue: 0.824) : Color(red: 0.267, green: 0.267, blue: 0.267))
                                                                                     
                                Text(wholesale.itemName)
                                    .font(Font.custom("IBMPlexSansHebrew-Regular", size: 16))
                                    .foregroundColor(colorScheme == .dark ? Color(red: 0.784, green: 0.784, blue: 0.784) : Color(red: 0.267, green: 0.267, blue: 0.267))

                                                     
                                                     
                                                     
                                                     }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                     
                                                     VStack{
                                        if let totalPrice = wholesale.totalPrice {
                                            Text("- $\(totalPrice)")
                                                .font(.custom("IBMPlexSansHebrew-Bold", size: 20))
                                                .foregroundColor(Color(red: 0.541, green: 0.008, blue: 0.008))
                                        } else {
                                            Text("Price Error")
                                                .font(.custom("IBMPlexSansHebrew-Bold", size: 20))
                                                .foregroundColor(Color(red: 0.541, green: 0.008, blue: 0.008))
                                        }
                                    }
                                        .frame(maxWidth: 150, alignment: .trailing)
                                                     } //HStack
                                                     
                                                     }
                                        .padding()
                                        .frame(width: UIScreen.main.bounds.width - 20)
                                        .background(colorScheme == .dark ? Color(red: 0.075, green: 0.075, blue: 0.075) : Color(red: 0.929, green: 0.929, blue: 0.929))
                                                     
                                        .cornerRadius(2)
                                        .contextMenu {
                                            Button(action: {
                                                if let index = storeViewModel.storedWholesaleOrders.firstIndex(of: wholesale) {
                                                    storeViewModel.storedWholesaleOrders.remove(at: index)
                                                }
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                                     
                                                     
                                                     }
                                                     }
                                                     
                                                     
                                                     }        .background(colorScheme == .dark ? Color.black : Color.white)
                                                     
                                                     
                                                     }
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     }
                                                     
                                                     
                                                    
