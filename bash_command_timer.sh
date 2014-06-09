# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                             #
#    Copyright (C) 2014 Chuan Ji <jichuan89@gmail.com>                        #
#                                                                             #
#    Licensed under the Apache License, Version 2.0 (the "License");          #
#    you may not use this file except in compliance with the License.         #
#    You may obtain a copy of the License at                                  #
#                                                                             #
#     http://www.apache.org/licenses/LICENSE-2.0                              #
#                                                                             #
#    Unless required by applicable law or agreed to in writing, software      #
#    distributed under the License is distributed on an "AS IS" BASIS,        #
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#    See the License for the specific language governing permissions and      #
#    limitations under the License.                                           #
#                                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# A simple Bash script for printing timing information for each command line
# executed.
#
# For the most up-to-date version, as well as further information and
# installation instructions, please visit the GitHub project page at
#     https://github.com/jichuan89/bash-command-timer

# SETTINGS
# ========
#
# Whether to enable the command timer by default.
#
# To temporarily disable the printing of timing information, type the following
# in a session:
#     BCT_ENABLE=0
# To re-enable:
#     BCT_ENABLE=1
BCT_ENABLE=1

# The color of the output.
#
# This should be a color string  usable in a VT100 escape sequence (see
# http://en.wikipedia.org/wiki/ANSI_escape_code#Colors), without the
# escape sequence prefix and suffix. For example, bold red would be '1;31'.
BCT_COLOR='34'

# The display format of the current time.
#
# This is a strftime format string (see http://strftime.org/). To tweak the
# display format of the current time, change the following line to your desired
# pattern.
#
# If empty, disables printing of current time.
BCT_TIME_FORMAT='%b %d %I:%M%p'

# Whether to print command timings up to millisecond precision.
#
# If set to 0, will print up to seconds precision.
BCT_MILLIS=1


# IMPLEMENTATION
# ==============

# The debug trap is invoked before the execution of each command typed by the
# user (once for every command in a composite command) and again before the
# execution of PROMPT_COMMAND after the user's command finishes. Thus, to be
# able to preserve the timestamp before the execution of the first command, we
# set the BCT_AT_PROMPT flag in PROMPT_COMMAND, only set the start time if the
# flag is set and clear it after the first execution.
BCT_AT_PROMPT=1
function BCTPreCommand() {
  if [ -z "$BCT_AT_PROMPT" ]; then
    return
  fi
  unset BCT_AT_PROMPT
  BCT_COMMAND_START_TIME=$(date '+%s.%N')
}
trap 'BCTPreCommand' DEBUG

# Bash will automatically set COLUMNS to the current terminal width.
export COLUMNS

# Flag to prevent printing out the time upon first login.
BCT_FIRST_PROMPT=1
# This is executed before printing out the prompt.
function BCTPostCommand() {
  BCT_AT_PROMPT=1

  if [ -n "$BCT_FIRST_PROMPT" ]; then
    unset BCT_FIRST_PROMPT
    return
  fi

  if [ -z "$BCT_ENABLE" ] || [ "$BCT_ENABLE" -ne 1 ]; then
    return
  fi

  local command_start_time=$BCT_COMMAND_START_TIME
  local command_end_time=$(date '+%s.%N')
  # The following Python code is both Python 2.x and 3.x compatible.
  python << EOF

from __future__ import print_function
import datetime

# Break down the execution time.
command_time = ${command_end_time} - ${command_start_time}
num_days, r = divmod(command_time, 24 * 60 * 60)
num_hours, r = divmod(r, 60 * 60)
num_mins, r = divmod(r, 60)
num_secs, r = divmod(r, 1)
num_millis = r * 1000

# Humanize.
time_strings = []
if num_days:
  time_strings.append('%dd' % int(num_days))
if num_hours:
  time_strings.append('%dh' % int(num_hours))
if num_mins:
  time_strings.append('%dm' % int(num_mins))
if '${BCT_MILLIS}' == '1':
  time_strings.append('%ds%03d' % (int(num_secs), int(num_millis)))
else:
  time_strings.append('%ds' % int(num_secs))
now_string = datetime.datetime.fromtimestamp(${command_end_time}).strftime(
    '${BCT_TIME_FORMAT}')
if now_string:
  output_string = '[ %s | %s ]' % (' '.join(time_strings), now_string)
else:
  output_string = '[ %s ]' % ' '.join(time_strings)
output_string_colored = '\033[${BCT_COLOR}m%s\033[0m' % output_string

# Print.
num_spaces = ${COLUMNS} - len(output_string)
print('\r%s%s' % (' ' * num_spaces, output_string_colored), end=None)

EOF
}
PROMPT_COMMAND='BCTPostCommand'
