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
    # Works, but does not look dry to me!
    # Any feedback?
    
    @hilite = {}
    @all_ratings = Movie.all_ratings
   
    if params[:ratings]
     !params[:ratings].instance_of?(Array) ? \
         @ratings = params[:ratings].keys : @ratings = params[:ratings]
     !params[:ratings].instance_of?(Array) ? session[:ratings]= \
         params[:ratings].keys : session[:ratings] = params[:ratings]
    else
      @ratings = session[:ratings] || @all_ratings
      session[:ratings] ||= @all_ratings
    end

    session[:sort] = params[:sort]   if  params[:sort]
    session[:sort] ||= 'id ASC'      if !params[:sort]
    
    @movies = Movie.where(:rating => session[:ratings]).order(session[:sort])
    @hilite[session[:sort]]='hilite' if session[:sort]

    if session[:ratings] != params[:ratings] and session[:sort]!=params[:sort]
        redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end
   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
