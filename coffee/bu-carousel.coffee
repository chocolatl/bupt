class Carousel
    configuration = null;
    imgNum = null;
    imgs = null;
    prevIndex = null;
    currentIndex = 0;
    transEnd = true;
    timerId = null;

    constructor: (el, conf) -> 
        defaultConf = 
            autoPlay: false
            autoPlayInterval: 8000
            fade: true
            move: true
            moveNextOffset: "-16px"
            movePrevOffset: "16px"
            easing: "ease-out"
            speed: "1400ms"
            zIndex: "1000"
            initDelay: 0

        defaultConf[key] = value for own key, value of conf when defaultConf[key]?
        configuration = defaultConf;

        setElementStyle el, position: "relative"

        imgs = el.querySelectorAll "* > *"
        imgNum = imgs.length

        # 如果Carousel下的是<img>
        imageCover(e for e in imgs when e.tagName is "IMG")

        for e in imgs
            setElementStyle e, 
                opacity: "0"
                position: "absolute"
                top: "0"
                left: "0"

        setElementStyle imgs[0], opacity: "1"

        if configuration.autoPlay
            window.setTimeout => 
                timerId = window.setInterval @playNext, configuration.autoPlayInterval
            , configuration.initDelay


    playPrev: => 
        return unless transEnd
        transEnd = false
        prevIndex = currentIndex
        currentIndex--
        currentIndex = imgNum - 1 if currentIndex < 0

        configuration.move and setElementStyle imgs[currentIndex], left: configuration.movePrevOffset

        toggle @

    playNext: => 
        return unless transEnd
        transEnd = false
        prevIndex = currentIndex
        currentIndex++
        currentIndex %= imgNum

        configuration.move and setElementStyle imgs[currentIndex], left: configuration.moveNextOffset

        toggle @
        
    # 私有方法
    toggle = (_this) -> 
        # 更新style
        imgs[currentIndex].clientWidth

        # 重置自动轮播计时
        window.clearInterval timerId
        timerId = window.setInterval _this.playNext, configuration.autoPlayInterval


        setElementStyle imgs[currentIndex], 
            left: "0"
            opacity: "1"
            zIndex: configuration.zIndex
            transition: "all #{configuration.speed} #{configuration.easing}"

        imgs[currentIndex].addEventListener "transitionend", -> 
            transEnd = true
            setElementStyle imgs[currentIndex],
                transition: ""
                zIndex: ""
            setElementStyle imgs[prevIndex], 
                opacity: "0"
        
        try
            # IE9
            TransitionEvent
        catch
            transEnd = true
            setElementStyle imgs[currentIndex],
                transition: ""
                zIndex: ""
            setElementStyle imgs[prevIndex], 
                opacity: "0"

    setElementStyle = (el, rules) -> 
        el.style[k] = v for k, v of rules

    # 使图片类似于父元素背景且拥有background-size: cover的表现
    imageCover = (elements) -> 
        elements = [elements] unless elements.length?
        window.addEventListener "resize", -> 
            setImageCover el for el in elements

        for el in elements
            # trigger
            setImageCover(el)
            # on image loaded
            el.addEventListener "load", ((el) -> -> setImageCover el)(el)   # 闭包传递el

    setImageCover = (el) -> 
        parent = el.parentElement
        el.style.width = "100%" if not el.style.width and not el.style.height
        [pw, ph] = [parent.clientWidth, parent.clientHeight]
        [ew, eh] = [el.width, el.height]
        if pw is 0 or ph is 0 or ew is 0 or eh is 0
            callee = arguments.callee
            window.setTimeout (-> callee el), 30
            return
        if el.style.width
            [el.style.height, el.style.width] = ["100%", ""] if ph > eh
        else if el.style.height
            [el.style.height, el.style.width] = ["", "100%"] if pw > ew

# class end



document.addEventListener "DOMContentLoaded", ->
    el = document.querySelector(".bg-carousel > .carousel")
    return unless el?

    control = new Carousel el,
        autoPlay: true
        zIndex: 900
        autoPlayInterval: 8000
        initDelay: 4000

    prev = document.querySelector(".bg-carousel > .prev")
    next = document.querySelector(".bg-carousel > .next")
    prev && (prev.onclick = control.playPrev)
    next && (next.onclick = control.playNext)
