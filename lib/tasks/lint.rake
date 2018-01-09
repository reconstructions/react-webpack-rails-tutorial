if %w[development test].include? Rails.env
  namespace :lint do
    desc "Use eslint to check Javascript syntax"
    task :eslint do
      puts Rainbow("\n\s\srake lint:eslint\n").blueviolet
      cmd = "yarn run lint"
      puts "Running eslint via `#{cmd}`"
      sh cmd
    end

    desc "Use stylelint to check SCSS and CSS syntax"
    task :stylelint do
      puts Rainbow("\n\s\srake lint:stylelint\n").blueviolet
      cmd = "stylelint client/**/*.scss app/assets/stylesheets/*.scss " \
        "--config client/.stylelintrc"
      puts "Running styleling via `#{cmd}`"
      sh cmd
    end

    desc "Use rubocop to check Ruby syntax"
    task :rubocop, [:fix] => [] do |_t, args|
      def to_bool(str)
        return true if str =~ /^(true|t|yes|y|1)$/i
        return false if str.blank? || str =~ /^(false|f|no|n|0)$/i
        raise ArgumentError, "invalid value for Boolean: \"#{str}\""
      end

      puts Rainbow("\n\s\srake lint:rubocop\n").blueviolet
      fix = (args.fix == "fix") || to_bool(args.fix)
      cmd = "rubocop -S -D#{fix ? ' -a' : ''} ."
      puts "Running Rubocop Linters via `#{cmd}`" \
        "#{fix ? ' auto-correct is turned on!' : ''}"
      sh cmd
    end

    desc "Use ruby-lint to check for unused variables or methods"
    task :ruby_lint do
      puts Rainbow("\n\s\srake lint:ruby_lint\n").blueviolet
      cmd = "ruby-lint app config spec lib"
      puts "Running ruby-lint Linters via `#{cmd}`"
      sh cmd
    end

    desc "Use rails_best_practices to check Rails code quality"
    task :rails_best_practices do
      puts Rainbow("\n\s\srake lint:rails_best_practices\n").blueviolet
      cmd = "rails_best_practices"
      puts "Running rails_best_practices via `#{cmd}`"
      sh cmd
    end

    desc "Run all Javascript & CSS linters"
    task js: %i[eslint stylelint] do
      puts "\nCompleted all JavaScript SCSS linting"
    end

    desc "Run all Rails & Ruby linters"
    task rails: %i[rubocop ruby_lint rails_best_practices] do
      puts "\nCompleted all Rails and Ruby linting"
    end

    desc "Run all Rails & Javascript linters"
    task :lint do
      puts Rainbow("\nrake lint").blueviolet.bright.underline
      Rake::Task["lint:js"].invoke
      Rake::Task["lint:rails"].invoke
      puts "\nAll linting complete"
      puts "\n"
    end
  end

  desc "Run all Rails & Javascript linters"
  task lint: ["lint:lint"]
end
