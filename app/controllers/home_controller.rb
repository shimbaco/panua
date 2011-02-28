# coding: utf-8

class HomeController < ApplicationController

  def index
    return redirect_to home_path if current_user.present?
    @bookmarks = Bookmark.where(:private => false).desc(:created_at).limit(5)
  end

  def public_timeline
    @bookmarks = Bookmark.where(:private => false).desc(:created_at).limit(50)
  end
end
