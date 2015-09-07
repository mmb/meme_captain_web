# encoding: UTF-8

# Search controller.
class SearchController < ApplicationController
  def show
    query = params[:q].try(:strip)

    @src_images = SrcImage.for_user(current_user, query, params[:page])
    @gend_images = GendImage.for_user(current_user, query, params[:page])
    @src_sets = find_src_sets(query)

    check_no_results
  end

  private

  def find_src_sets(query)
    SrcSet.name_matches(query).active.not_empty.most_recent.page(params[:page])
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
