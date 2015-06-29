require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks'

Rake::Task[:lint].clear # workaround https://github.com/rodjek/puppet-lint/issues/331
PuppetLint.configuration.relative = true # https://github.com/rodjek/puppet-lint/pull/334
PuppetLint::RakeTask.new :lint do |config|
  config.pattern = 'manifests/**/*.pp'
  config.disable_checks = ["80chars", "class_inherits_from_params_class","class_parameter_defaults","disable_documentation","disable_single_quote_string_with_variables"]
  config.fail_on_warnings = true
end

Blacksmith::RakeTask.new do |t|
  t.build = false # do not build the module nor push it to the Forge, just do the tagging [:clean, :tag, :bump_commit]
end