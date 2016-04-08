class HomeController < ApplicationController
  protect_from_forgery with: :exception unless %w(development test).include? Rails.env

  def index
  end

  def edit
  	@statement = params[:statement]
  	@apply = params[:apply]
  	@selected_articles = Article.where("title LIKE '%\s#{@statement}'")
  	apply_changes if @apply
  end

  private

  def apply_changes
  	@selected_articles = Article.where("title LIKE '%\s#{@apply}'")
  	@modified_articles = []
  	@selected_articles.each do |a|
  		a.title = a.title.sub((' ' + @apply), '') if a.title.include?((' ' + @apply)) 
  		a.description = a.description.prepend((@apply + ' '))
  		a.save
  		@modified_articles.push(a)
  	end
  	render 'applied'
  end
end
