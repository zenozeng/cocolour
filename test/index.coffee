#
# @file 神经网络预测命中率测试
#

fs = require 'fs'
cluster = require 'cluster'
cpus = require('os').cpus()
ANN = require '../src/ann.coffee'
path = require 'path'
math = require 'mathjs'
[trainData, verifyData] = ['training', 'verify'].map (filename) ->
    filename = path.join __dirname, '../data/', filename + '.json'
    JSON.parse fs.readFileSync filename

if cluster.isMaster
    queue = [0..32] # do it 64 times
    tests = []

    info =
        cpu: cpus.length + " * " + cpus[0].model
        queue: queue.length
        trainData: trainData.length
        verifyData: verifyData.length
    console.info info

    cluster.on 'online', (worker) ->
        console.info "Worker ##{worker.process.pid} online."

    onmessage = (msg) ->
        if msg.staus is 'idle'
            if queue.pop()
                @process.send 'run'
            else
                @process.send 'exit'
        else
            tests.push msg.tests
            console.log msg

    workers = cpus.map -> cluster.fork()
    workers.forEach (worker) ->
        worker.on 'message', onmessage # on receive message from worker

    generateResults = ->
        rates = tests.map (test) -> test.rate
        res =
            tests: "#{verifyData.length} tests * #{tests.length} times = #{tests.length * verifyData.length}"
            passedRate:
                max: math.max rates
                min: math.min rates
                mean: math.mean rates
                median: math.median rates
                var: math.var rates

    cluster.on 'exit', (worker, code) ->
        workers = workers.filter (w) -> worker.process.pid isnt w.process.pid
        console.info "Worker ##{worker.process.pid} exit with code #{code}, #{workers.length} workers left."
        if workers.length is 0
            # done
            console.log JSON.stringify(generateResults(), null, 4)

else
    process.send {staus: 'idle'}
    process.on 'message', (msg) ->
        if msg is 'run'
            ann = new ANN {logPeriod: 1000}
            ann.train trainData
            process.send {tests: ann.verify(verifyData)}
            process.send {staus: 'idle'}
        if msg is 'exit'
            process.exit(0);
