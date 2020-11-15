local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local MF = W:GetModule("MoveFrames")
local Rematch = Rematch

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local select = select
local unpack = unpack

local CollectionsJournal_LoadUI = CollectionsJournal_LoadUI
local CreateFrame = CreateFrame

local function ReskinIconButton(button)
    button:StyleButton(nil, true)
    if button.IconBorder then
        button.IconBorder:Hide()
    end

    if button.Texture then
        button.Texture:SetTexCoord(unpack(E.TexCoords))
    end

    if button.Icon then
        button.Icon:CreateBackdrop()
    end

    if button.Selected then
        button.Selected:SetTexture(E.media.blankTex)
        button.Selected:SetVertexColor(1, 1, 1, 0.3)
    end

    if button.hover and button.Icon then
        button.hover:ClearAllPoints()
        button.hover:SetAllPoints(button.Icon)
    end
end

local function ReskinCloseButton(button)
    ES:HandleCloseButton(button)
    button.Icon = E.noop
    button.SetNormalTexture = E.noop
    button.SetPushedTexture = E.noop
    button.SetHighlightTexture = E.noop
end

local function ReskinEditBox(editBox)
    ES:HandleEditBox(editBox)
    editBox.backdrop:SetOutside(0, 0)
end

local function ReskinScrollBar(scrollBar)
    ES:HandleScrollBar(scrollBar)
    scrollBar.Thumb.backdrop:ClearAllPoints()
    scrollBar.Thumb.backdrop:Point("TOPLEFT", scrollBar.Thumb, "TOPLEFT", 3, -3)
    scrollBar.Thumb.backdrop:Point("BOTTOMRIGHT", scrollBar.Thumb, "BOTTOMRIGHT", -1, 3)

    ES:HandleButton(scrollBar.BottomButton)
    local tex = scrollBar.BottomButton:GetNormalTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0)

    tex = scrollBar.BottomButton:GetPushedTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0.3)

    ES:HandleButton(scrollBar.TopButton)
    tex = scrollBar.TopButton:GetNormalTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0)

    tex = scrollBar.TopButton:GetPushedTexture()
    tex:SetTexture(E.media.blankTex)
    tex:SetVertexColor(1, 1, 1, 0.3)
end

local function ReskinXPBar(bar)
    if not bar then
        return
    end
    bar:StripTextures()
    bar:SetStatusBarTexture(E.media.normTex)
    bar:CreateBackdrop("Transparent")
end

local function ReskinCard(card) -- modified from NDui
    if not card then
        return
    end

    card:SetBackdrop(nil)
    card:CreateBackdrop("Transparent")
    S:CreateShadow(card.backdrop)

    if card.Source then
        card.Source:StripTextures()
    end

    card.Middle:StripTextures()

    if card.Middle.XP then
        ReskinXPBar(card.Middle.XP)
        card.Middle.XP:Height(15)
    end

    if card.Middle.Lore then
        F.SetFontOutline(card.Middle.Lore, E.db.general.font)
        card.Middle.Lore:SetTextColor(1, 1, 1, 1)
    end

    if card.Bottom.AbilitiesBG then
        card.Bottom.AbilitiesBG:Hide()
    end

    if card.Bottom.BottomBG then
        card.Bottom.BottomBG:Hide()
    end
end

function S:Rematch_Header()
    -- 标题
    _G.RematchJournal.TitleBg:StripTextures()
    F.SetFontOutline(_G.RematchJournal.TitleText)

    -- 宠物数目
    if _G.RematchToolbar.PetCount then
        local PetCount = _G.RematchToolbar.PetCount
        PetCount.SetHighlightTexture = E.noop
        PetCount:StripTextures()
        PetCount:CreateBackdrop()
        PetCount.backdrop:Point("TOPLEFT", 0, -3)
        F.SetFontOutline(PetCount.Total)
        F.SetFontOutline(PetCount.TotalLabel)
        F.SetFontOutline(PetCount.Unique)
        F.SetFontOutline(PetCount.UniqueLabel)
    end

    -- 右上按钮
    ReskinIconButton(_G.RematchHealButton)
    ReskinIconButton(_G.RematchBandageButton)
    ReskinIconButton(_G.RematchToolbar.SafariHat)
    ReskinIconButton(_G.RematchLesserPetTreatButton)
    ReskinIconButton(_G.RematchPetTreatButton)
    ReskinIconButton(_G.RematchToolbar.SummonRandom)
end

