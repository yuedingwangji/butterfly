try
    document.createEvent("TouchEvent")
    virtual_input = true
catch e
    virtual_input = false


if virtual_input
    ctrl = false
    alt = false
    first = true
    virtual_input = document.createElement 'input'
    virtual_input.type = 'password'
    virtual_input.style.position = 'fixed'
    virtual_input.style.top = 0
    virtual_input.style.left = 0
    virtual_input.style.border = 'none'
    virtual_input.style.outline = 'none'
    virtual_input.style.opacity = 0
    virtual_input.value = '0'
    document.body.appendChild virtual_input

    virtual_input.addEventListener 'blur', ->
        setTimeout((=> @focus()), 10)

    addEventListener 'click', ->
        virtual_input.focus()

    addEventListener 'touchstart', (e) ->
        if e.touches.length == 1
            ctrl = true
        else if e.touches.length == 2
            ctrl = false
            alt = true
        else if e.touches.length == 3
            ctrl = true
            alt = true

    virtual_input.addEventListener 'keydown', (e) ->
         term.keyDown(e)
         return true

    virtual_input.addEventListener 'input', (e) ->
        len = @value.length

        if len == 0
            e.keyCode = 8
            term.keyDown e
            @value = '0'
            return true

        e.keyCode = @value.charAt(1).charCodeAt(0)

        if (ctrl or alt) and not first
            e.keyCode = @value.charAt(1).charCodeAt(0)
            e.ctrlKey = ctrl
            e.altKey = alt
            if e.keyCode >= 97 && e.keyCode <= 122
                e.keyCode -= 32
            term.keyDown e
            @value = '0'
            ctrl = alt = false
            return true

        term.keyPress e
        first = false
        @value = '0'
        true