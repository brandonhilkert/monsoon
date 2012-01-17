guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/monsoon/(.+)\.rb}) { |m| "spec/monsoon/#{m[1]}_spec.rb" }
end