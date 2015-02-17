# schemes should be array of [r, g, b]
generate = (name, schemes) ->
    gpl = """GIMP Palette
Name: #{name}
#"""
    gpl += '\n'
    schemes.forEach (scheme) ->
        gpl += scheme.join ' '
        gpl += '\n'
    gpl

module.exports = generate
