#Show the number of stopped jobs
# TODO: Integrate this with the PS1
function stoppedjobs {
    jobs -s | wc -l | sed -e "s/ //g"
}

#Show all the possible prompts from prezto
function promptshowall {
    prompt -l | tail -n +2 | awk '{print $0}' RS=' ' | prompt -p
}
