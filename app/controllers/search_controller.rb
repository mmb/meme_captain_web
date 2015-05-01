# encoding: UTF-8

# Search controller.
class SearchController < ApplicationController
  def show
    query = params[:q].try(:strip)

    @src_images = find_src_images(query)
    @gend_images = find_gend_images(query)

    return unless @src_images.empty? && @gend_images.empty?
    no_results
  end

  private

  def find_src_images(query)
    SrcImage.without_image.includes(:src_thumb).name_matches(
      query).publick.active.finished.most_used.page(params[:page])
  end

  def find_gend_images(query)
    GendImage.without_image.includes(:gend_thumb)
      .caption_matches(query).publick.active.finished.most_recent
      .page(params[:page])
  end

  def no_results
    @no_results = true
    @template_search = "#{params[:q]} meme template"
    google_query = {
      tbm: 'isch',
      q: @template_search
    }
    @google_search_url =
      "https://www.google.com/search?#{google_query.to_query}"
  end
end
