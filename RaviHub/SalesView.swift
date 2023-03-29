import SwiftUI

struct SalesView: View {
    @EnvironmentObject var storeViewModel: StoreViewModel
    
    @State private var showPredictionText = "Hide History"
    
    @State private var showPredictionView = true
    @State private var bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.56
    
    
    @Environment(\.colorScheme) var colorScheme

    

    
    var body: some View {
        ZStack {
            VStack {
                Common.SubPageHeader(label: "All Sales")
                
                Common.BigNumber(number: storeViewModel.calculateTotalRevenue(), label: "Total Revenue").foregroundColor(.green)
                
                
                HStack {
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
                ForEach(storeViewModel.storedSales.sorted(by: { $0.date.formatted() > $1.date.formatted() }), id: \.self) { sale in
                    
                    VStack (alignment: .leading){
                        
                        HStack {
                            
                            
                            //THIS VSTACK
                            VStack (alignment: .leading){
                                
                                
                                Text("\(sale.paymentMethod) | \(sale.date.formatted())")
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(red: 0.518, green: 0.518, blue: 0.518))
                                    .font(Font.custom("IBMPlexSansHebrew-Regular", size: 12))
                                
                                
                                
                                
                                
                                Text(sale.customerRef)
                                    .font(Font.custom("IBMPlexSansHebrew-Bold", size: 20))
                
                                    .foregroundColor(colorScheme == .dark ? Color(red: 0.824, green: 0.824, blue: 0.824) : Color(red: 0.267, green: 0.267, blue: 0.267))
                                
                                Text(sale.itemsSold)
                                    .font(Font.custom("IBMPlexSansHebrew-Regular", size: 16))
                                    .foregroundColor(colorScheme == .dark ? Color(red: 0.784, green: 0.784, blue: 0.784) : Color(red: 0.267, green: 0.267, blue: 0.267))
                                
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack{
                                if let totalPrice = sale.totalPrice {
                                    Text("+ $\(totalPrice)")
                                        .font(.custom("IBMPlexSansHebrew-Bold", size: 20))
                                        .foregroundColor(Color("KikraGreen"))
                                } else {
                                    Text("Price Error")
                                        .font(.custom("IBMPlexSansHebrew-Bold", size: 20))
                                        .foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.01, blue: 0.01, alpha: 1)))
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
                            if let index = storeViewModel.storedSales.firstIndex(of: sale) {
                                storeViewModel.storedSales.remove(at: index)
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


struct Previews_SalesView_Previews: PreviewProvider {
    static var previews: some View {
        SalesView().environmentObject(StoreViewModel())
    }
}
