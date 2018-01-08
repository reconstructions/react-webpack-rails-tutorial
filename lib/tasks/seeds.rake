namespace :seeds do
  desc "Deletes database data"
  task clobber: :environment do
    puts Rainbow("\nClobber Seeds:\n").blueviolet.bright.underline
    sh "rake db:seed:clobber --trace"
  end

  # This runs clobber, which works because it comes first, but this
  # needs to be refactored.
  desc "Create seeds"
  task create: :environment do
    puts Rainbow("\nCreate Seeds:\n").blueviolet.bright.underline
    sh "rake db:seed --trace"
  end

  desc "Cycle seeds, clobber and seed"
  task cycle: :environment do
    puts Rainbow("\nCycle Seeds:\n").blueviolet.bright.underline
    Rake::Task["seeds:clobber"].invoke
    Rake::Task["seeds:create"].invoke
  end
end
