if %w[development test].include? Rails.env
  namespace :lint do
    desc "Run Rubocop lint as shell. Specify option fix to auto-correct (and " \
      "don't have uncommitted files!)."
    task :rubocop, [:fix] => [] do |_t, args|
      def to_bool(str)
        return true if str =~ /^(true|t|yes|y|1)$/i
        return false if str.blank? || str =~ /^(false|f|no|n|0)$/i
        raise ArgumentError, "invalid value for Boolean: \"#{str}\""
      end

      puts Rainbow("\n\s\srubocop:\n").blueviolet
      fix = (args.fix == "fix") || to_bool(args.fix)
      cmd = "rubocop -S -D#{fix ? ' -a' : ''} ."
      puts "Running Rubocop Linters via `#{cmd}`" \
        "#{fix ? ' auto-correct is turned on!' : ''}"
      sh cmd
    end

    desc "Run ruby-lint as shell"
    task :ruby_lint do
      puts Rainbow("\n\s\sruby-lint:\n").blueviolet
      cmd = "ruby-lint app config spec lib"
      puts "Running ruby-lint Linters via `#{cmd}`"
      sh cmd
    end

    desc "Run Rails Best Practices"
    task :rails_best_practices do
      puts Rainbow("\n\s\srails_best_practices:\n").blueviolet
      cmd = "rails_best_practices"
      puts "Running rails_best_practices via `#{cmd}`"
      sh cmd
    end

    desc "stylelint"
    task :stylelint do
      puts Rainbow("\n\s\sstylelint:\n").blueviolet
      cmd = "stylelint client/**/*.scss app/assets/stylesheets/*.scss " \
        "--config client/.stylelintrc"
      puts "Running styleling via `#{cmd}`"
      sh cmd
    end

    desc "eslint"
    task :eslint do
      puts Rainbow("\n\s\seslint:\n").blueviolet
      cmd = "yarn run lint"
      puts "Running eslint via `#{cmd}`"
      sh cmd
    end

    desc "JS and SCSS Linting"
    task js: %i[eslint stylelint] do
      puts "\nCompleted all JavaScript and SCSS linting"
    end

    desc "Rails and Ruby Linting"
    task rails: %i[rubocop ruby_lint rails_best_practices] do
      puts "\nCompleted all Rails and Ruby linting"
    end

    task :lint do
      puts Rainbow("\n\s\sJS and Rails Linting:\n").blueviolet.underline
      Rake::Task["lint:js"].invoke
      Rake::Task["lint:rails"].invoke
      puts "\nAll linting complete"
      puts "\n"
    end
  end

  desc "Runs all linters. Run `rake -D lint` to see all available lint options"
  task lint: ["lint:lint"]
end
