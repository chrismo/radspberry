# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'radspberry'
  spec.version       = '0.0.1'
  spec.authors       = ['David Lowenfels']
  spec.email         = ['david@internautdesign.com']
  spec.summary       = %q{real-time audio dsp library for ruby based on ffi-portaudio}
  spec.description   = %q{real-time audio dsp library for ruby based on ffi-portaudio}
  spec.homepage      = 'https://github.com/dfl/radspberry'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end