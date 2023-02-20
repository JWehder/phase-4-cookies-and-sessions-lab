class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] = session[:page_views].to_i + 1
    if session[:page_views] > 3
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    else
      article = Article.find(params[:id])
      render json: article
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
