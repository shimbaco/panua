# coding: utf-8

require 'open-uri'
require 'nokogiri'

class BookmarksController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html
  respond_to :json, :only => :get_page_title

  def new
    @tags = Tag.autocompleted(current_user).to_a.to_json
    if params[:url].blank?
      @bookmark = Bookmark.new
      render :new
    else
      b = current_user.bookmarks.where(:url => params[:url]).first
      if b.present?
        flash[:notice] = t('panua.bookmarks.already_existed')
        return redirect_to edit_bookmark_path(b.id) + '?bookmarklet=true'
      end
      @bookmark = Bookmark.new(:url => params[:url], :title => params[:title])
      @bookmarklet = true
      render :layout => 'bookmarklet'
    end
  end
  
  def create
    bookmark = params[:bookmark]
    @bookmark = Bookmark.new(bookmark)
    if @bookmark.valid?
      b = current_user.bookmarks.where(:url => bookmark[:url]).first
      if b.present?
        flash[:notice] = t('panua.bookmarks.already_existed')
        return redirect_to edit_bookmark_path(b.id)
      end

      current_user.bookmarks << @bookmark

      @entry = Entry.build(bookmark[:url], page_title(bookmark[:url]))
      @entry.bookmarks << @bookmark
      @entry.add_comment(params[:comment_body], current_user, @bookmark) if params[:comment_body].present?
      @entry.save

      @bookmark.add_tags!(split_tag_str(params[:tag_name]), current_user.id) if params[:tag_name].present?
      @bookmark.reconnect_to_comments!(current_user, @entry)

      if params[:bookmarklet] == 'true'
        return render :bsaved, :layout => 'bookmarklet'
      else
        return redirect_to home_path
      end
    end
    respond_with @bookmark
  end

  def edit
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.user_id == current_user.id
      @tags = Tag.autocompleted(current_user).to_a.to_json
      @tag_str = tags_to_str(@bookmark.tags)
      if params[:bookmarklet] == 'true'
        return render :layout => 'bookmarklet'
      end
    else
      redirect_to home_path
    end
  end

  def update
    @bookmark = Bookmark.new(params[:bookmark])
    if @bookmark.valid?
      @bookmark = Bookmark.criteria.id(params[:id]).first
      if @bookmark.user_id == current_user.id
        old_tags_name = split_tag_str(params[:old_tag_name])
        new_tags_name = split_tag_str(params[:tag_name])
        delete_tags_name = old_tags_name - new_tags_name # 更新によって削除されるtag_name
        save_tags_name = new_tags_name - old_tags_name # 更新によって保存されるtag_name

        @bookmark.remove_tags!(delete_tags_name, current_user.id) if delete_tags_name.present?
        @bookmark.add_tags!(save_tags_name, current_user.id) if save_tags_name.present?
        @bookmark.update_attributes(params[:bookmark])

        if params[:bookmarklet] == 'true'
          return render :bsaved, :layout => 'bookmarklet'
        else
          return redirect_to profile_path(current_user.screen_name)
        end
      end
      return redirect_to home_path
    end
    respond_with @bookmark
  end

  def destroy
    if current_user.remove_bookmark(params[:id])
      return render(:nothing => true, :status => 200)
    end
    render(:nothing => true, :status => 400)
  end

  def get_page_title
    respond_with :title => page_title(params[:url])
  end

  private
    def split_tag_str(str)
      ary = []
      str.split(',').each {|s| s.strip!; ary << s if s.present?}
      ary.uniq
    end

    def tags_to_str(tags_ary)
      tag_str = ''
      tags_ary.count.times {|i| tag_str << tags_ary[i].name; tag_str << ', ' if i < tags_ary.count - 1}
      tag_str
    end

    def page_title(url)
      begin
        page = Nokogiri::HTML(open(url))
        title = page.css('title').children.to_s.strip.delete("\n")
        title = url if title.blank?
      rescue
        title = 'no title'
      end
      title
    end
end
