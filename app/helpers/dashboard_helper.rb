# frozen_string_literal: true

# Helpers for formatting dashboard.
module DashboardHelper
  def format_system(k, v)
    new_k = k.slice(/(.*)_bytes$/, 1)
    return [new_k.to_sym, number_to_human_size(v)] if new_k
    [k, v]
  end
end
