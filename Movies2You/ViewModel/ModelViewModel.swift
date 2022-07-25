//
//  ModelViewModel.swift
//  Movies2You
//
//  Created by User on 22/07/22.
//

import Foundation

protocol MovieViewModelDelegate {
    func didUpdateMovie(_ movieViewModel: MovieViewModel, movie: Movie)
    func didUpdateMovieSimilar(_ movieViewModel: MovieViewModel, movieSimilar: MovieSimilar)
    func didUpdateGenres(_ movieViewModel: MovieViewModel, genres: Genres)
    
}


class MovieViewModel {
    
    let api = "?api_key=91d29542d168257f5c8d4cec082fea27"
    let url = "https://api.themoviedb.org/3/movie/89"
    let urlImg = "https://image.tmdb.org/t/p/w500"
    let urlGenre = "https://api.themoviedb.org/3/genre/movie/list"
    
    var delegate: MovieViewModelDelegate?
    
    var genreList = [[String:Any]]()
    var movieSimilarList = [[String:Any]]()
    
    func getMovie() {
        if let url = URL(string: url+api) {
            let task = URLSession.shared.dataTask(with: url) { data, request, erro in
                if erro == nil {
                    if let returnData = data {
                     if  let movie = self.parseJSON(returnData, "Movie") as? Movie {
                            self.delegate?.didUpdateMovie(self, movie: movie)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    func getMovieSimilarList() {
        if let urlSimilar = URL(string: url+"/similar"+api) {
            let task = URLSession.shared.dataTask(with: urlSimilar) { data, request, erro in
                if erro == nil {
                    if let returnData = data {
                        if let movies = self.parseJSON(returnData, "MovieSimilar") as? MovieSimilar {
                            self.delegate?.didUpdateMovieSimilar(self, movieSimilar: movies)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getGenres(){
        if let urlGenres = URL(string: urlGenre+api+"&language=en-US"){
            let task = URLSession.shared.dataTask(with: urlGenres) { data, request, erro in
                if erro == nil {
                    if let returnData = data{
                        if let genres = self.parseJSON(returnData, "Genre") as? Genres {
                            self.delegate?.didUpdateGenres(self, genres: genres)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data,_ frame: String) -> Any?{
        let decoder = JSONDecoder()
        var decodedData: Any
        do{
            switch  frame{
            case "Movie":
                decodedData = try decoder.decode(Movie.self, from: data)
            case "MovieSimilar":
                decodedData = try decoder.decode(MovieSimilar.self, from: data)
            case "Genre":
                decodedData = try decoder.decode(Genres.self, from: data)
            default:
                return nil
            }
            return decodedData
        }catch{
            print("erro JSON")
            return nil
        }
    }
    
}
