import SwiftUI
import SwiftUICharts
import Foundation


struct PredictionView: View {
    let storedSales = StoreViewModel().storedSales
    @EnvironmentObject var storeViewModel: StoreViewModel

    
    @State private var selectedDateRange = "This Year"
    @State private var chartData: [(String, Double)] = []
    
    private let dateRanges = ["Last 3 Days", "Last 7 Days", "Last 30 Days", "This Year"]
    
    let chartStyle = ChartStyle(backgroundColor: Color.clear, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.black, legendTextColor: Color.black, dropShadowColor: Color.clear)
    
    
    
    
    var body: some View {
        VStack {
            
            
            VStack {
                
                let predictedRevenue = predictNextMonthsRevenue()
                
                HStack {
                    Spacer()
                    Text("Possible Revenue Next Month: ")
                        .font(.headline)
                    +
                    Text((predictedRevenue == 0 || predictedRevenue.isNaN) ? "More data needed" : "$\(predictedRevenue, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(10)
                .background(Color("KikraGreen"))
                .cornerRadius(2)
                .foregroundColor(.white)

                
                
                
                Picker("Date Range", selection: $selectedDateRange) {
                    ForEach(dateRanges, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedDateRange) { _ in
                    chartData = getChartData(for: selectedDateRange)
                    StoreViewModel().selectionHaptic()
                }
                
                
                
                if chartData.count > 0 {
                    //                BarChartView(data: ChartData(values: chartData), title: "Revenue History", style: chartStyle, form: ChartForm.extraLarge,  valueSpecifier: "$%.2f")
                    
                    
                    
                    
                    
                    
                    let lineChartDataWithPrediction = getLineChartDataWithPrediction()
                    
                    
                    BarChartView(data: ChartData(values: lineChartDataWithPrediction), title: "Revenue History", style: chartStyle, form: ChartForm.extraLarge, dropShadow: false,  cornerImage:Image(systemName: "dollarsign.arrow.circlepath"), valueSpecifier: "$%.2f", animatedToBack: true).padding(0)
                    
                    
                } else {
                    Text("No data to display.")
                }
            }
            .onAppear {
                chartData = getChartData(for: selectedDateRange)

                
                
            }
        }
    }
    
    func predictNextMonthsRevenue() -> Double {
        // Prepare the data for linear regression
        let salesCount = Double(chartData.count)
        let sumX = salesCount * (salesCount + 1) / 2
        let sumY = chartData.reduce(0) { $0 + $1.1 }
        let sumXY = chartData.enumerated().reduce(0) { $0 + Double($1.offset + 1) * $1.element.1 }
        let sumX2 = salesCount * (salesCount + 1) * (2 * salesCount + 1) / 6
        
        // Calculate the slope and intercept
        let slope = (salesCount * sumXY - sumX * sumY) / (salesCount * sumX2 - sumX * sumX)
        let intercept = (sumY - slope * sumX) / salesCount
        
        // Predict the revenue for next month
        let nextMonth = salesCount + 1
        let predictedRevenue = intercept + slope * nextMonth
        
        return predictedRevenue
    }
    
    func getLineChartDataWithPrediction() -> [(String, Double)] {
        var lineChartData: [(String, Double)] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        for data in chartData {
            lineChartData.append((dateFormatter.string(from: dateFormatter.date(from: data.0)!), data.1))
        }
        
        //        let predictedRevenue = predictNextMonthsRevenue()
        //        lineChartData.append(("Next Month", predictedRevenue))
        
        return lineChartData
    }

    
    func getChartData(for dateRange: String) -> [(String, Double)] {
        var chartData: [(String, Double)] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let today = Date()
        var startDate: Date?
        
        switch dateRange {
        case "Last 3 Days":
            startDate = Calendar.current.date(byAdding: .day, value: -3, to: today)
        case "Last 7 Days":
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: today)
        case "Last 30 Days":
            startDate = Calendar.current.date(byAdding: .day, value: -30, to: today)
        case "This Year":
            startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: today))
        default:
            startDate = nil
        }
        
        if let startDate = startDate {
            for sale in storedSales {
                if sale.date >= startDate {
                    if let totalPrice = Double(sale.totalPrice) {
                        let dateString = dateFormatter.string(from: sale.date)
                        chartData.append((dateString, totalPrice))
                    }
                }
            }
        }
        
        return chartData
    }
}

struct Previews_PredictionView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionView()
    }
}
