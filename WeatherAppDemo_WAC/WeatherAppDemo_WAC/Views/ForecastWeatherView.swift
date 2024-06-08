//
//  ForecastWeatherView.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//

import SwiftUI

struct ForecastWeatherView: View {
    @StateObject private var viewModel: ForecastListViewModel = ForecastListViewModel()

    var body: some View {
        VStack {
            ScrollView([], showsIndicators: false) {
                ZStack {
                    if !viewModel.forecasts.isEmpty {
                        MainView
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: Binding(get: {
                viewModel.appError != nil
            }, set: { value in
                if !value {
                    viewModel.appError = nil
                }
            }), content: {
                Alert(title: Text("\(.Error.error)"),
                      message: Text("\(viewModel.appError?.errorString ?? .Error.unKnownError)"))
            })
        }
        .background(MainBackgroundView())
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var MainView: some View {
        VStack {
            CustomTextfieldView()
            
            VStack {
                CityLocationDeatilsView()
                CurrentDayTemperatureView()
                CurrentDayWeatherDetailsView()
            }
            .padding(.vertical, 50)
            
            CityForecastBottomView()
        }
    }
    
    private func MainBackgroundView() -> some View {
        Rectangle()
            .fill(LinearGradient(colors: [.gradient1,
                                          .gradient3,
                                          .gradient1],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing))
            .ignoresSafeArea()
    }
    
    private func LoadingView() -> some View {
        ZStack {
            Color(.white)
                .opacity(0.3)
                .ignoresSafeArea()
            ProgressView("\(.loadingViewTitle)")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                )
                .shadow(radius: 10 )
        }
    }
    
    private func CustomTextfieldView() -> some View {
        HStack {
            TextfieldViewWithCancelButtonView()
            
            Button(action: {
                viewModel.getWeatherForecast()
            }, label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .font(.headline)
            })
            
        }.padding(.horizontal, 12)
    }
    
    private func TextfieldViewWithCancelButtonView() -> some View {
        TextField("\(.Dashboard.textFieldPlaceholder)", text: $viewModel.location)
            .foregroundColor(.white)
            .padding(8)
            .padding(.trailing, 20)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .padding(1)
            .background(Color.gradient3)
            .cornerRadius(9)
            .overlay(alignment: .trailing) {
                Button(action: {
                    viewModel.location = ""
                }, label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.trailing, 6)
                })
            }
    }
    
    @ViewBuilder
    private func CityLocationDeatilsView() -> some View {
        Text("\(viewModel.currentForecastDetails?.day ?? "" )")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
        Text("\(viewModel.currentForecastDetails?.cityName ?? .defaultCity)")
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
        Text("\(viewModel.currentForecastDetails?.countryName ?? .defaultCountry)")
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white)
    }
    
    private func CurrentDayTemperatureView() -> some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width:  UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.width * 0.40)
            if let currentForecast = viewModel.currentForecastDetails {
                VStack {
                    ImageLoaderView(url: currentForecast.weatherIconURL)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 3, x: 1, y: 3)
                    Text(currentForecast.currentTemp)
                        .foregroundColor(.black)
                        .font(.system(size: 25, weight: .semibold))
                }
            }
        }
    }
    
    @ViewBuilder
    private func CurrentDayWeatherDetailsView() -> some View {
        if !viewModel.currentWeatherDetails.isEmpty {
            LazyVGrid(columns: [.init(.flexible(minimum: 100, maximum: 250)),
                                .init(.flexible(minimum: 100, maximum: 250))], spacing: 30, content: {
                ForEach(viewModel.currentWeatherDetails, id: \.title) { value in
                    VStack(spacing: 12) {
                        Text("\(value.title)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Text("\(value.value)")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                }
            })
        } else {
            Text("\(.empty)")
        }
    }
    
    private func CityForecastBottomView() -> some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.red.opacity(0.2))
                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
            
            VStack(alignment: .leading) {
                Text("\(.Dashboard.bottomViewTitle)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(viewModel.forecasts[1...3]), id: \.forecast.dt) {
                            ForecastListItem(forecast: $0)
                        }
                    }
                }
            }.padding(.top, 50)
                .padding(.horizontal, 12)
        }
    }
    
    private func ForecastListItem(forecast: ForecastViewModel) -> some View {
        VStack {
            Text(forecast.weekDay)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
            VStack {
                ImageLoaderView(url: forecast.weatherIconURL)
                    .frame(width: 45, height: 45)
                    .shadow(color: .white.opacity(0.3), radius: 3, x: 1, y: 3)
                Text(forecast.currentTemp)
                    .foregroundColor(.black)
                    .font(.system(size: 13, weight: .semibold))
            }.padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .padding(1)
                .background(Color.gradient3)
                .cornerRadius(9)
            
        }
    }
}
