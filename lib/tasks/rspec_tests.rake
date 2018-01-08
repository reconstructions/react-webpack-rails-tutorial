namespace :tests do
  # ------------------ Rails Unit Testing --------------------

  # Silence JS logging in rspec tests?
  desc "Run Rspec Routing, Model, and Controller Tests"
  task :rspec do
    puts Rainbow("\nRspec Unit Tests:").blueviolet.bright.underline

    puts Rainbow("\n\s\sRouting Tests:\n").blueviolet
    sh "rspec spec/routing --tag ~js --format documentation"

    puts Rainbow("\n\s\sModel Tests:\n").blueviolet
    sh "rspec spec/models --tag ~js --format documentation"

    puts Rainbow("\n\s\sController Tests:\n").blueviolet
    sh "rspec spec/controllers --tag ~js --format documentation"
  end
end
