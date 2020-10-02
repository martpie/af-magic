# name: L
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function prompt_pwd_full
  set -q fish_prompt_pwd_dir_length; or set -l fish_prompt_pwd_dir_length 1

  if [ $fish_prompt_pwd_dir_length -eq 0 ]
    set -l fish_prompt_pwd_dir_length 99999
  end

  set -l realhome ~
  echo $PWD | sed -e "s|^$realhome|~|" -e 's-\([^/.]{'"$fish_prompt_pwd_dir_length"'}\)[^/]*/-\1/-g'
end

function fish_prompt
  set -l blue (set_color blue)
  set -l cyan (set_color cyan)
  set -l green (set_color green)
  set -l brblack (set_color brblack)
  set -l yellow (set_color yellow)
  set -l normal (set_color normal)

  set -l separator $brblack"------------------------------------------------------------"
  set -l arrow "»"
  # set -l cwd $blue(basename (prompt_pwd))
  set -l cwd $blue(prompt_pwd_full)

  if [ (_git_branch_name) ]
    set -l parenthesis_start $cyan"("
    set -l parenthesis_end $cyan")"

    set git_info $green(_git_branch_name)
    set git_info "$parenthesis_start$git_info"

    if [ (_is_git_dirty) ]
      set -l dirty $yellow"*"
      set git_info "$git_info$dirty"
    end

    set git_info "$git_info$parenthesis_end"
  end

  echo $separator
  echo -n -s $cwd $git_info $normal ' ' $arrow ' '
end
