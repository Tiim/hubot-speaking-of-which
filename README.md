# hubot-speaking-of-which

A hubot script that listens for predefined keywords and sends a random answer belonging to that keyword.

See [`src/speaking-of-which.coffee`](src/speaking-of-which.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-speaking-of-which --save`

Then add **hubot-speaking-of-which** to your `external-scripts.json`:

```json
["hubot-speaking-of-which"]
```

## Sample Interaction

```
user1>> hubot speaking of oscar: Leonardo Di Caprio won one!
hubot>> I will remember 'Leonardo Di Caprio won one!' when someone speaks about oscar

user1>> so how did the oscars go?
hubot>> Speaking of oscar:
        Leonardo Di Caprio won one!

user1>> hubot forget about oscar
hubot>> Sure thing, i don't know anything about oscar anymore
```
