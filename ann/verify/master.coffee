spawn = require('child_process').spawn
fs = require 'fs'

cpus = require('os').cpus().map (cpu) -> cpu.model
console.log cpus

N = 8 * 8
lunched = 0
done = 0

logs = []

fork = ->
    lunched++
    ((nth)->
        stdout = ""
        slave = spawn 'coffee', ['slave.coffee']
        slave.stdout.on 'data', (data) ->
            console.log "SLAVE##{nth}: " + data
            stdout += data
        slave.on 'close', ->
            done++
            console.log "SLAVE##{nth} closed"
            logs[nth-1] = stdout
            if done == N
                callback(logs)
            else
                if lunched < N
                    fork()
    )(lunched)

callback = (logs) ->
    logs = logs.filter (log) -> log?
    logs = logs.map (log) ->
        tests: parseInt log.match(/Tests: *(.*)\n/)[1]
        passed: parseInt log.match(/Passed Tests: *(.*)\n/)[1]
        rate: parseFloat log.match(/Rate\(%\): *(.*)\n/)[1]
    console.log logs

    tests = 0
    passed = 0
    logs.forEach (log) ->
        tests += log.tests
        passed += log.passed
    console.log {tests: tests, passed: passed, rate: passed / tests}

cpus.forEach -> fork()
