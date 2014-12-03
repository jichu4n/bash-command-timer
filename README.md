bash-command-timer
==================

Bash extension for printing timing information for each command line
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

Settings
--------

You can use the following options to tweak the behavior of the script. You can
either make the changes in-place (at the top of the script) or put them after
sourcing the script in your `.bashrc`. You can also modify them on-the-fly if
you want the changes to only affect your current Bash session.

* `BCT_ENABLE=1`: Setting this to 0 disables the printing of timings.
* `BCT_COLOR='34'`: The color of the output. This should be a color string
  usable in a VT100 escape sequence (see
  [Wikipedia](http://en.wikipedia.org/wiki/ANSI_escape_code#Colors)), without
  the escape sequence prefix and suffix. For example, bold red would be
  `'1;31'`.
* `BCT_TIME_FORMAT='%b %d %I:%M%p'`: The display format of the current time.
  This is a strftime format string (see http://strftime.org/). If empty, the
  current time will not be printed.
* `BCT_MILLIS=1`: Whether to print timings to millisecond precision. If set to
  zero, will print timings up to seconds.

Details
-------
For an explanation of how the script works, you're welcome to check out my blog
post: [Hacking Bash: The DEBUG trap and
PROMPT_COMMAND](http://seasonofcode.com/posts/hacking-bash-the-debug-trap-and-prompt_command.html).
