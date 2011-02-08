# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  private
    def render_404
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404 }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end

    def layout_by_resource
      if (params[:bookmarklet] == 'true')
        'bookmarklet'
      else
        'application'
      end
    end

    def after_sign_in_path_for(resource_or_scope)
      home_path
    end
end
