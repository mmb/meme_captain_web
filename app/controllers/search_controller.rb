# encoding: UTF-8

# Search controller.
class SearchController < ApplicationController
  def show
    query = params[:q].try(:strip)

    if admin?
      @src_images = find_admin_src_images(query)
      @gend_images = find_admin_gend_images(query)
    else
      @src_images = find_src_images(query)
      @gend_images = find_gend_images(query)
    end

    @src_sets = find_src_sets(query)

    check_no_results
  end

  private

  def find_src_images(query)
    SrcImage.without_image.includes(:src_thumb).name_matches(
      query).publick.active.finished.most_used.page(params[:page])
  end

  def find_admin_src_images(query)
    SrcImage.without_image.includes(:src_thumb).name_matches(
      query).most_used.page(params[:page])
  end

  def find_src_sets(query)
    SrcSet.name_matches(query).active.not_empty.most_recent.page(params[:page])
  end

  def find_gend_images(query)
    GendImage.without_image.includes(:gend_thumb)
      .caption_matches(query).publick.active.finished.most_recent
      .page(params[:page])
  end

  def find_admin_gend_images(query)
    GendImage.without_image.includes(:gend_thumb)
      .caption_matches(query).most_recent.page(params[:page])
  end

  def check_no_results
    return if @src_images.any? || @src_sets.any? || @gend_images.any?
    @no_results = true
    @template_search = "#{params[:q]} meme template"
    google_query = {
      tbm: 'isch'.freeze,
      q: @template_search
    }
    @google_search_url =
      "https://www.google.com/search?#{google_query.to_query}"
  end
end
