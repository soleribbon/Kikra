//
//  ContentView.swift
//  RaviHub
//
//  Created by Ravi  on 3/22/23.
//

import SwiftUI
import Focuser
import Drops


enum OrderType {
    case sale
    case wholesale
}



enum FormFieldsSale {
    case itemsSold, totalPrice, customerRef
}

enum FormFieldsWholesale {
    case storeName, productName, totalQuantity, totalPrice
}



struct AddView: View {
    
    @State private var orderType: OrderType = .sale
    
    @ObservedObject var salesSystem = SalesSystem()
    @EnvironmentObject var storeViewModel: StoreViewModel
    
    
    @State var showAlert = false
    
    
    @Environment(\.presentationMode) var presentationMode
    
    
    
    
    let saleDrop = Drop(
        title: "SALE ADDED",
        icon: UIImage(systemName: "checkmark"),
        position: .top,
        duration: 4.0,
        accessibility: "Alert: SALE ADDED"
    )
    
    let wholesaleDrop = Drop(
        title: "WHOLESALE ORDER ADDED",
        icon: UIImage(systemName: "checkmark"),
        position: .top,
        duration: 4.0,
        accessibility: "Alert: WHOLESALE ORDER ADDED"
    )
    


    

    
    @FocusStateLegacy var focusedSaleField: FormFieldsSale?
    
    @FocusStateLegacy var focusedWholesaleField: FormFieldsWholesale?

    
    
    var totalPriceString: Binding<String> {
        Binding<String>(
            get: {
                salesSystem.currentWholesaleOrder.totalPrice != nil ? salesSystem.currentWholesaleOrder.totalPrice! : ""
            },
            set: {
                salesSystem.currentWholesaleOrder.totalPrice = $0
            }
        )
    }
    
    
    
    
    
