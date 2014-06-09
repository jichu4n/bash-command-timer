bash-command-timer
==================

Simple Bash script for printing timing information for each command line
executed.

Usage
-----

After the execution of each command line, the script prints out the total
execution time (up to millisecond precision), followed by the current time. The
execution time is formatted to be human readable; e.g., `2h 7m 42s301`.

Demo:

![Demo Screen-cap](https://github.com/jichuan89/bash-command-timer/raw/master/bash_command_timer_screenshot.gif)

Installation
------------

This script requires Python (either Python 2.x or 3.x) to be installed. Note
that it will also conflict with any other script that uses the DEBUG trap and
`PROMPT_COMMAND`.

To set up this script, you can

1. Download `bash_command_timer.sh` somewhere, and add the following to your
   `~/.bashrc` (replace with actual path where you saved the script):
   ```bash
   source ~/.bash_command_timer.sh
   ```
2. Alternatively, you can simply copy and paste the contents of
   `bash_command_timer.sh` into your `~/.bashrc`.

That's it :)

Details
-------
For an explanation of how the script works, you're welcome to check out my blog
post: [Hacking Bash: The DEBUG trap and
PROMPT_COMMAND](http://seasonofcode.com/posts/hacking-bash-the-debug-trap-and-prompt_command.html).
