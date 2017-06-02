document.addEventListener "DOMContentLoaded", ->
    navbar = document.querySelector ".art-navbar"
    navbarOffsetTop = navbar?.offsetTop

    if navbarOffsetTop?
        window.addEventListener "scroll", ->
            if document.body.scrollTop > navbarOffsetTop then navbar.classList.add "fixed" else navbar.classList.remove "fixed"
            