    var body: some View {
        VStack {
            
            Common.SubPageHeader(label: "New Transaction")
            
            Picker("Order Type", selection: $orderType) {
                Text("Sale")
                    .tag(OrderType.sale)
                    .font(Fonts.ibmSemiBold(size: 20))
                Text("Wholesale Order")
                    .tag(OrderType.wholesale)
                    .font(Fonts.ibmSemiBold(size: 20))
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if orderType == .sale {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Items Sold")
                                .textfieldLabelStyle()
                            
                            TextField("2 peaches", text: $salesSystem.currentSale.itemsSold)
                                .textFieldStyle(TappableTextFieldStyle())
                                .focusedLegacy($focusedSaleField, equals: .itemsSold)


                            
                            Text("Total Price")
                                .textfieldLabelStyle()
                            
                            TextField("100", text: $salesSystem.currentSale.totalPrice)
                                .textFieldStyle(TappableTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .focusedLegacy($focusedSaleField, equals: .totalPrice)
                               
                            
                            Text("Customer Ref.")
                                .textfieldLabelStyle()
                            
                            TextField("Friend of friend", text: $salesSystem.currentSale.customerRef)
                                .textFieldStyle(TappableTextFieldStyle())
                                .focusedLegacy($focusedSaleField, equals: .customerRef)
                            
                            HStack {
                                Picker("Payment Method", selection: $salesSystem.currentSale.paymentMethod) {
                                    Text("Cash").tag("Cash")
                                    Text("Revolut").tag("Revolut")
                                    Text("PayPal").tag("PayPal")
                                    Text("Other").tag("Other")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                
                                
                                DatePicker("", selection: $salesSystem.currentSale.date, displayedComponents: [.date])
                                    .datePickerStyle(.compact)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding()
                                
                                
                                
                                
                                
                                
                                
                            }
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        
                        
                        
                        
                    }
                    .padding()
                    
                }
                
            } else {
                
                //WHOLESALE ORDER SECTION
                ScrollView(showsIndicators: false){
                    VStack (alignment: .leading) {
                        Text("Store Name")
                            .textfieldLabelStyle()
                        
                        TextField("Nectars", text: $salesSystem.currentWholesaleOrder.storeName)
                            .textFieldStyle(TappableTextFieldStyle())
                            .focusedLegacy($focusedWholesaleField, equals: .storeName)
                        
                        Text("Product Name")
                            .textfieldLabelStyle()
                        
                        TextField("Peach Hush", text: $salesSystem.currentWholesaleOrder.itemName)
                            .textFieldStyle(TappableTextFieldStyle())
                            .focusedLegacy($focusedWholesaleField, equals: .productName)
                        
                        Text("Total Quantity")
                            .textfieldLabelStyle()
                        
                        
                        TextField("100", text: Binding<String>(
                            get: {
                                
                                salesSystem.currentWholesaleOrder.quantity != nil ? "\(salesSystem.currentWholesaleOrder.quantity!)" : "" },
                            set: {
                                salesSystem.currentWholesaleOrder.quantity = Int($0) }
                        ))
                        .textFieldStyle(TappableTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focusedLegacy($focusedWholesaleField, equals: .totalQuantity)
                        
                        
                        Text("Total Price")
                            .textfieldLabelStyle()
                        
                        
                        
                        
                        
                        TextField("100.00", text: totalPriceString)
                            .textFieldStyle(TappableTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .focusedLegacy($focusedWholesaleField, equals: .totalPrice)
                        
                        
                        
                        
                        Text("Date")
                            .textfieldLabelStyle()
                        
                        
                        DatePicker("", selection: $salesSystem.currentWholesaleOrder.date, displayedComponents: .date)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                            .font(Fonts.ibmSemiBold(size: 18))
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    
                }.padding()
                
                
            }
            
            
            Spacer()
            Button(action: {
                
                
                
                switch orderType {
                case .sale:
                    if
                        !salesSystem.currentSale.itemsSold.isEmpty &&
                            !salesSystem.currentSale.totalPrice.isEmpty && !salesSystem.currentSale.customerRef.isEmpty   {
                        
                        
                        storeViewModel.storedSales.append(salesSystem.currentSale)
                        storeViewModel.saveData()
                        
                        Drops.show(saleDrop)

                        StoreViewModel().successHaptic()
                        presentationMode.wrappedValue.dismiss()
                        
                        
                    }else{
                        print("Field missing")
                        StoreViewModel().errorHaptic()
                        showAlert = true // Show the alert
                        
                    }
                    
                    
                case .wholesale:
                    
                    
                    if !salesSystem.currentWholesaleOrder.storeName.isEmpty
                    {
                        
                        storeViewModel.storedWholesaleOrders.append(salesSystem.currentWholesaleOrder)
                        storeViewModel.saveData()
                        StoreViewModel().successHaptic()

                        Drops.show(wholesaleDrop)

                        presentationMode.wrappedValue.dismiss()
                        
                        
                        
                        
                    }else{
                        print("Field missing")
                        StoreViewModel().errorHaptic()
                        
                        showAlert = true // Show the alert
                        
                    }
                    
                    
                }
                
                
                
                
                
            }) {
                HStack {
                    Spacer()
                    Text("Add")
                        .font(Fonts.ibmSemiBold(size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    
                }
                .padding()
                .fontWeight(.bold)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .background(Color(red: 0.075, green: 0.075, blue: 0.075))
                .cornerRadius(50)
                
                
            }
            
            .padding(.horizontal, 20)
            
            Button(action: {
                StoreViewModel().errorHaptic()
                
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .font(Fonts.ibmSemiBold(size: 20))
                    Spacer()
                    
                }
                .padding()
                .fontWeight(.bold)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(50)
                
                
            }.padding(.horizontal, 20)
        }
        .alert(isPresented: $showAlert) { // Show the alert here
            Alert(
                title: Text("Error"),
                message: Text("All fields are required."),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
}




extension FormFieldsSale: FocusStateCompliant {

    static var last: FormFieldsSale {
        .customerRef
    }

    var next: FormFieldsSale? {
        switch self {
        case .itemsSold:
            return .totalPrice
        case .totalPrice:
            return .customerRef
        default: return nil
        }
    }
}

extension FormFieldsWholesale: FocusStateCompliant {

    static var last: FormFieldsWholesale {
        .totalPrice
    }

    var next: FormFieldsWholesale? {
        switch self {
        case .storeName:
            return .productName
        case .productName:
            return .totalQuantity
        case .totalQuantity:
            return .totalPrice
        default: return nil
        }
    }
}


struct TappableTextFieldStyle: TextFieldStyle {
    @FocusState private var textFieldFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
            .font(Fonts.ibmSemiBold(size: 18))
            .foregroundColor(.white)
            .focused($textFieldFocused)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(textFieldFocused ? Color.orange : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: textFieldFocused ? 0.18 : 0.0)), radius:5, x:0, y:1)
            .onTapGesture {
                textFieldFocused = true
            }
    }
}

extension View {
    func textfieldLabelStyle() -> some View {
        self
            .bold()
            .font(Fonts.ibmRegular(size: 16))
            .foregroundColor(.white)
    }
}







struct Previews_AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
