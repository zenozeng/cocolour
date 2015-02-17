# schemes should be array of [r, g, b]
generate = (name, schemes) ->
    gpl = """GIMP Palette
Name: #{name}
#
"""
    schemes.forEach (scheme) ->
        gpl += '\n'
        gpl += scheme.join ' '
        gpl += "\t(#{scheme.join(', ')})"
    gpl

module.exports = generate