function S:Rematch_LeftTop()
    for _, region in pairs {_G.RematchPetPanel.Top:GetRegions()} do
        region:Hide()
    end

    if _G.RematchPetPanel.Top.SearchBox then
        local searchBox = _G.RematchPetPanel.Top.SearchBox
        ReskinEditBox(searchBox)
        searchBox:ClearAllPoints()
        searchBox:Point("TOPLEFT", _G.RematchPetPanel.Top.Toggle, "TOPRIGHT", 2, 0)
        searchBox:Point("BOTTOMRIGHT", _G.RematchPetPanel.Top.Filter, "BOTTOMLEFT", -2, 0)
    end

    ES:HandleButton(_G.RematchPetPanel.Top.Toggle)
    _G.RematchPetPanel.Top.Toggle:StripTextures()

    _G.RematchPetPanel.Top.Toggle.Texture = _G.RematchPetPanel.Top.Toggle:CreateTexture(nil, "OVERLAY")
    _G.RematchPetPanel.Top.Toggle.Texture:Point("CENTER")
    _G.RematchPetPanel.Top.Toggle.Texture:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchPetPanel.Top.Toggle.Texture:Size(14, 14)

    self:SecureHook(
        _G.Rematch,
        "SetTopToggleButton",
        function()
            if _G.RematchPetPanel.Top.Toggle.up then
                _G.RematchPetPanel.Top.Toggle.Texture:SetRotation(ES.ArrowRotation["up"])
            else
                _G.RematchPetPanel.Top.Toggle.Texture:SetRotation(ES.ArrowRotation["down"])
            end
        end
    )

    _G.RematchPetPanel.Top.Toggle:HookScript(
        "OnEnter",
        function(self)
            if self.Texture then
                self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
            end
        end
    )

    _G.RematchPetPanel.Top.Toggle:HookScript(
        "OnLeave",
        function(self)
            if self.Texture then
                self.Texture:SetVertexColor(1, 1, 1)
            end
        end
    )

    _G.RematchPetPanel.Top.Toggle:HookScript(
        "OnClick",
        function(self)
            self:SetNormalTexture("")
            self:SetPushedTexture("")
            if self.up then
                self.Texture:SetRotation(ES.ArrowRotation.up)
            else
                self.Texture:SetRotation(ES.ArrowRotation.down)
            end
        end
    )

    ES:HandleButton(_G.RematchPetPanel.Top.Filter)

    _G.RematchPetPanel.Top.Filter.Arrow:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchPetPanel.Top.Filter.Arrow:SetRotation(ES.ArrowRotation.right)
end

function S:Rematch_LeftBottom()
    if not _G.RematchPetPanel.List then
        return
    end

    local list = _G.RematchPetPanel.List

    list.Background:Kill()
    list:CreateBackdrop()
    list.backdrop:SetOutside(list, -1, -1)
    ReskinScrollBar(list.ScrollFrame.ScrollBar)
end

function S:Rematch_Footer()
    -- Tabs
    for _, tab in pairs {_G.RematchJournal.PanelTabs:GetChildren()} do
        tab:StripTextures()
        tab:CreateBackdrop("Transparent")
        tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
        tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
        F.SetFontOutline(tab.Text)
        self:CreateBackdropShadowAfterElvUISkins(tab)
    end

    -- Buttons
    ES:HandleButton(_G.RematchBottomPanel.SummonButton)
    ES:HandleButton(_G.RematchBottomPanel.SaveButton)
    ES:HandleButton(_G.RematchBottomPanel.SaveAsButton)
    ES:HandleButton(_G.RematchBottomPanel.FindBattleButton)
    ES:HandleCheckBox(_G.RematchBottomPanel.UseDefault)

    hooksecurefunc(
        _G.RematchJournal,
        "SetupUseRematchButton",
        function()
            if _G.UseRematchButton then
                ES:HandleCheckBox(_G.UseRematchButton)
            end
        end
    )
end

