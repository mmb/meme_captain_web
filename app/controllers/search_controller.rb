# encoding: UTF-8
# frozen_string_literal: true

# Search controller.
class SearchController < ApplicationController
  def show
    query = params[:q].try(:strip)

    @src_images = SrcImage.for_user(current_user, query, params[:page])
    @gend_images = GendImage.for_user(current_user, query, params[:page])
    @src_sets = find_src_sets(query)
    @show_toolbar = admin?

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
    record_no_results
  end

  def record_no_results
    NoResultSearch.create(query: params[:q])
  end
end
