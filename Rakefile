require "rubygems"
require "sprockets"
require "fssm"

task :build do
  build
end

task :test do
  test
end

task :watch do
  puts "Watching filesystem"
  watcher = FSEvent.new
  watcher.watch ["src", "test"] do
    build
  end
  watcher.run
end

def test
  system "vows test/*.coffee"
end

def reload_browser
  
  puts "Reloading browser..."
  
  commands = [
    { :tell => "Google Chrome", :to => "activate" },
    { :tell => "System Events", :to => "keystroke \"r\" using command down" },
    { :tell => "TextMate", :to => "activate" }
  ]
  
  commands.each do |command|
    %x[osascript -e 'tell application "#{command[:tell]}" to #{command[:to]}']
  end
  
end

def build
  puts "Building..."
  Dir.mkdir "dist" if !Dir.exists? "dist"
  sprockets "src/main.coffee", "dist/ambrosia.js"
  test
end

def sprockets infile, outfile
  environment = Sprockets::Environment.new(Dir.pwd)
  environment.append_path(".")
  out = environment.find_asset(infile).to_s
  File.open(outfile, "w+") { |f| f.write out }
end
