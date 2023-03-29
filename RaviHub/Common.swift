//
//  Common.swift
//  RaviHub
//
//  Created by Ravi  on 3/23/23.
//

import SwiftUI

struct Sale: Hashable, Codable {
    var itemsSold: String = ""
    var totalPrice: String = ""
    var customerRef: String = ""
    var paymentMethod: String = "Cash"
    var date: Date = Date()
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemsSold)
        hasher.combine(totalPrice)
        hasher.combine(customerRef)
        hasher.combine(paymentMethod)
    }
}

struct WholesaleOrder: Hashable, Codable {
    var storeName: String = ""
    var itemName: String = ""
    var quantity: Int? = nil
    var totalPrice: String? = ""
    var date: Date = Date()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(storeName)
        hasher.combine(itemName)
        hasher.combine(quantity)
        hasher.combine(totalPrice)
    }
}

class SalesSystem: ObservableObject {
    @Published var currentSale = Sale()
    @Published var currentWholesaleOrder = WholesaleOrder()

}

class StoreViewModel: ObservableObject {
    @Published var storedSales: [Sale] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var storedWholesaleOrders: [WholesaleOrder] = [] {
        didSet {
            saveData()
        }
    }
    
    
    
    init() {
        loadData()
    }
    
    func calculateTotalSpent() -> String {
        let total = storedWholesaleOrders.reduce(0) { result, order in
            if let price = Double(order.totalPrice ?? "0") {
                return result + price
            } else {
                return result
            }
        }
        return String(format: "$%.2f", total)
    }
    
    func calculateTotalRevenue() -> String {
        let total = storedSales.reduce(0) { result, sale in
            if let price = Double(sale.totalPrice) {
                return result + price
            } else {
                return result
            }
        }
        return String(format: "$%.2f", total)
    }
    
    func calculateProfit() -> String {
        let totalRevenue = Double(calculateTotalRevenue().replacingOccurrences(of: "$", with: "")) ?? 0
        let totalSpent = Double(calculateTotalSpent().replacingOccurrences(of: "$", with: "")) ?? 0
        let profit = totalRevenue - totalSpent
        
        return String(format: "$%.2f", profit)
    }
    
    func calculateNumberOfSalesAndWholesale() -> (Int, Int) {
        let numberOfSales = storedSales.count
        let numberOfWholesale = storedWholesaleOrders.count
        return (numberOfSales, numberOfWholesale)
    }
    
    
    func successHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    func errorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    func selectionHaptic() {
        let selection = UIImpactFeedbackGenerator(style: .medium)
        selection.impactOccurred()
    }
    
    
    
    
    func saveData() {
        let wholesaleOrdersData = try? JSONEncoder().encode(storedWholesaleOrders)
        let salesData = try? JSONEncoder().encode(storedSales)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let wholesaleOrdersFileURL = documentsDirectory.appendingPathComponent("wholesaleOrders.json")
        let salesFileURL = documentsDirectory.appendingPathComponent("sales.json")
        do {
            try wholesaleOrdersData?.write(to: wholesaleOrdersFileURL)
            try salesData?.write(to: salesFileURL)
        } catch {
            print(error)
        }
    }
    
    
    func loadData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let wholesaleOrdersFileURL = documentsDirectory.appendingPathComponent("wholesaleOrders.json")
        let salesFileURL = documentsDirectory.appendingPathComponent("sales.json")
        print("Documents Directory Path: \(documentsDirectory.absoluteString)")

        do {
            
            let wholesaleOrdersData = try Data(contentsOf: wholesaleOrdersFileURL)
            let salesData = try Data(contentsOf: salesFileURL)
            storedWholesaleOrders = try JSONDecoder().decode([WholesaleOrder].self, from: wholesaleOrdersData)
            storedSales = try JSONDecoder().decode([Sale].self, from: salesData)
            print("load data run...fixing needed")
        } catch {
            print(error)
        }
    }
    
    
}




struct Common {
    
    
    struct HeaderView: View {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        
        var body: some View {
            HStack{
                Text("Kikra")
                    .fontWeight(.bold)
                    .font(Font.custom("IBMPlexSansHebrew-Bold", size: 50))
                
                Spacer()
                VStack (alignment: .trailing){
                    Text("VITO SOFTWARE")
                    if let version = appVersion {
                        Text("v\(version).0")
                        
                        
                    } else {
                        Text("v1.1")
                        
                        
                    }
                    
                }
                .font(Font.custom("IBMPlexSansHebrew-Regular", size: 12))
                .foregroundColor(.gray)
                
                
            }.padding()
        }
    }
    
    struct SubPageHeader: View {
        var label: String
        
        var body: some View {
            HStack{
                Text(label)
                    .fontWeight(.bold)
                    .font(Font.custom("IBMPlexSansHebrew-Bold", size: 30))
                
                Spacer()
                
            }
            .padding(.top)
            .padding(.horizontal)
        }
    }
    
    
    struct BigNumber: View {
        var number: String
        var label: String
        
        var body: some View {
            HStack {
                VStack (alignment: .leading){
                    Text(number)
                        .fontWeight(.bold)
                        .font(Font.custom("IBMPlexSansHebrew-Bold", size: 60))
                    Text(label)
                        .foregroundColor(.gray)
                        .font(Font.custom("IBMPlexSansHebrew-Regular", size: 20))
                    
                }
                Spacer()
            }.padding(.horizontal, 20)
        }
    }
    
    
    struct TextFieldView: View {
        var label: String
        var placeholder: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.headline)
                TextField(placeholder, text: $text)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
            }
        }
    }
    
    
    struct PrimaryButton: View {
        var label: String
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(label)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
        }
    }
    
    
    
    
    
    
    struct CommonView: View {
        var body: some View {
            VStack {
                Common.HeaderView()
                
            }
        }
    }
}



//struct CommonView_Previews: PreviewProvider {
//    static var previews: some View {
//        Common.CommonView()
//        Common.SubPageHeader(label: "Wholesale Orders")
//    }
//}

