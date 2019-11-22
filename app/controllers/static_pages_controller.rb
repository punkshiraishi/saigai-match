class StaticPagesController < ApplicationController
  include Gmap
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @hash = build_markers(@feed_items)
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
