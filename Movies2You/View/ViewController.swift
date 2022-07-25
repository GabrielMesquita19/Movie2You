//
//  ViewController.swift
//  Mobile2You
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
    
    var genreList = [GenreId]()
    var movieSimilarList = [Results]()
    
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
        cell.labelTitle.text = movieSimilarList[indexPath.row].title
        
        // Information

        let releaseDate = movieSimilarList[indexPath.row].release_date
        let genres = movieSimilarList[indexPath.row].genre_ids
        let movieGenres = genreList.filter({ (genres.contains($0.id )) })
        let genresDescription: [String] = movieGenres.map { $0.name }
        let joinedGenres = genresDescription.compactMap{ $0 }.joined(separator: ", ")
        
        cell.infoLabel.text = String(releaseDate.prefix(4) + " " + joinedGenres)
        
        // Image

        let backdrop = movieSimilarList[indexPath.row].backdrop_path
        let movieImg = URL.init(string: "https://image.tmdb.org/t/p/w500"+backdrop)
        do{
            let data = try Data(contentsOf: movieImg!)
            cell.movieImage.image = UIImage(data: data)
            
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
        movieSimilarList = movieSimilar.results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func didUpdateGenres(_ movieViewModel: MovieViewModel, genres: Genres) {
        genreList = genres.genres
    }
}
