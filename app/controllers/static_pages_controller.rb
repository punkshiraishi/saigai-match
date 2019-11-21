class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @microposts = current_user.feed
      @hash = Gmaps4rails.build_markers(@microposts) do |micropost, marker|
        marker.lat micropost.latitude
        marker.lng micropost.longitude
        marker.infowindow micropost.content
        marker.title 'info'
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def news
  end
end
