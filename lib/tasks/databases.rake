namespace :databases do
  task :recreate do
    puts Rainbow("\nRecreate Rails Databases:\n").blueviolet.bright.underline
    sh "rake db:drop"
    sh "rake db:create"
  end

  task :migrate_all do
    puts Rainbow("\nRun Rails Migrations:\n").blueviolet.bright.underline
    sh "rake db:migrate"
    sh "rake db:migrate ENV=test"
  end

  task :cycle_database do
    sh "rails db:environment:set RAILS_ENV=development"
    Rake::Task["databases:recreate"].invoke
    Rake::Task["databases:migrate_all"].invoke
  end
end
