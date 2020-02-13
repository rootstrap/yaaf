# frozen_string_literal: true

task :code_analysis do
  sh 'bundle exec rubocop lib spec'
  sh 'bundle exec reek lib'
end
