# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{geo_calc}
  s.version = "0.7.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Kristian Mandrup}]
  s.date = %q{2011-06-21}
  s.description = %q{Geo calculations in ruby and javascript}
  s.email = %q{kmandrup@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.textile"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Changelog.textile",
    "Gemfile",
    "LICENSE.txt",
    "README.textile",
    "Rakefile",
    "VERSION",
    "geo_calc.gemspec",
    "lib/geo_calc.rb",
    "lib/geo_calc/calc.rb",
    "lib/geo_calc/calc/bearing.rb",
    "lib/geo_calc/calc/destination.rb",
    "lib/geo_calc/calc/distance.rb",
    "lib/geo_calc/calc/intersection.rb",
    "lib/geo_calc/calc/midpoint.rb",
    "lib/geo_calc/calc/rhumb.rb",
    "lib/geo_calc/extensions.rb",
    "lib/geo_calc/extensions/array.rb",
    "lib/geo_calc/extensions/hash.rb",
    "lib/geo_calc/extensions/string.rb",
    "lib/geo_calc/extensions/symbol.rb",
    "lib/geo_calc/geo_calculations.rb",
    "lib/geo_calc/pretty_print.rb",
    "spec/geo_calc/calculations_spec.rb",
    "spec/geo_calc/core_ext/array_ext_spec.rb",
    "spec/geo_calc/core_ext/coord_mode_spec.rb",
    "spec/geo_calc/core_ext/dms_coord_mode_spec.rb",
    "spec/geo_calc/core_ext/hash_ext_spec.rb",
    "spec/geo_calc/core_ext/numeric_geo_ext_spec.rb",
    "spec/geo_calc/core_ext/string_ext_spec.rb",
    "spec/geo_calc/core_ext_spec.rb",
    "spec/geo_calc/include_apis_spec.rb",
    "spec/spec_helper.rb",
    "vendor/assets/javascript/geo_calc.js"
  ]
  s.homepage = %q{http://github.com/kristianmandrup/geo_calc}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Geo calculation library}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<require_all>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<sugar-high>, ["~> 0.4.6.3"])
      s.add_runtime_dependency(%q<geo_units>, ["~> 0.2.1"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.1"])
      s.add_development_dependency(%q<geo_point>, ["~> 0.2.3"])
      s.add_development_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_development_dependency(%q<bundler>, [">= 1"])
      s.add_development_dependency(%q<jeweler>, [">= 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0.9"])
    else
      s.add_dependency(%q<require_all>, ["~> 1.2.0"])
      s.add_dependency(%q<sugar-high>, ["~> 0.4.6.3"])
      s.add_dependency(%q<geo_units>, ["~> 0.2.1"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.1"])
      s.add_dependency(%q<geo_point>, ["~> 0.2.3"])
      s.add_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_dependency(%q<bundler>, [">= 1"])
      s.add_dependency(%q<jeweler>, [">= 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0.9"])
    end
  else
    s.add_dependency(%q<require_all>, ["~> 1.2.0"])
    s.add_dependency(%q<sugar-high>, ["~> 0.4.6.3"])
    s.add_dependency(%q<geo_units>, ["~> 0.2.1"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.1"])
    s.add_dependency(%q<geo_point>, ["~> 0.2.3"])
    s.add_dependency(%q<rspec>, [">= 2.5.0"])
    s.add_dependency(%q<bundler>, [">= 1"])
    s.add_dependency(%q<jeweler>, [">= 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0.9"])
  end
end

