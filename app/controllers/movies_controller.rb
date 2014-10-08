class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.ratings
    @checked_boxes=@all_ratings    
    
    if params[:ratings]
        @checked_boxes=params[:ratings]
    elsif session[:ratings]
        @checked_boxes=session[:ratings]
        redirect=true
    end
    if params[:sort_by]
        @sorting=params[:sort_by]
    elsif session[:sort_by]
        @sorting=session[:sort_by]
        redirect=true
    end
    if redirect
        flash.keep
        redirect_to movies_path( :sort_by=>@sorting, :ratings=>@checked_boxes)
    end
    @movies = Movie.order(@sorting).find_all_by_rating(@checked_boxes.keys) 
    if params[:sort_by] == 'title'
        @title_header = "hilite"
        @release_date_header = ''
    elsif params[:sort_by] == 'release_date'
	   @title_header = ""
        @release_date_header = 'hilite'
    end
    session[:sort_by]=@sorting
    session[:ratings]=@checked_boxes
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
