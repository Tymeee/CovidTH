//
//  DashboardView.swift
//  CovidApp2
//
//  Created by 18556 on 7/9/21.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var showOption = false
    
    @State private var covidData: CovidData?
    
    private var phoneCalls: [String] = ["1330", "1323", "1421", "1506", "1646", "1668", "1669"]
    
    private var govAgencies: [String] = ["สปสช.", "กรมสุขภาพจิต", "กรมควบคุมโรค", "สํานักงานประกันสังคม", "ศูนย์เอราวัณ", "สายด่วนโควิด", "สถาบันการแพทย์ฉุกเฉินแห่งชาติ"]
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        
        NavigationView{
            if #available(iOS 15.0, *) {
                
                List(){
                    
                    StatsView()
                        .listRowBackground(Color.clear)
                    
                    
                    Section(header:
                        Text("ยอดติดเชื้อรายจังหวัด 🇹🇭")
                    ){
                        ProvinceView()
                    }.headerProminence(.increased)
                    
                    
                    Section(header:
                        Text("รวมเบอร์สายด่วน")
                    ){
                        PhoneView()
                        
                    }.headerProminence(.increased)
                    
                        
                    
                    
                }
                .onAppear {
                    loadData()
                }
                .navigationBarTitle("Dashboard")
                
                .toolbar{
                    
                    
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                        
                        HStack(spacing: -10){
                            Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            Spacer()

                            Text("Update:\(covidData?.UpdateDate ?? "")")
                                .font(.caption)
                                .padding(.trailing)
                            
                            Button(action:{
                                loadData()
                            }, label:{
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(Color?(Color(red: 229/255, green: 56/255, blue: 59/255)))
                            })
                            
                            
                        }
                    }
                }
                
                .refreshable {
                    loadData()
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    //Fetch JSON data from URL
    public func loadData() {
        guard let url = URL(string: "https://static.easysunday.com/covid-19/getTodayCases.json") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            if let decodedData = try? JSONDecoder().decode(CovidData.self, from: data){
                DispatchQueue.main.async {
                    self.covidData = decodedData
                }
            }
        }.resume()
    }
}


extension Text {
    
    func DailyStatsStyle() -> some View {
        self
            .font(.system(size: 36))
            .fontWeight(.semibold)
            .animation(Animation.default)
    }
    
    func TotalStatsStyle() -> some View {
        self
            .font(.footnote)
            .fontWeight(.semibold)
            .animation(Animation.default)
    }
    
}

//JSON Data type
struct CovidData: Decodable {
    var Confirmed: Int
    var Recovered: Int
    var Hospitalized: Int
    var Deaths: Int
    var active: Int
    var NewConfirmed: Int
    var NewRecovered: Int
    var NewDeaths: Int
    var NewHospitalized: Int
    var UpdateDate: String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}