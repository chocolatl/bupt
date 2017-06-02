spawn = require('child_process').spawn


task 'build', 'you guess', ->

    # create directory
    spawn 'cmd', ['/c' ,'md', 'public\\stylesheets', 'public\\javascripts', 'public\\images']

    # coffee
    coffee = spawn 'node_modules\\.bin\\coffee.cmd', [
        '-c',
        '-o', 'public\\javascripts',
        '-j', 'script.js',
        'coffee\\shim.coffee', 
        'coffee\\bu-tabs.coffee', 
        'coffee\\bu-carousel.coffee', 
        'coffee\\art-navbar-fixed.coffee']
    
    coffee.on 'error', (err) -> 
        console.log err.toString()

    coffee.stdout.on 'data', (data) ->
        console.log data.toString()

    coffee.stderr.on 'data', (data) ->
        console.log data.toString()

    # less
    less = spawn 'node_modules\\.bin\\lessc.cmd', ['less\\style.less', 'public\\stylesheets\\style.css']

    less.on 'error', (err) -> 
        console.log err.toString()

    less.stdout.on 'data', (data) ->
        console.log data.toString()

    less.stderr.on 'data', (data) ->
        console.log data.toString()

    # copy img from './img' to './public/images'
    spawn 'cmd', ['/c', 'copy', '/Y', 'img\\*', 'public\\images']