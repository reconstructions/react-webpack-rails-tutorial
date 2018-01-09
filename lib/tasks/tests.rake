if %w[development test].include? Rails.env
  require "rspec/core/rake_task"

  namespace :tests do
    desc "Run all tests (or use 'rake tests[linting]' to include all linting)"
    task :all, :linting do |_t, args|
      if args[:linting] == "linting"
        w_linting = "[linting]"
        cap_linting = "and Linting "
      else
        w_linting = ""
        cap_linting = ""
      end

      puts Rainbow("\n=================================================").orange
      puts Rainbow("     **** rake tests:all#{w_linting} ****\n").blueviolet

      Rake::Task["tests:rails"].invoke
      Rake::Task["tests:react"].invoke
      Rake::Task["tests:features"].invoke
      Rake::Task["lint"].invoke if args[:linting]

      puts Rainbow("\n     **** Tests #{cap_linting}Complete! ****").blueviolet
      puts Rainbow("=================================================\n").orange
    end

    namespace :rails do
      desc "Run RSpec Rails tests at a specified path"
      task :path, :dir do |_t, args|
        rails_rspec(args[:dir])
      end

      desc "Run RSpec Rails routing tests"
      task :routing do
        puts Rainbow("\n\s\srake tests:rails:routing\n").blueviolet
        rails_rspec("spec/routing")
      end

      desc "Run RSpec Rails models tests"
      task :models do
        puts Rainbow("\n\s\srake tests:rails:models\n").blueviolet
        rails_rspec("spec/models")
      end

      desc "Run RSpec Rails controller tests"
      task :controllers do
        puts Rainbow("\n\s\srake tests:rails:controllers\n").blueviolet
        rails_rspec("spec/controllers")
      end

      desc "Run all RSpec Rails tests (routing, models, and controllers)"
      task :all do
        puts Rainbow("\nrake tests:rails").blueviolet.bright.underline
        Rake::Task["tests:rails:routing"].invoke
        Rake::Task["tests:rails:models"].invoke
        Rake::Task["tests:rails:controllers"].invoke
      end
    end

    def rails_rspec(path)
      sh "rspec #{path} --tag ~js --format documentation"
    end

    desc "Run all RSpec Rails tests (routing, models, and controllers)"
    task rails: ["rails:all"]

    namespace :react do
      desc "Run all React Javascript tests"
      task :all do
        puts Rainbow("\nrake tests:react").blueviolet.bright.underline
        puts "\n"
        sh "cd client && yarn run test"
      end

      desc "Run all React Javascript tests at a specified path"
      task :path, :dir do |_t, args|
        puts Rainbow("\nrake tests:react:path[#{args[:dir]}]\n").blueviolet
        sh "cd client && yarn run test:path -- 'app/bundles/#{args[:dir]}'"
      end

      desc "Run all React Javascript tests at a specified path with debugging"
      task :path_debug, :dir do |_t, args|
        puts Rainbow("\nrake tests:react:path_debug[#{args[:dir]}]\n").blueviolet
        puts Rainbow("Use '.exit' to quit...\n").blueviolet
        sh "cd client && yarn run test:path:debug -- 'app/bundles/#{args[:dir]}'"
      end
    end

    task react: ["tests:react:all"]

    desc "Run browser-based feature tests using specified path and driver"
    # rake tests:features[spec/features/add_new_comment_spec.rb:20,selenium_chrome]
    task :features, :path, :js_driver do |_t, args|
      path = args[:path] ||= "spec/features"
      # Options include selenium_chrome, selenium_firefox, poltergeist,
      # poltergeist_errors_ok, poltergeist_no_animations, and webkit:
      driver = args[:js_driver] ||= "selenium_chrome"

      puts Rainbow("\nrake tests:features").blueviolet.bright.underline
      puts Rainbow("\n\s\srake tests:features[#{path},#{driver}]")
        .blueviolet
      puts "\n"
      sh "DRIVER=#{driver} rspec #{path}"
    end

    # desc "Run local browser-based feature tests using Browserstack"
    # task :start_browserstack_local do
    #   browserstack_key = Rails.application.secrets.browserstack_key
    #   sh "./BrowserStackLocal --key #{browserstack_key} --local-identifier bs_local"
    # end
    #
    # RSpec::Core::RakeTask.new(:browserstack_local) do |t|
    #   ENV["CONFIG_NAME"] ||= "local"
    #   t.pattern = Dir.glob("spec/browserstack_local_test.rb")
    #   t.rspec_opts = "--format documentation"
    #   t.verbose = false
    # end
  end

  desc "Runs all tests and all linting"
  task :tests do
    Rake::Task["tests:all"].invoke("linting")
  end
end
