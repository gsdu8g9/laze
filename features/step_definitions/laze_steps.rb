Before do
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR) if File.directory?(TEST_DIR)
end

Given /^I have an '(.+?)' file that contains ('|")(.*)\2$/ do |file, quote, text|
  FileUtils.mkdir_p(File.dirname(file))
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have a (.+?) directory$/ do |dir|
  FileUtils.mkdir(dir)
end

Given /^I have a '(.+?)' layout that contains ('|")(.*)\2$/ do |layout, quote, text|
  File.open(File.join('layouts', layout + '.html'), 'w') do |f|
    f.write(text)
  end
end

Given /^I have a '(.+?)' layout with layout '(.+?)' that contains '(.*)'$/ do |filename, layout, text|
  File.open(File.join('layouts', filename + '.html'), 'w') do |f|
    f.write <<-EOF
layout: #{layout}
---
#{text}
EOF
  end
end

Given /^I have a '(.+?)' file that contains '(.*)'$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? '(.+?)' file that contains$/ do |file, text|
  FileUtils.mkdir_p(File.dirname(file))
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an '(.*?)' page(?: with (.*?) '(.*?)')?(?: and with (.*?) '(.*?)')? that contains '(.*)'$/ do |file, key, value, other_key, other_value, text|
  FileUtils.mkdir('input') unless File.directory?('input')
  File.open(file, 'w') do |f|
    f.write <<EOF
#{key}: #{value}
#{other_key + ': ' + other_value unless other_key.nil?}
---
#{text}
EOF
  end
end

When /^I run laze$/ do
  run_laze
end

When /^I run laze with minification$/ do
  run_laze(:minify => true)
end

Then /^the (.+?) directory should exist$/ do |dir|
  assert File.directory?(dir)
end

Then /^I should see '(.*)' in '(.+?)'$/ do |text, file|
  assert_match Regexp.new(text), File.open(file).readlines.join
end