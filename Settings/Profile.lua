local W, F, E, L, V, P, G = unpack(select(2, ...))

P.combat = {
    combatAlert = {
        enable = true,
        speed = 1,
        animation = true,
        animationSize = 1,
        text = true,
        enterText = L["Enter Combat"],
        leaveText = L["Leave Combat"],
        enterColor = {r = 0.929, g = 0.11, b = 0.141, a = 1.0},
        leaveColor = {r = 1, g = 0.914, b = 0.184, a = 1.0},
        font = {name = E.db.general.font, size = 25, style = "OUTLINE"}
    },
    raidMarkers = {
        enable = true,
        mouseOver = false,
        visibility = "DEFAULT",
        backdrop = true,
        backdropSpacing = 3,
        buttonSize = 30,
        spacing = 4,
        orientation = "HORIZONTAL",
        modifier = "shift"
    }
}

P.item = {
    delete = {
        enable = true,
        delKey = true,
        fillIn = "CLICK"
    },
    alreadyKnown = {
        enable = true,
        mode = "COLOR",
        color = {
            r = 0,
            g = 1,
            b = 0
        }
    }
}

P.maps = {
    worldMap = {
        scale = 1.236
    }
}

P.skins = {
    vignetting = {
        enable = true,
        level = 30
    }
}
