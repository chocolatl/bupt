# IE9 classList shim
(-> 
    classListMethod = 
        contains:
            (className) -> @el.className.search(new RegExp("(^| )#{className}( |$)")) isnt -1
        add: 
            (className) -> 
                unless @el.classList.contains(className)
                    if @el.className == "" then @el.className += className else @el.className += " " + className
        remove: 
            (className) -> @el.className = @el.className.replace(new RegExp("(^| )#{className}( |$)"), "")

    ClassList = (@el) -> @

    ClassList.prototype[k] = v for k, v of classListMethod

    unless window.DOMTokenList?
        Object.defineProperty Element.prototype, "classList", get: -> new ClassList(this);

)()

