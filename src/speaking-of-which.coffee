# Description
#   A hubot script that listens for predefined keywords and sends a random answer belonging to that keyword.
#
# Configuration:
#
#
# Commands:
#   hubot speaking of X: Y - makes hubot remeber Y when someone talks about X
#
# Notes:
#
#
# Author:
#   Tiim

module.exports = (robot) ->

  # load brain
  commands = robot.brain.get('speakingOfWhich')
  unless commands?
    commands = []


  robot.respond /speaking of (\w*):\s*(.*)/i, (res) ->
    trigger = res.match[1].toLowerCase()
    response = res.match[2]
    i = commands.findIndex((c) -> c.trigger == trigger)
    if (i == -1)
      res.reply "I will remember '#{response}' when someone speaks about #{trigger}"
      commands.push(
        {trigger: trigger, responses: [response]}
      )
    else
      res.reply "I will remember '#{response}' too when someone speaks about #{trigger}"
      commands[i].responses.push(response)

    robot.brain.set 'speakingOfWhich', commands

  robot.respond /forget about (.*)/i, (res) ->
    trigger = res.match[1].toLowerCase()
    i = commands.findIndex((c) -> c.trigger == trigger)
    if i == -1
      res.reply "I didn't know anything about #{trigger} to begin with"
    else
      commands.splice i, 1
      res.reply "Sure thing, i don't know anything about #{trigger} anymore"


  robot.listen(
    (m) ->
      if m?.text?
        commands.findIndex((c) -> m.text
          .toLowerCase().indexOf(c.trigger) != -1) + 1
      else false
    (res) ->
      res.send "Speaking of #{commands[res.match - 1].trigger}:\n#{res.random(commands[res.match - 1].responses)}"
  )
