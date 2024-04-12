//
//  ContentView.swift
//  5day4cast
//
//  Created by Steve on 3/30/24.
//

import SwiftUI
import Foundation
var currentDate = Date.now // one variable to get the date....we will format it during each call to the variable
let time = getTime() //function is set to where if the time equals 24 it changes the date to the next day...
var weatherIconDays: [String] = []
var location: String = ""
var city: String = ""
var state: String = ""

struct ContentView: View {
    //custom colors for the background gradient
    let color0 = Color(red: 71/255, green: 145/255, blue: 202/255);
    let color1 = Color(red: 150/255, green: 193/255, blue: 226/255);
    
    let API_KEY = ProcessInfo.processInfo.environment["API_KEY"]
    
    //changeable variables after we press the go button
    @ State private var showAlert = false
    @ State private var zipCode: String = "";
    @ State private var currentDescription: String = "";
    @ State private var currentTemp: String = "";
    @ State private var dayCondition: String = "";
    @ State private var weatherIcon: String = "";
    @ State private var currentWeatherIcon: String = "";
    @ State private var weekDay1: String = ""
    @ State private var weekDay2 = Date()
    @ State private var weekDay3 = Date()
    @ State private var weekDay4 = Date()
    @ State private var weekDay5 = Date()
    @ State private var weekDay2Str: String = ""
    @ State private var weekDay3Str: String = ""
    @ State private var weekDay4Str: String = ""
    @ State private var weekDay5Str: String = ""
    @ State private var day1Condition: String = ""
    @ State private var day2Condition: String = ""
    @ State private var day3Condition: String = ""
    @ State private var day4Condition: String = ""
    @ State private var day5Condition: String = ""
    @ State private var day1Icon: String = ""
    @ State private var day2Icon: String = ""
    @ State private var day3Icon: String = ""
    @ State private var day4Icon: String = ""
    @ State private var day5Icon: String = ""
    @ State private var day1Temp: String = ""
    @ State private var day2Temp: String = ""
    @ State private var day3Temp: String = ""
    @ State private var day4Temp: String = ""
    @ State private var day5Temp: String = ""
    
    
    
    var body: some View {
        
        
        ZStack {
            let gradient = Gradient(colors: [color0, color1]);
            Rectangle()
                    .fill(LinearGradient(
                      gradient: gradient,
                      startPoint: .init(x: 0.00, y: 0.50),
                      endPoint: .init(x: 0.00, y: 0.90)
                    ))
                  .edgesIgnoringSafeArea(.all)
            VStack {
                if dayCondition.isEmpty {
                    
                } else {
                    Text(currentDate.formatted(.dateTime.weekday(.wide).month().day()))
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 2)
                        .padding(.top, 10)
                }
                if city.isEmpty {
                    
                } else {
                    Text(city + ", " + state) //if you put "" then \("") you can output whatever variable is set to at the time...
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundStyle(Color.white)
                }
                VStack(spacing: 5) {
                    Image(systemName: "\(weatherIcon)")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                    
                    Text(dayCondition)
                        .font(.system(size: 24, weight: .heavy, design: .default))
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 2)
                        .padding(.top, 10)
                        .bold()
                    
                    if currentTemp.isEmpty {
                        //do not add the degree symbol
                    }else {
                        Text(currentTemp + "°F")
                            .font(.system(size: 70, weight: .medium, design: .default))
                            .foregroundStyle(Color.white)
                    }
                    Text(currentDescription)
                        .font(.system(size: 15, weight: .light, design: .default))
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 2)
                        .padding(.top, 10)
                        .italic()
                }
                
                .padding(.bottom, 30)
                
                HStack(spacing: 15) {
                    if weatherIconDays.isEmpty {
                        
                    } else {
                        WeatherDayView(dayOfWeek: "\(weekDay1)", imageName: weatherIconDays[0], temperature: day1Temp)
                        WeatherDayView(dayOfWeek: weekDay2Str, imageName: weatherIconDays[1], temperature: day2Temp)
                        WeatherDayView(dayOfWeek: weekDay3Str, imageName: weatherIconDays[2], temperature: day3Temp)
                        WeatherDayView(dayOfWeek: weekDay4Str, imageName: weatherIconDays[3], temperature: day4Temp)
                        WeatherDayView(dayOfWeek: weekDay5Str, imageName: weatherIconDays[4], temperature: day5Temp)
                    }
                }
                Spacer()
                
