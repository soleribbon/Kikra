//
//  ContentView.swift
//  RaviHub
//
//  Created by Ravi  on 3/22/23.
//

import SwiftUI





struct ContentView: View {
    
    @State private var showAddSaleModal = false
    @EnvironmentObject var storeViewModel: StoreViewModel
    

    
    var body: some View {
        NavigationStack {
            
            VStack {
                Common.HeaderView()
                
                Spacer()
                
                //profit section
                Common.BigNumber(number: storeViewModel.calculateProfit(), label: "Total Profit")
                Spacer()
                
                // Sales section
                
                NavigationLink(destination: SalesView(), label: {
                    
                    HStack{
                        VStack{
                            Text("Sales")
                                .fontWeight(.bold)
                                .font(Fonts.ibmSemiBold(size: 26))
                            
                            Spacer()
                        }.padding()
                        Spacer()
                        Text("\(storeViewModel.calculateNumberOfSalesAndWholesale().0)")
                            .fontWeight(.bold)
                            .font(Fonts.ibmBold(size: 60))
                        Spacer().frame(width: 50)
                    }
                    .foregroundColor(.white)
                    .background(Color("KikraGreen"))
                    .cornerRadius(2)
                    .padding(20)
                    
                })
                
                
                // Wholesale Orders section
                
                
                NavigationLink(destination: WholesaleOrdersView(), label: {
                    
                    HStack{
                        VStack{
                            Text("Wholesale Orders")
                                .fontWeight(.bold)
                                .font(Fonts.ibmSemiBold(size: 26))
                                .fontWeight(.bold)
                            
                            Spacer()
                        }.padding()
                        Spacer()
                        
                        Text("\(storeViewModel.calculateNumberOfSalesAndWholesale().1)")
                            .fontWeight(.bold)
                            .font(Fonts.ibmBold(size: 60))
                        
                        Spacer().frame(width: 50)
                    }
                    .foregroundColor(.white)
                    .background(Color("KikraOrange"))
                    .cornerRadius(2)
                    .padding(20)
                    
                })
                
                
                
                
                
                Spacer()
                Button(action: {
                    StoreViewModel().selectionHaptic()
                    showAddSaleModal.toggle()
                    
                }) {
                    HStack {
                        Spacer()
                        Text("+ Sale / Order")
                            .font(Fonts.ibmBold(size: 20))
                        Spacer()
                        
                    }
                    .padding()
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .background(Color(red: 0.075, green: 0.075, blue: 0.075))
                    .cornerRadius(50)
                    
                    
                }.padding(20)
                
            }
        }.fullScreenCover(isPresented: $showAddSaleModal){
            AddView()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
