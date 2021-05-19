//
//  ContentView.swift
//  BetterRest
//
//  Created by Ronaldo Gomes on 10/04/21.
//

import SwiftUI

struct ContentView: View {
    //Seta um valor default, que no caso é pela manhan e nao o horario atual do app
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var showingAlert = false
    
    var beedtime: String {
        var alertMessage: String
        var alertTitle: String
        //Instancia do modelo coreml
        let model = SleepCalculator()
        
        //Convertendo o date
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
        } catch {
            // something went wrong!
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        return "Your beedtime is \(alertTitle + alertMessage)"
    }
    
    
    
    var body: some View {
        NavigationView {
            Form {
                
                //Colocamos cada um numa vstack pois sao processos e logicas diferentes
                Section(header: Text("When do you want to wake up?") ) {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        //Nao mostra a label que foi definida
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {

                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    
                }
                
                Section(header: Text("Daily coffee intake")) {

                    Picker("Cups of coffe" , selection: $coffeeAmount) {
                        ForEach(1..<20) { timeCofee in
                            Text("\(timeCofee) cup\(coffeeAmount == 1 ? "" : "s")")
                        }
                    }
                }
                
                Section {
                    Text(beedtime)
                }
            }
            
            //Configuracao da navigation bar
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