function S:Rematch_Dialog() -- Modified from NDui
    if not _G.RematchDialog then
        return
    end

    -- Background
    local dialog = _G.RematchDialog
    dialog:StripTextures()
    dialog.Prompt:StripTextures()
    dialog:CreateBackdrop("Transparent")
    self:CreateShadow(dialog.backdrop)

    -- Buttons
    ReskinCloseButton(dialog.CloseButton)
    ES:HandleButton(dialog.Accept)
    ES:HandleButton(dialog.Cancel)

    -- Icon selector
    ReskinIconButton(dialog.Slot)
    ReskinEditBox(dialog.EditBox)
    dialog.TeamTabIconPicker:StripTextures()
    dialog.TeamTabIconPicker:CreateBackdrop()
    ES:HandleScrollBar(dialog.TeamTabIconPicker.ScrollFrame.ScrollBar)
    hooksecurefunc(
        _G.RematchTeamTabs,
        "UpdateTabIconPickerList",
        function()
            -- modified from NDui
            local buttons = dialog.TeamTabIconPicker.ScrollFrame.buttons
            for i = 1, #buttons do
                local line = buttons[i]
                for j = 1, 10 do
                    local button = line.Icons[j]
                    if button and not button.windStyle then
                        button:Size(26, 26)
                        button.Icon = button.Texture
                        ReskinIconButton(button)
                        button.windStyle = true
                    end
                end
            end
        end
    )

    -- Checkbox
    ES:HandleCheckBox(dialog.CheckButton)

    -- Collection
    local collection = dialog.CollectionReport
    hooksecurefunc(
        Rematch,
        "ShowCollectionReport",
        function()
            for i = 1, 4 do
                local bar = collection.RarityBar[i]
                bar:SetTexture(E.media.normTex)
            end
            if not collection.RarityBarBorder.backdrop then
                collection.RarityBarBorder:StripTextures()
                collection.RarityBarBorder:CreateBackdrop("Transparent")
                collection.RarityBarBorder.backdrop:SetInside(collection.RarityBarBorder, 6, 5)
            end
        end
    )

    hooksecurefunc(
        collection,
        "UpdateChart",
        function()
            for i = 1, 10 do
                local col = collection.Chart.Columns[i]
                col.Bar:SetTexture(E.media.blankTex)
                col.IconBorder:Hide()
            end
        end
    )
    collection.Chart:StripTextures()
    collection.Chart:CreateBackdrop("Transparent")
    ES:HandleRadioButton(collection.ChartTypesRadioButton)
    ES:HandleRadioButton(collection.ChartSourcesRadioButton)
end

function S:Rematch_PetCard()
    if not _G.RematchPetCard then
        return
    end

    local petCard = _G.RematchPetCard
    petCard:StripTextures()
    petCard.Title:StripTextures()
    petCard:CreateBackdrop("Transparent")
    self:CreateShadow(petCard.backdrop)
    ReskinCloseButton(petCard.CloseButton)
    ES:HandleNextPrevButton(petCard.PinButton, "up")
    petCard.PinButton:ClearAllPoints()
    petCard.PinButton:Point("TOPLEFT", 3, -3)
    ReskinCard(petCard.Front)
    ReskinCard(petCard.Back)

    for i = 1, 6 do
        local button = petCard.Front.Bottom.Abilities[i]
        button.IconBorder:Kill()
        select(8, button:GetRegions()):SetTexture(nil)
        ReskinIconButton(button.Icon)
    end
end

function S:Rematch()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
        return
    end

    if not _G.RematchJournal then
        return
    end

    -- Background
    _G.RematchJournal:StripTextures()
    _G.RematchJournal.portrait:Hide()
    _G.RematchJournal:CreateBackdrop()
    self:CreateShadow(_G.RematchJournal.backdrop)
    ES:HandleCloseButton(_G.RematchJournal.CloseButton)

    -- Main Window
    self:Rematch_Header()
    self:Rematch_LeftTop()
    self:Rematch_LeftBottom()
    self:Rematch_Footer()

    -- Misc
    self:Rematch_Dialog()
    self:Rematch_PetCard()

    -- Right tabs
    self:SecureHook(
        _G.RematchTeamTabs,
        "Update",
        function(tabs)
            for _, tab in next, tabs.Tabs do
                if tab and not tab.windStyle then
                    tab.Background:Kill()
                    ReskinIconButton(tab)
                    self:CreateShadow(tab.Icon.backdrop)
                    tab:Size(40, 40)
                    tab.windStyle = true
                end
            end
        end
    )

    -- 中间
    ES:HandleButton(_G.RematchLoadoutPanel.Target.TargetButton)
    ES:HandleButton(_G.RematchLoadoutPanel.TargetPanel.Top.BackButton)

    -- 右边
    ES:HandleButton(_G.RematchTeamPanel.Top.Teams)
    _G.RematchTeamPanel.Top.Teams.Arrow:SetTexture(E.Media.Textures.ArrowUp)
    _G.RematchTeamPanel.Top.Teams.Arrow:SetRotation(ES.ArrowRotation.right)

    -- Compatible with Move Frames module
    if MF and MF.db and MF.db.moveBlizzardFrames then
        if not _G.CollectionsJournal then
            CollectionsJournal_LoadUI()
        end
        _G.RematchJournal.moveHandler = CreateFrame("Frame", nil, _G.RematchJournal)
        _G.RematchJournal.moveHandler:SetAllPoints(_G.RematchJournal.TitleBg)
        MF:HandleFrame(_G.RematchJournal.moveHandler, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchJournal, _G.CollectionsJournal)
        MF:HandleFrame(_G.RematchToolbar, _G.CollectionsJournal)
    end
end

S:AddCallbackForAddon("Rematch")
