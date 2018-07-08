
# Java path setup
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_HOME=$JAVA_8_HOME
alias java8='export JAVA_HOME=$JAVA_8_HOME'

# Python 3.7 is installed from Brew. Source bins from 'pip --user'
export PATH=$PATH:~/Library/Python/3.7/bin/
