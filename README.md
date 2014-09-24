webscript-puppet
================

a prototype slack bot written for the webscript.io environment


Slack configuration
-------------------

Requires two integrations:

    - a slash command to send input to the script
    - an incoming webhook for the script to post as a "bot"

Incoming webhook and command configuration is at the top of the script. If the slash command doesn't match the command in the script, it will return `404`.

Input format is `<name> <icon> <message>`

Only emojis may be used as icons. The icon will be stored using webscript storage, allowing the user to omit it the next time the bot is named.