                //this positions the following HStack to always be at the bottom of page
                    .frame(minHeight: 0, maxHeight: .infinity)
                HStack {
                    TextField("", text: $zipCode, prompt: Text("Zipcode...").foregroundColor(.white))
                        .padding(.leading, 20)
                        .foregroundStyle(Color.white)
                        .alert(isPresented: $showAlert, content: {
                                        Alert(title: Text("Error"), message: Text("Please enter a US Zipcode"), dismissButton: .default(Text("OK")))
                                    })
                    Button("GO") {
                        weekDay1 = currentDate.formatted(.dateTime.weekday())
                        weekDay2 = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                        weekDay2Str = weekDay2.formatted(.dateTime.weekday())
                        weekDay3 = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!
                        weekDay3Str = weekDay3.formatted(.dateTime.weekday())
                        weekDay4 = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)!
                        weekDay4Str = weekDay4.formatted(.dateTime.weekday())
                        weekDay5 = Calendar.current.date(byAdding: .day, value: 4, to: currentDate)!
                        weekDay5Str = weekDay5.formatted(.dateTime.weekday())
                        //set the url for the api...and begin gathering JSON data...
                        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/ \(zipCode)?unitGroup=us&key=" + API_KEY! + "&contentType=json")!
                        
                        let dataTask = URLSession.shared.dataTask(with: url) {
                            (data, response, error) in
                            do {
                                if let data = data ,
                                   let string = String(data:data, encoding: .utf8) {
                                    
                                    let weather: Weatherdata = try JSONDecoder().decode(Weatherdata.self, from: data)
                                    //print("days", weather) //this is all data
                                    
                                    //format the date to compare with the api data dates
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    let dateForApi = dateFormatter.string(from: currentDate)
                                    print("date for api: ", dateForApi)
                                    
                                    
                                    //find a match for the date only need 5 days
                                    for var j in 0 ..< 5 {
                                        print("date times : ", weather.days[j].datetime)
                                        if dateForApi == weather.days[j].datetime {
                                            //set the icon for the days weather condition
                                            day1Icon = weather.days[j].icon
                                            findWeatherIcon(dayIcon: day1Icon)
                                            day2Icon = weather.days[j+1].icon
                                            findWeatherIcon(dayIcon: day2Icon)
                                            day3Icon = weather.days[j+2].icon
                                            findWeatherIcon(dayIcon: day3Icon)
                                            day4Icon = weather.days[j+3].icon
                                            findWeatherIcon(dayIcon: day4Icon)
                                            day5Icon = weather.days[j+4].icon
                                            findWeatherIcon(dayIcon: day5Icon)
                                            
                                            
                                            //loop through the weatherconditions array
                                            
                                            day1Temp = weather.days[j].temp.rounded().formatted(.number.precision(.fractionLength(0))) + "°"
                                            day2Temp = weather.days[j+1].temp.rounded().formatted(.number.precision(.fractionLength(0))) + "°"
                                            day3Temp = weather.days[j+2].temp.rounded().formatted(.number.precision(.fractionLength(0))) + "°"
                                            day4Temp = weather.days[j+3].temp.rounded().formatted(.number.precision(.fractionLength(0))) + "°"
                                            day5Temp = weather.days[j+4].temp.rounded().formatted(.number.precision(.fractionLength(0))) + "°"
                                            //loop through the 24 hours in the day to find a match for the time
                                            for var k in 0 ..< 24 {
                                                if time == weather.days[j].hours[k].datetime{
                                                    currentTemp = weather.days[j].hours[k].temp.rounded().formatted(.number.precision(.fractionLength(0)))
                                                    dayCondition = weather.days[j].hours[k].conditions
                                                    currentWeatherIcon = weather.days[j].hours[k].icon
                                                    print("time matched: ", weather.days[j].hours[k])
                                                }
                                                
                                                k = k + 1
                                            }
                                        }
                                        j = j + 1
                                        
                                        
                                    }
                                    print("new icons", weatherIconDays)
                                    currentDescription = weather.description
                                    
                                    
                                    //switch statement to change weather icon based on current icon for the current hour from the api
                                    switch (currentWeatherIcon) {
                                    case "snow":
                                        weatherIcon = "snowflake"
                                        break;
                                    case "rain":
                                        weatherIcon = "cloud.heavyrain.fill"
                                        break;
                                    case "fog":
                                        weatherIcon = "cloud.fog.fill"
                                        break;
                                    case "wind":
                                        weatherIcon = "wind"
                                        break;
                                    case "cloudy":
                                        weatherIcon = "cloud.fill"
                                        break;
                                    case "partly-cloudy-day":
                                        weatherIcon = "cloud.sun.fill"
                                        break;
                                    case "partly-cloudy-night":
                                        weatherIcon = "cloud.moon.fill"
                                        break;
                                    case "clear-day":
                                        weatherIcon = "sun.max.fill"
                                        break;
                                    case "clear-night":
                                        weatherIcon = "moon.fill"
                                        break;
                                    default:
                                        weatherIcon = "cloud.fill"
                                        break;
                                    }
                                }
                            } catch {
                                
                                    showAlert = true
                                print("Either zip code isn't a zip code or api is having connection issues")
                            }
                        }
                        dataTask.resume()
                        
                        
                        
                        
                        
                        getCity(zipDecode: zipCode)
                        zipCode = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: String
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundStyle(Color.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperature)")
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundStyle(Color.white)
        }
        
    }
}

