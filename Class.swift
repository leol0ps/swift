//
//  Class.swift
//  corrida
//
//  Created by Turma01-9 on 26/06/24.
//

import Foundation



class ViewModel : ObservableObject{
    @Published var corridas : [Corrida] = []
    func postRequest() {
      //var postCorrida = Corrida(id : 2, tempo: 2.0, distancia: 3.0, caloria: 4.0)
      // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
      let currentDate = Date()
        let cor  = Corrida(data: currentDate, tempo: 2.0, distancia: 3.0, caloria: 4.0, latitude: [] , longitude: [] )
        print(currentDate)
        //let cor: [String: Any] = ["id": 13, "name": "jack"]
//      do {
//            let jsonData = try JSONEncoder().encode(cor)
//            let jsonString = String(data: jsonData, encoding: .utf8)!
//            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
//            parameters = jsonData
//            // and decode it back
//        } catch { print(error) }
      

      
      // create the url with URL
      let url = URL(string: "http://192.168.128.211:1880/leonardoPost")! // change server url accordingly
      
      // create the session object
      let session = URLSession.shared
      
      // now create the URLRequest object using the url object
      var request = URLRequest(url: url)
      request.httpMethod = "POST" //set http method as POST
      
      // add headers for the request
      request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
          let jsonData = try JSONEncoder().encode(cor)
          request.httpBody = jsonData
      } catch let error {
        print(error.localizedDescription)
        return
      }
      
      // create dataTask using the session object to send data to the server
      let task = session.dataTask(with: request) { data, response, error in
        
        if let error = error {
          print("Post Request Error: \(error.localizedDescription)")
          return
        }
        
        // ensure there is valid response code returned from this HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
          print("Invalid Response received from the server")
          return
        }
        
        // ensure there is data returned
        guard let responseData = data else {
          print("nil Data received from the server")
          return
        }
        
        do {
          // create json object from data or use JSONDecoder to convert to Model stuct
          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
            print(jsonResponse)
            // handle json response
          } else {
            print("data maybe corrupted or in wrong format")
            throw URLError(.badServerResponse)
          }
        } catch let error {
          print(error.localizedDescription)
        }
      }
      // perform the task
      task.resume()
    }
    func fetchReg(){
        guard let url = URL(string : "http://192.168.128.211:1880/leonardoRead") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let decod = try JSONDecoder().decode([Corrida].self, from: data)
                DispatchQueue.main.async{
                    self!.corridas = decod
                }
                
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func calcStats() -> (Corrida, Double){ // retorna uma corrida com tempo, distancia e caloria totais somados + a velocidade media
        let currentDate = Date()
        var velocidade = 0.0
        var stats = Corrida(data: currentDate, tempo: 0, distancia: 0, caloria: 0, latitude: [] , longitude: [] )
        
        for corrida in corridas{
            stats.distancia += corrida.distancia
            stats.caloria += corrida.caloria
            stats.tempo += stats.tempo
        }
        velocidade = stats.distancia/stats.tempo/1000 // km/h
        return (stats,velocidade)
    }
}



//class ViewModel : ObservableObject{
//    @Published var umis : [Umidade] = []
//    
//    func fetchUmi(){
//        guard let url = URL(string : "http://192.168.128.211:1880/LeonardoRead") else{
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
//            guard let data = data, error == nil else{
//                return
//            }
//            do{
//                let decod = try JSONDecoder().decode([Umidade].self, from: data)
//                DispatchQueue.main.async{
//                    self!.umis = decod
//                }
//                
//            }catch{
//                print(error)
//            }
//        }
//        task.resume()
//    }
//    
//}



//class ViewModel : ObservableObject{
//    @Published var animes : [Anime] = []
//    
//    func fetchAni(){
//        guard let url = URL(string : "https://api.jikan.moe/v4/top/anime") else{
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
//            guard let data = data, error == nil else{
//                return
//            }
//            do{
//                let decod = try JSONDecoder().decode(API.self, from: data)
//                DispatchQueue.main.async{
//                    self!.animes = decod.data
//                }
//                
//            }catch{
//                print(error)
//            }
//        }
//        task.resume()
//    }
//    
//}

