class BuTabs

    getTabs: -> @el.querySelectorAll "* > .tab"

    getShowTab: -> @el.querySelector "* > .tab.show"

    getBaseTabs: -> @el.querySelectorAll "* > .tab:not(.show)"

    constructor: (@el, @conf) -> 
        @setPosition()
        @bindClickEvent()
        window.addEventListener "resize", => @setPosition()

    setPosition: => 
        docuWidth = document.documentElement.clientWidth

        # 获得最匹配的宽度规则
        matchingWidth = -1
        (matchingWidth = w if docuWidth > +w > matchingWidth) for w of @conf
        rule = @conf[matchingWidth]

        # 设置定位
        baseTabs = @getBaseTabs()
        showTab =  @getShowTab()
        basePos = rule.posBase
        showPos = rule.posShow
        for i in [0...basePos.length]
            setElementPosition baseTabs[i], basePos[i]
            
        setElementPosition showTab, showPos

    bindClickEvent: =>
        for e in @getTabs()
            e.addEventListener "click", (ev) => 
                tab = ev.currentTarget
                show = @getShowTab()
                
                return if tab.classList.contains "show"

                swapPosition tab, show
                tab.classList.add "show"
                show.classList.remove "show"

                # 修复IE下.block中元素的渐显动画只有第一次切换选项卡会执行的BUG
                if isIE10() or isIE11()
                    show.addEventListener "transitionend", (e) -> 
                        e.currentTarget.removeEventListener "transitionend", arguments.callee
                        block = show.querySelector "* > .block"
                        block.replaceNode block.cloneNode(true)
                        

    # 私有方法
    swapPosition = (a,b) -> 
        [
            a.style.top, a.style.left,
            b.style.top, b.style.left
        ] = [
            b.style.top, b.style.left,
            a.style.top, a.style.left
        ]

    setElementPosition = (e, pos) -> 
        e.style.left = pos.x + "px"
        e.style.top = pos.y + "px"

    isIE11 = -> return navigator.userAgent.indexOf("rv:11") isnt -1

    isIE10 = -> return navigator.userAgent.indexOf("MSIE 10.0") isnt -1

# class end



document.addEventListener "DOMContentLoaded", ->
    # key: min-width
    conf = 
        0:
            posBase: [
                {x: 0 * 103, y: 0 * 103}
                {x: 1 * 103, y: 0 * 103}
                {x: 0 * 103, y: 1 * 103}
                {x: 1 * 103, y: 1 * 103}
                {x: 6 * 103, y: 0 * 103}
                {x: 7 * 103, y: 0 * 103}
                {x: 6 * 103, y: 1 * 103}
                {x: 7 * 103, y: 1 * 103}
            ]
            posShow: x: 2 * 103, y: 0 * 103

        1330:
            posBase: [
                {x: 0 * 103, y: 0 * 103}
                {x: 1 * 103, y: 0 * 103}
                {x: 0 * 103, y: 1 * 103}
                {x: 1 * 103, y: 1 * 103}
                {x: 7 * 103, y: 0 * 103}
                {x: 8 * 103, y: 0 * 103}
                {x: 7 * 103, y: 1 * 103}
                {x: 8 * 103, y: 1 * 103}
            ]
            posShow: x: 2 * 103, y: 0 * 103

    el = document.querySelector(".bu-tabs")
    
    new BuTabs(el, conf) if el?
