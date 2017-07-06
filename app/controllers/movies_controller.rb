class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sorted_col = "??"
    @all_ratings = Movie.get_ratings
    if params[:sort_by] == "title"
      @movies = Movie.re_order(params[:sort_by])
      @sorted_col = "title"
    elsif params[:sort_by] == "release_date"
      @movies = Movie.re_order(params[:sort_by])
      @sorted_col = "date"
    else
      @movies = Movie.all
    end
    @checked_keys = Array.new
    if !(params[:ratings].nil?)
      @filtered_movie_list = Array.new
      @movies.each do |movie|
        if((params[:ratings].keys).include? movie[:rating])
          @filtered_movie_list.push movie
          @checked_keys.push movie[:rating]
        end
      end
      @movies = @filtered_movie_list
    end
   # debugger
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
