# coding: utf-8

class EntriesController < ApplicationController
  def show
    @entry = Entry.criteria.id(params[:id]).first
    if @entry.blank?
      return render_404
    end
    @comments = @entry.comments.roots if @entry.comment_ids.present?
  end
end
