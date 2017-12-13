namespace :heroku do
  desc "Login to Heroku:"
  task :login do
    sh "heroku login"
  end

  desc "Use Homebrew to upgrade the Heroku CLI:"
  task :upgrade do
    sh "brew upgrade heroku"
  end

  desc "Create a Heroku app:"
  task :create do
    sh "heroku create"
    puts "Created Heroku app:"
    sh "git remote -v"
  end

  # This is only useful if you have an already set up a named Heroko app.
  desc "Set Heroku as a Git remote:"
  task :set_up_remote, :remote_name do |t, args|
    begin
      if args.remote_name.nil?
        puts Rainbow("Please enter a remote_name!").red
        raise(e)
      else
        puts "Setting up remote with remote_name '#{args.remote_name}'"
        sh "heroku git:remote -a #{args.remote_name}"
      end
    rescue StandardError => e
      puts Rainbow("Heroku remote setup failed...").red
    end
  end

  task :add_buildpacks do
    sh "heroku buildpacks:set heroku/ruby"
    sh "heroku buildpacks:add --index 1 heroku/nodejs"
  end

  # No good, what about pushing branches, can't default to master
  #
  # desc "Push the Git master to Heroku:"
  # task :deploy, :force do |t, args|
  #   if args.force.nil?
  #     sh "git push heroku master"
  #   elsif args.force == "force"
  #     sh "git push heroku master --force"
  #   end
  # end

  desc "Reset Heroku DB"
  task :reset_db do
    sh "heroku pg:reset"
  end

  desc "Run 'rake db:migrate' on this app:"
  task :migrate_db do
    sh "heroku run rake db:migrate"
  end

  desc "Deploy and Set up App DB and Seeds:"
  task :deploy_with_db do
    # must run 'heroku:reset_db' first
    # Rake::Task["heroku:deploy"].invoke
    sh "heroku run rake db:create"
    sh "heroku run rake db:migrate"
    # Rake::Task["heroku:create_seeds"].invoke
  end

  desc "Gets the Heroku Wwwhisper URL"
  task get_wwwhisper_url: :environment do
    Bundler.with_clean_env { sh "heroku config:get WWWHISPER_URL" }
  end

  # heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
end
