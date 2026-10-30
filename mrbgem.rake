MRuby::Gem::Specification.new("htest") do |spec|
  spec.license = 'MIT'
  spec.author  = 'robert@r.uby.dev'
  spec.summary = 'hardenedbsd test framework'
  spec.version =  "0.1.0"

  if build.picoruby?
    spec.require_name = "htest"
    spec.add_dependency "mruby-errno",
                        github: "mruby/mruby",
                        branch: "master",
                        path: "mrbgems/mruby-errno"
  end
  spec.rbfiles = [
    "mrblib/htest.rb",
    "mrblib/htest/utils.rb"
  ].map { File.join(__dir__, _1) }
  spec.cc.flags << '-Wall'
  spec.cc.flags << '-Wpedantic'
  spec.linker.libraries << 'jail'
  spec.linker.libraries << 'pledge'
end
