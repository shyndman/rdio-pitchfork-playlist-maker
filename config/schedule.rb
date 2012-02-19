job_type :rake, "cd :path && bundle exec rake :task --silent :output"

every :sunday do
  rake "make_playlist"
end