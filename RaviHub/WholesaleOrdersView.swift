import SwiftUI

struct WholesaleOrdersView: View {
    @EnvironmentObject var storeViewModel: StoreViewModel
    
    
    var body: some View {
        VStack {
            Common.SubPageHeader(label: "All Wholesale Orders")
            
            Common.BigNumber(number: storeViewModel.calculateTotalSpent(), label: "Total Spent").foregroundColor(.red)
            Spacer()
            
            
            
            
            ScrollView (showsIndicators: false){
                
                
                
                ForEach(storeViewModel.storedWholesaleOrders.sorted(by: { $0.date.formatted() > $1.date.formatted() }), id: \.self) { wholesale in
                    
                    VStack (alignment: .leading){
                        
                        HStack {
                            
                            
                            //THIS VSTACK
                            VStack (alignment: .leading){
                                
                                if let quantity = wholesale.quantity {
                                    Text("\(quantity) ITEMS | \(wholesale.date.formatted())")
                                        .textCase(.uppercase)
                                        .foregroundColor(Color(red: 0.518, green: 0.518, blue: 0.518))
                                        .font(Font.custom("IBMPlexSansHebrew-Regular", size: 12))
                                } else {
                                    Text("Unknown Quantity | \(wholesale.date.formatted())")
                                        .textCase(.uppercase)
                                        .foregroundColor(Color(red: 0.518, green: 0.518, blue: 0.518))
                                        .font(Font.custom("IBMPlexSansHebrew-Regular", size: 12))
                                }
                                
                                
                                Text(wholesale.storeName)
                                    .font(Font.custom("IBMPlexSansHebrew-Bold", size: 20))
                                    .foregroundColor(Color(red: 0.267, green: 0.267, blue: 0.267))
                                
                                Text(wholesale.itemName)
                                    .font(Font.custom("IBMPlexSansHebrew-Regular", size: 16))
                                    .foregroundColor(Color(red: 0.267, green: 0.267, blue: 0.267))
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack{
                                if let totalPrice = wholesale.totalPrice {
                                    Text("- $\(totalPrice)")
                                        .font(.custom("IBMPlexSansHebrew-Bold", size: 20))
                                        .foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.01, blue: 0.01, alpha: 1)))
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
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color(red: 0.929, green: 0.929, blue: 0.929))
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
            Spacer()
        }.onAppear{
            storeViewModel.loadData()
        }
    }
}


