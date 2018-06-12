fs    = require('fs')
exfs  = require('node-fs-extra')
spawn = require('child_process').spawn


task 'build', 'build task', ->

    isWin = process.platform == 'win32'

    # remove directory
    exfs.removeSync 'public'

    # create directory
    exfs.mkdirsSync dir for dir in ['public/stylesheets', 'public/javascripts', 'public/images']

    # coffee
    coffeeFiles = ('coffee/' + name for name in fs.readdirSync 'coffee' when /\.coffee$/.test name)
    
    coffeeCmd =  if isWin then 'coffee.cmd' else 'coffee'
    coffee = spawn coffeeCmd, [
        '--output', 'public/javascripts', 
        '--join', 'script.js',
        '--compile', coffeeFiles...
    ]
    
    coffee.on 'error', (err) -> 
        console.error err.toString()

    coffee.on 'exit', (code) ->
        console.log "coffee exit code: #{code}\n"

    coffee.stdout.on 'data', (data) ->
        console.log data.toString()

    coffee.stderr.on 'data', (data) ->
        console.error data.toString()

    # less
    lessCmd = if isWin then 'lessc.cmd' else 'less'
    less = spawn lessCmd, ['less/style.less', 'public/stylesheets/style.css']

    less.on 'error', (err) -> 
        console.error err.toString()

    less.on 'exit', (code) ->
        console.log "less exit code: #{code}\n"

    less.stdout.on 'data', (data) ->
        console.log data.toString()

    less.stderr.on 'data', (data) ->
        console.error data.toString()

    # copy img from 'img' to 'public/images'
    exfs.copySync('img/' + name, 'public/images/' + name) for name in fs.readdirSync 'img'