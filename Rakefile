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
  build  
  watch "**/*.coffee" do
    build
  end
end

def test
  system "vows test/*.coffee"
end

def watch file, &block
  FSSM.monitor Dir.pwd, file do
    update &block
    create &block
    delete &block
  end
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
  sprockets "src/ambrosia.coffee", "dist/ambrosia.js"
  test
end

def sprockets infile, outfile
  environment = Sprockets::Environment.new(Dir.pwd)
  environment.append_path(".")
  out = environment.find_asset(infile).to_s
  File.open(outfile, "w+") { |f| f.write out }
end
