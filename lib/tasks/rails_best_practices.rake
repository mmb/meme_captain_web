desc 'Run rails best practices check'
task :rails_best_practices do
  analyzer = RailsBestPractices::Analyzer.new(nil, {})
  analyzer.analyze
  analyzer.output

  # error_count = analyzer.runner.errors.size
  # fail("#{error_count} rails best practices errors") if error_count > 0
end
