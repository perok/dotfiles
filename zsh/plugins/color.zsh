# Prints the 256 color spectrum
function spectrum_ls() {
    for code in {000..255}; do
        print -P -- "$code: %F{$code}Test%f"
    done
}

#Forces all colors output
function spectrum_force() {
    echo "Number of colors supported: "
    tput colors
    for ((x=0; x<=255; x++));do 
        echo -e "${x}:\033[48;5;${x}mcolor\033[000m";
    done
}
