namespace :stylelint do
  desc "Scss lint client/app/assets/styles"
  task :client_app_assets_styles do
    sh "stylelint client/app/assets/styles/**/*.scss --config client/.stylelintrc"
  end

  desc "Scss lint client/app/bundles"
  task :client_app_bundles do
    sh "stylelint client/app/bundles/**/*.scss --config client/.stylelintrc"
  end

  desc "Run all SCSS linters"
  task :all do
    puts Rainbow("\n\s\sstylelint:\n").blueviolet
    Rake::Task["stylelint:client_app_assets_styles"].invoke
    Rake::Task["stylelint:client_app_bundles"].invoke
  end
end
