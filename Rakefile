# Based on https://raw.github.com/skwp/dotfiles/master/Rakefile
# Modified by: perok
require 'rake'

task :default => ["install"]

task :install  => [:submodule_update, :submodules] do
    puts
    puts_big("Welcome to the dotfiles install procedure")
    puts "This is intended for linux based OS's. Please, only continue if you're a silly adventurer." if not RUBY_PLATFORM.downcase.include?("linux")
    puts
    ENV["ASK"] = "true"
    Rake::Task["install_binaries"].execute    if want_to_install?('Install required and recommended binaries')
    Rake::Task["install_spf13"].execute       if want_to_install?('spf13: VIM config')
    Rake::Task["install_prezto"].execute      if want_to_install?('Prezto: ZSH config')
    Rake::Task["symlink"].execute             if want_to_install?('Symlink the dotfiles?')
    ENV.delete("ASK")
    puts
    success("installed")
end

task :update do
    puts_big("Updating dotfiles")
    run %{git pull origin master}
    puts
    puts_big("Updating submodules")
    Rake::Task["submodule_update"].execute
    puts
    puts_big("Updating spf13")
    run %{
        cd ~/.spf13-vim-3 && git pull
        vim +BundleInstall! +BundleClean +q
    }
    puts
    puts_big("Updating Prezto")
    run %{cd ~/.prezto && git pull}
    puts
    puts_big("Symlinking dotfiles again to be sure")
    Rake:Task[symlink].execute
    success("updated")
end

task :uninstall do
    puts "Not implemented"
end

task :submodule_update do
    unless ENV["SKIP_SUBMODULES"]
        run %{ git submodule update --init --recursive }
    end
end

task :submodules do
    unless ENV["SKIP_SUBMODULES"]
        puts_big("Downloading dotfiles submodules...please wait")

        run %{
            cd $HOME/.dotfiles
            git submodule foreach 'git fetch origin; git checkout master; git reset --hard origin/master; git submodule update --recursive; git clean -df'
            git clean -df
        }
        puts
    end
end

task :symlink do
    puts "Symlinking the files in symlinks/ to $HOME"
    file_operation(Dir.glob('symlinks/*'))
    puts
end

task :install_binaries do
    puts_big("Installing required binaries. Enjoy..")
    run %{
        sudo apt-get remove vim-tiny
        sudo apt-get install ack ctags ruby vim tmux
    }

    if want_to_install_anyways?('Pygmentizer')
        run %{ sudo apt-get install python-setuptools }
        run %{ sudo easy_install pygments }
    end

    puts

    if want_to_install_anyways?('Ranger - filebrowser')
        run %{sudo apt-get install ranger highlight caca-utils w3m poppler-utils mediainfo atool}
        puts "Ranger config files placed to ~/.config/ranger"
        run %{ranger --copy-config=all}
        puts "Be aware of a bug in Linux Mint. See the readme if you can't preview files."
        puts
    end
end

task :install_spf13 do
    puts
    puts_big("Installing spf13.")
    puts
    run %{curl http://j.mp/spf13-vim3 -L -o - | sh}
    puts
    puts_big("spf13 installed.")
    puts
end

task :install_prezto do
    puts
    puts_big("Starting Prezto install procedure")
    puts

    run %{git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"}

    # TODO:Needs to be in ZSH to run these.. Add sh script with #/bin/env zsh shebang?
    # Now started through zsh. Will it work??
    run %{
        setopt EXTENDED_GLOB
        for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
            ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done
    }

    if not ENV["SHELL"].include? 'zsh' then
        puts "Setting zsh as your default shell"
        run %{ chsh -s /bin/zsh }
    end

    puts
    puts_big("Prezto is installed")
    puts
    puts "~/.preztorc symlink is deleted. New linked to the dotfiles"
    run %{rm -f ~/.zpreztorc;echo 'source $HOME/.dotfiles/zsh/zshrc.zsh' > ~/.zpreztorc}
    puts
end

private
def run(cmd)
    puts "[Running] #{cmd}"
    sh "#{cmd}" unless ENV['DEBUG']
end

def want_to_install? (section)
    if ENV["ASK"] == 'true'
        puts "=> Install: #{section}? [y]es, [n]o"
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

        puts "=========================================================="
        puts
    end
end

def puts_big(msg)
    puts "======================================================"
    puts msg
    puts "======================================================"
end

def success(msg)
    puts "GZ"
    puts "I iz #{msg}. Restart your terminal"
end
