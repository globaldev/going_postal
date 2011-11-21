Gem::Specification.new do |s|
  s.name = "going_postal"
  s.version = "0.1.0"
  s.summary = "Global post/zip code formatting and validation mixin"
  s.description = "Post/zip code formatting and validation for the UK, US, CA and more."
  s.files = %W{lib}.map {|dir| Dir["#{dir}/**/*.rb"]}.flatten << "README.rdoc"
  s.require_path = "lib"
  s.rdoc_options = ["--main", "README.rdoc", "--charset", "utf-8"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.author = "Matthew Sadler"
  s.email = "mat@sourcetagsandcodes.com"
  s.homepage = "http://github.com/globaldev/going_postal"
end
