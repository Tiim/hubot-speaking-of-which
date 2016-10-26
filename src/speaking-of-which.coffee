# Description
#   A hubot script that listens for predefined keywords and sends a random answer belonging to that keyword.
#
# Configuration:
#   HUBOT_SPEAKING_OF_TIMEOUT - min amount of time in sec between replys. Default: 120
#   HUBOT_SPEAKING_OF_CHANCE - chance that hubot remembers about something. Default: 50
#
# Commands:
#   hubot speaking of X: Y - makes hubot remeber Y when someone talks about X
#   hubot forget about X - makes hubot forget about X
# Notes:
#
#
# Author:
#   Tiim

module.exports = (robot) ->

  timeout = parseInt(process.env.HUBOT_SPEAKING_OF_TIMEOUT) || 120
  chance = (parseInt(process.env.HUBOT_SPEAKING_OF_CHANCE) || 50) / 100

  isTimeout = false

  isLucky = () -> Math.random() > chance
  getCommands = () -> robot.brain.get('speakingOfWhich') || []


  robot.respond /speaking of (\w*):\s*(.*)/i, (res) ->
    trigger = res.match[1].toLowerCase()
    commands = getCommands()
    if trigger.length < 3
      res.reply "I'm sorry but somehow I can't remember #{trigger}. Maybe try something more descriptive?"
      return
    response = res.match[2]
    i = commands.findIndex((c) -> c.trigger == trigger)
    if i == -1
      res.reply "I will remember '#{response}' when someone speaks about #{trigger}"
      commands.push(
        {trigger: trigger, responses: [response]}
      )
    else
      res.reply "I will remember '#{response}' too when someone speaks about #{trigger}"
      commands[i].responses.push(response)

    res.finish()
    robot.brain.set 'speakingOfWhich', commands

  robot.respond /forget about (.*)/i, (res) ->
    trigger = res.match[1].toLowerCase()
    commands = getCommands()
    i = commands.findIndex((c) -> c.trigger == trigger)
    if i == -1
      res.reply "I didn't know anything about #{trigger} to begin with"
    else
      commands.splice i, 1
      res.reply "Sure thing, i don't know anything about #{trigger} anymore"
    res.finish()

  robot.listen(
    (m) ->
      !isTimeout && isLucky() && m?.text? &&
      getCommands().find((c) -> m.text.toLowerCase().indexOf(c.trigger) != -1)
    (res) ->
      res.send "Speaking of #{res.match.trigger}:\n#{res.random(res.match.responses)}"
      isTimeout = true
      setTimeout (() -> isTimeout = false), timeout * 1000
  )
