# frozen_string_literal: true

ActiveSupport::Notifications.subscribe(
  'process_action.action_controller'
) do |_, _, _, _, payload|
  prefix = "#{payload[:controller]}.#{payload[:action]}.#{payload[:format]}"
           .freeze
  db_runtime_stat = "#{prefix}.db_runtime".freeze
  view_runtime_stat = "#{prefix}.view_runtime".freeze
  status_stat = "#{prefix}.#{payload[:status]}".freeze

  StatsD.measure(db_runtime_stat, payload[:db_runtime]) \
    if payload[:db_runtime]
  StatsD.measure(view_runtime_stat, payload[:view_runtime]) \
    if payload[:view_runtime]
  StatsD.increment(status_stat)
end