struct Forecast : Codable {
    let address: String
    struct Days : Codable {
        var day1Array = "0"
        var day2Array = "1"
        var day3Array = "2"
        var day4Array = "3"
        var day5Array = "4"
    }
    let days : [Days]
}




struct getlocation : Codable {
    let zipcode: String
    
}



struct WeatherDays: Decodable {
    let datetime: String
    let temp: Double //will need to round this up to the nearest or down to the nearest...
    let hours: [Hours]
    let icon: String
}
struct Weatherdata: Decodable {
    let resolvedAddress: String
    let description: String
    let days: [WeatherDays]
}


struct Hours: Decodable {
    let datetime: String
    let temp: Double
    let conditions: String
    let icon: String
}

struct icons {
    var weather = [String: String]()
}

func findWeatherIcon(dayIcon: String) {
    switch (dayIcon) {
    case "snow":
        weatherIconDays.append("snowflake")
        break;
    case "rain":
        weatherIconDays.append("cloud.heavyrain.fill")
        break;
    case "fog":
        weatherIconDays.append("cloud.fog.fill")
        break;
    case "wind":
        weatherIconDays.append("wind")
        break;
    case "cloudy":
        weatherIconDays.append("cloud.fill")
        break;
    case "partly-cloudy-day":
        weatherIconDays.append("cloud.sun.fill")
        break;
    case "partly-cloudy-night":
        weatherIconDays.append("cloud.moon.fill")
        break;
    case "clear-day":
        weatherIconDays.append("sun.max.fill")
        break;
    case "clear-night":
        weatherIconDays.append("moon.fill")
        break;
    default:
        weatherIconDays.append("cloud.fill")
        break;
    }
}

//getting the time and then rounding it up or down based on the minutes since the api only counts by hour not minute
func getTime() -> String {
    let time = Date.now
    var fullTime: String
    let calendar = Calendar.current
    var hour = calendar.component(.hour, from: time)
    var minutes = calendar.component(.minute, from: time)
    var seconds = calendar.component(.second, from: time)
    //check to see if we need to round the hour up or down
    if minutes <= 29 {
        //do nothing with hour
        //set minutes to 00
        minutes = 00
        //set seconds to 00
        seconds = 00
    } else {
        //round the hour up one
        hour += 1
        minutes = 00
        seconds = 00
    }
    if hour == 24 {
        //add one to day...
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        currentDate = modifiedDate
    }
    if hour <= 9 {
        fullTime = String(format: "%02d", hour) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    } else {
        fullTime = "\(hour):" + String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    return fullTime
}
struct zipData: Decodable {
    let places: [Places]
}

struct Places: Decodable {
    var placeName: String
    let state: String
    
    private enum CodingKeys : String, CodingKey {
        case placeName = "place name"
        case state = "state"
    }
}

func getCity(zipDecode: String) {
    let url = URL(string: "https://api.zippopotam.us/us/" + zipDecode)!
    let dataTask = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        do {
            if let data = data ,
               let string = String(data:data, encoding: .utf8) {
                //let weather: zipData = try! JSONDecoder().decode(zipData.self, from: data)
                let zipResults: zipData = try JSONDecoder().decode(zipData.self, from: data)
                city = zipResults.places[0].placeName
                state = zipResults.places[0].state
                print(city + ", " + state)
            }
        } catch {
            print("Please Enter ZipCode")
        }
    }
    dataTask.resume()
}




