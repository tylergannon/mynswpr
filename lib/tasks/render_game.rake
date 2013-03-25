task :render_game => :environment do
  session = ActionDispatch::Integration::Session.new(Rails.application)
  session.get '/games/minesweeper.html'
end

#  RAILS_ENV=production bundle exec rake assets:precompile render_game
