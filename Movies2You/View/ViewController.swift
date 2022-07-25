//
//  ViewController.swift
//  Movies2You
//
//  Created by User on 22/07/22.
//


import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var movieViewModel = MovieViewModel()
    
    var movie = [Movie]()
    var genreList = [[String:Any]]()
    var movieSimilarList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        movieViewModel.delegate = self
        movieViewModel.getMovie()
        movieViewModel.getGenres()
        movieViewModel.getMovieSimilarList()
        
        likesButton.setImage(UIImage(named: "heart"), for: .normal)
    }


    @IBAction func likeButton(_ sender: Any) {
        if likesButton.currentImage == UIImage(named: "heart"){
            likesButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        } else {
            likesButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSimilarList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieSimilarCell
        
        // Title
        cell.labelTitle.text = movieSimilarList[indexPath.row]["titulo"] as? String
        
        // Information
        let releaseDate = movieSimilarList[indexPath.row]["data"] as? String
        var genreIdsName: [String] = []
        let genre = movieSimilarList[indexPath.row]["genreId"] as! [Int]
        for x in 0...genre.count - 1{
            for y in 0...genreList.count - 1{
                if genre[x] == genreList[y]["id"] as? Int{
                    genreIdsName.append(genreList[y]["name"] as! String)
                }
            }
        }
        var genres: String = ""
        for x in 0...genreIdsName.count - 1{
            if x == 0 {
                genres = genres + genreIdsName[x]
            } else {
                genres = genres + ", " + genreIdsName[x]
            }
        }
        cell.infoLabel.text = String(releaseDate!.prefix(4) + " " + genres)
        
        // Image
        let backdrop = movieSimilarList[indexPath.row]["backdrop_path"] as! String
        let movieImg = URL.init(string: "https://image.tmdb.org/t/p/w500"+backdrop)
        do{
            let data = try Data(contentsOf: movieImg!)
            cell.ImageMovie.image = UIImage(data: data)
            
        }catch{
            print("Erro\(error)")
        }
        return cell
    }
}

//MARK: - MovieViewDelegte
extension ViewController: MovieViewModelDelegate{
    
    func didUpdateMovie(_ movieViewModel: MovieViewModel, movie: Movie) {
        DispatchQueue.main.async {
            self.labelTitle.text = movie.original_title
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.locale = Locale(identifier: "pt_BR")
            let nfLike = nf.string(from: movie.vote_count as NSNumber)
            self.likesLabel.text = nfLike
            self.viewsLabel.text = "\(movie.popularity)"
            let imgURL = URL.init(string: "https://image.tmdb.org/t/p/w500/"+movie.backdrop_path)
            do{
                let data = try Data(contentsOf: imgURL!)
                self.imageMovie.image = UIImage(data: data)
            }catch{
                print("Erro:\(error)")
            }
            
        }
    }

    func didUpdateMovieSimilar(_ movieViewModel: MovieViewModel, movieSimilar: MovieSimilar) {
        for i in 0...movieSimilar.results.count - 1{
            let title = movieSimilar.results[i].title
            let releaseDate = movieSimilar.results[i].release_date
            let backdrop = movieSimilar.results[i].backdrop_path
            var genreId = [Int]()
            for y in 0...movieSimilar.results[i].genre_ids.count - 1{
                genreId.append(movieSimilar.results[i].genre_ids[y])
            }
            movieSimilarList.append(["titulo": title, "data": releaseDate, "backdrop_path": backdrop, "genreId": genreId])
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func didUpdateGenres(_ movieViewModel: MovieViewModel, genres: Genres) {
        for i in 0...genres.genres.count - 1{
            let dict = ["id": genres.genres[i].id, "name":genres.genres[i].name] as [String:Any]
            self.genreList.append(dict)
        }
        
    }
}


