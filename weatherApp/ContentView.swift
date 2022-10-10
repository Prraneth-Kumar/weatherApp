//
//  ContentView.swift
//  weatherApp
//
//  Created by Prraneth Kumar A R on 10/10/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON


struct ContentView: View {
    
    @State private var cityName = ""
    @State private var page2 = false

    @State private var name =  ""
    @State private var clouds = 0
    @State private var humidity = 0
    @State private var speed  = 0.0
    @State private var pressure  = 0
    @State private var temp = 0.0
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    // Spacer()
                    
                    Text("Enter City Name For Weather")
                    TextField("Enter City or State", text: $cityName)
                    Button("Search"){
                        guard cityName != "" else{
                            return
                        }
                        APICall()
                        page2.toggle()
                    }.fontWeight(.semibold)
                    //NavigationLink(destination:  NewPage( name: name,clouds: clouds,humidity: humidity,speed: speed,pressure: pressure, temp: temp),isActive: $page2 ){
                    //}
                    //   Spacer()
                    
                }.padding()
            }
            
            
            .sheet(isPresented: $page2){
                NewPage( name: name,clouds: clouds,humidity: humidity,speed: speed,pressure: pressure, temp: temp)
            }
        }
        
    }
    func APICall(){
        let urlLogin = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&APPID=c763b32df4592228bd42fae731558678&units=metric"
        Alamofire.request(urlLogin, method:.get).responseJSON{
            response in
            // print(response)
            let json = try! JSON(data: response.data!)
            print(json.count)
            
            guard json["cod"] != "404" else{
                //weather()
                return
            }
            name = json["name"].string!
            clouds = json["clouds"]["all"].int!
            humidity = json["main"]["humidity"].int!
            speed = json["wind"]["speed"].doubleValue
            pressure = json["main"]["pressure"].int!
            temp = json["main"]["temp"].doubleValue
        }
    }
}

struct NewPage: View{
    var name: String
    var clouds : Int
    var humidity: Int
    var speed : Double
    var pressure : Int
    var temp: Double
    //let lista = (name,clouds, humidity,speed,pressure,temp)
    var body: some View {
        VStack{
            Button("Okay"){
                
                print(name,clouds,humidity,speed,pressure,temp)
            }
            List{
                if name == ""{
                    Text("Enter City Name Correctly")
                }
                else{
                    HStack {
                        VStack{
                            Text(name).fontWeight(.bold)
                            Image("cloud")
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 100, maxHeight: 100)
                        }
                        VStack(alignment: .leading){
                            Text("Temp: \(temp, specifier: "%.2f")°C").fontWeight(.bold)
                            Text("Clouds: \(clouds)%").fontWeight(.bold)
                            Text("Humidity: \(humidity)%").fontWeight(.bold)
                            Text("Speed: \(speed, specifier: "%.2f")m/s").fontWeight(.bold)
                            Text("Pressure: \(pressure)hpa").fontWeight(.bold)
                        }
                    }
                }
            }.listStyle(.grouped)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
