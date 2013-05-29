# Based on https://raw.github.com/skwp/dotfiles/master/Rakefile
# Modified by: perok
require 'rake'

task :default => ["install"]

task :install  => [:submodule_init, :submodules] do
	puts
	puts_cool("Welcome to the dotfiles install procedure")
	puts "This is intended for linux based OS. Please, only continue if you're a silly adventurer-" if not RUBY_PLATFORM.downcase.include?("linux")
	puts

	install_binaries if want_to_install?('Install required and recommended binaries')
	install_vim_janus if want_to_install?('VIM Janus suite')
	install_oh_my_zsh if want_to_install?('ZSH oh-my-zsh suite')
	install_symlinks if want_to_install?('Symlink the dotfiles?')
	setup_ranger if want_to_install?('Set up ranger')
	
	puts
	success("installed")
end

task :update do
	puts_cool("Updating dotfiles")
	run %{git pull origin master}
	puts 
	puts_cool("Updating submodules")
	Rake::Task[submodule_init].execute
	puts
	puts_cool("Updating Janus")
	run %{cd ~/.vim && rake}
	puts
	puts_cool("Symlinking dotfiles again to be sure")
	Rake:Task[symlink_dotfiles].execute

	success("updated")
end

task :uninstall do
	puts "Not implemented"
end


task :submodule_init do
  unless ENV["SKIP_SUBMODULES"]
    run %{ git submodule update --init --recursive }
  end
end

task :submodules do
  unless ENV["SKIP_SUBMODULES"]
    puts_cool("Downloading dotfiles submodules...please wait")

    run %{
      cd $HOME/.dotfiles
      git submodule foreach 'git fetch origin; git checkout master; git reset --hard origin/master; git submodule update --recursive; git clean -df'
      git clean -df
    }
    puts
  end
end

task :symlink_dotfiles do
	puts "Symlinking the files in symlinks/ to $HOME"
	file_operation(Dir.glob('symlinks/*'))
	puts
end

def install_binaries
	puts_cool("Installing required binaries. Enjoy..")
	run %{
		sudo apt-get remove vim-tiny 
		sudo apt-get install zsh ack ctags ruby vim tmux
		}
	# Add other installs aswell. Oracle java, etc..
	install_pygmentizer

	puts

	if want_to_install_anyways?('Ranger - filebrowser')
		run %{sudo apt-get install ranger highlight caca-utils w3m poppler-utils mediainfo atool}
		setup_ranger
	end

	if want_to_install_anyways?('Oracle Java from webupd8 PPA')
		puts "implement it!"
	end

	if want_to_install_anyways?('xfce4.12 webupd8 PPA')
		puts "implement it!"
	end

	
end

def install_pygmentizer
	#Setup pygmentizer for lessfilter.sh
	puts_cool("Installing pygmentizer")
	run %{ sudo apt-get install python-setuptools }
	run %{ sudo easy_install pygments }
	puts
end

def install_vim_janus
	puts 
	puts_cool("Now entering Janus install procedure")
	puts

	run %{curl -Lo- https://bit.ly/janus-bootstrap | bash}

	puts 
	puts_cool("Janus install procedure complete")
	puts
end

def install_oh_my_zsh
	puts 
	puts_cool("Now entering oh-my-zsh install procedure")
	puts

	run %{curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh}

	if not ENV["SHELL"].include? 'zsh' then
		puts "Setting zsh as your default shell"
		run %{ chsh -s /bin/zsh }
	end

	puts 
	puts_cool("oh-my-zsh install procedure complete")
	puts
	puts "Linking oh-my-zsh with the dotfiles"
	run %{echo 'source $HOME/.dotfiles/zsh/zshrc.zsh' >> ~/.zshrc}
	puts
end

def install_symlinks
	puts 
	puts_cool("Symlinking all the dotfiles to your home directory.")
	Rake:Task[symlink_dotfiles].execute
	puts
end

def setup_ranger
	puts
	puts_cool("Setting up ranger config files")
	puts "in  ~/.config/ranger"
	run %{ranger --copy-config=all}
	puts
	puts "Be aware of a bug in Linux Mint. See the readme if you can't preview files."
	puts
end

private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def want_to_install? (section)
  if ENV["ASK"]=="true"
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    true
  end
end

def want_to_install_anyways? (section)
	puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
	STDIN.gets.chomp == 'y'
end

def file_operation(files, method = :symlink)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV["PWD"]}/#{f}"
    target = "#{ENV["HOME"]}/.#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup... [y] or [d]elete"

      if STDIN.gets.chomp == 'y'
      	run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
      else
      	run %{ rm "$HOME/.#{file}"}
      end
    end

    if method == :symlink
      run %{ ln -nfs "#{source}" "#{target}" }
    else
      run %{ cp -f "#{source}" "#{target}" }
    end

    # Temporary solution until we find a way to allow customization
    # This modifies zshrc to load all of yadr's zsh extensions.
    # Eventually yadr's zsh extensions should be ported to prezto modules.
    #if file == 'zshrc'
    #  File.open(target, 'a') do |zshrc|
    #    zshrc.puts('for config_file ($HOME/.yadr/zsh/*.zsh) source $config_file')
    #  end
    #end

    puts "=========================================================="
    puts
  end
end

def puts_cool(msg)
	puts "======================================================"
    puts msg
    puts "======================================================"
end

def success(msg)
	puts "GZ"
	puts "I iz #{msg}. Restart your terminal" 
end
