local truegear = require "truegear"

local hookIds = {}
local resetHook = true



function SendMessage(context)
	if context then
		print(context .. "\n")
		return
	end
	print("nil\n")
end

function PlayAngle(event,tmpAngle,tmpVertical)

	local rootObject = truegear.find_effect(event);

	local angle = (tmpAngle - 22.5 > 0) and (tmpAngle - 22.5) or (360 - tmpAngle)
	
    local horCount = math.floor(angle / 45) + 1
	local verCount = (tmpVertical > 0.1) and -4 or (tmpVertical < 0 and 8 or 0)


	for kk, track in pairs(rootObject.tracks) do
        if tostring(track.action_type) == "Shake" then
            for i = 1, #track.index do
                if verCount ~= 0 then
                    track.index[i] = track.index[i] + verCount
                end
                if horCount < 8 then
                    if track.index[i] < 50 then
                        local remainder = track.index[i] % 4
                        if horCount <= remainder then
                            track.index[i] = track.index[i] - horCount
                        elseif horCount <= (remainder + 4) then
                            local num1 = horCount - remainder
                            track.index[i] = track.index[i] - remainder + 99 + num1
                        else
                            track.index[i] = track.index[i] + 2
                        end
                    else
                        local remainder = 3 - (track.index[i] % 4)
                        if horCount <= remainder then
                            track.index[i] = track.index[i] + horCount
                        elseif horCount <= (remainder + 4) then
                            local num1 = horCount - remainder
                            track.index[i] = track.index[i] + remainder - 99 - num1
                        else
                            track.index[i] = track.index[i] - 2
                        end
                    end
                end
            end
            if track.index then
                local filteredIndex = {}
                for _, v in pairs(track.index) do
                    if not (v < 0 or (v > 19 and v < 100) or v > 119) then
                        table.insert(filteredIndex, v)
                    end
                end
                track.index = filteredIndex
            end
        elseif tostring(track.action_type) ==  "Electrical" then
            for i = 1, #track.index do
                if horCount <= 4 then
                    track.index[i] = 0
                else
                    track.index[i] = 100
                end
            end
            if horCount == 1 or horCount == 8 or horCount == 4 or horCount == 5 then
                track.index = {0, 100}
            end
        end
    end

	truegear.play_effect_by_content(rootObject)
end

function RegisterHooks()


	for k,v in pairs(hookIds) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds = {}

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayShootHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, Shoot)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayDamageHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, Damage)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayRestoreHealthHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, Healing)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayFoodHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, Food)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayMagazineInsertedHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, MagazineInserted)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayStewHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, Stew)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:StartHeartBeatHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, StartHeartBeat)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:StopHeartBeatHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, StopHeartBeat)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayAttachHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, Attach)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayHandHitHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, HandHit)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayChamberedRoundHapticFeedback"
	local hook1, hook2 = RegisterHook(funcName, ChamberedRound)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    -- local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:BpPlayRadioHapticFeedback"
	-- local hook1, hook2 = RegisterHook(funcName, Radio)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    -- local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:PlayHMDHapticEffect"
	-- local hook1, hook2 = RegisterHook(funcName, HMD)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    -- local funcName = "/Game/Actors/BaseObject/Blueprints/BP_BaseObject.BP_BaseObject_C:OnGrip"
	-- local hook1, hook2 = RegisterHook(funcName, OnGrip)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    -- local funcName = "/Game/Actors/BaseObject/Blueprints/BP_BaseObject.BP_BaseObject_C:OnGripRelease"
	-- local hook1, hook2 = RegisterHook(funcName, OnGripRelease)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Misc/AllLevels/BP_BaseGameState.BP_BaseGameState_C:PlayerDied"
	local hook1, hook2 = RegisterHook(funcName, PlayerDied)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/Objects/Drill/Blueprints/BP_Drill.BP_Drill_C:DrillStartTimeline__UpdateFunc"
	local hook1, hook2 = RegisterHook(funcName, DrillStartTimeline__UpdateFunc)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/Objects/Drill/Blueprints/BP_Drill.BP_Drill_C:DrillStopTimeline__UpdateFunc"
	local hook1, hook2 = RegisterHook(funcName, DrillStopTimeline__UpdateFunc)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/Objects/Flashlight/Blueprints/BP_FlashLight.BP_FlashLight_C:ToggleLightTrigger"
	local hook1, hook2 = RegisterHook(funcName, LightTrigger)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:InputCrouchToggle"
	local hook1, hook2 = RegisterHook(funcName, InputCrouchToggle)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:ReleaseMagazine"
	local hook1, hook2 = RegisterHook(funcName, ReleaseMagazine)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/VRExpansionPlugin.VRGripScriptBase:OnGrip"
	local hook1, hook2 = RegisterHook(funcName, OnGrip)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/VRExpansionPlugin.VRGripScriptBase:OnGripRelease"
	local hook1, hook2 = RegisterHook(funcName, OnGripRelease)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/Survive.Native_BasePc:OpenBackpack"
	local hook1, hook2 = RegisterHook(funcName, OpenBackpack)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/Survive.Native_BasePc:CloseBackpack"
	local hook1, hook2 = RegisterHook(funcName, CloseBackpack)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:HandleTeleport"
	local hook1, hook2 = RegisterHook(funcName, HandleTeleport)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }



        
    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:InteractWithObject"
	local hook1, hook2 = RegisterHook(funcName, InteractWithObject)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
        
    local funcName = "/Game/Actors/BasePc/Blueprints/BP_BasePc.BP_BasePc_C:InteractWithWeapon"
	local hook1, hook2 = RegisterHook(funcName, InteractWithWeapon)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
        

end

local leftHandItem = nil
local rightHandItem = nil
local canLeftHandDrill = false
local canRightHandDrill = false
local canHeartBeat = false
local lastTeleport = false
-- *******************************************************************

function InteractWithObject(self,Object,Component,hand)
    if self:get().Owner.bIsLocalPlayerController then
        SendMessage("--------------------------------")
        SendMessage("InteractWithObject")
        if hand:get() == 0 then
            SendMessage("LeftHandInteract")
            truegear.play_effect_by_uuid("LeftHandInteract")
        else
            SendMessage("RightHandInteract")
            truegear.play_effect_by_uuid("RightHandInteract")
        end

        SendMessage(tostring(hand:get()))
    end
end

function InteractWithWeapon(self,Weapon,ToggleAttachment,AttachmentType,ToggleFireMode)
    if self:get().Owner.bIsLocalPlayerController then
        SendMessage("--------------------------------")
        SendMessage("InteractWeapon")
        if leftHandItem == Weapon:get():GetFullName() and leftHandItem ~= nil then
            SendMessage("LeftHandInteract")
            truegear.play_effect_by_uuid("LeftHandInteract")
        elseif rightHandItem == Weapon:get():GetFullName()  and rightHandItem ~= nil then
            SendMessage("RightHandInteract")
            truegear.play_effect_by_uuid("RightHandInteract")
        end
        SendMessage(Weapon:get():GetFullName())
    end
end




function HandleTeleport(self,Pressed,hand)
    if self:get().Owner.bIsLocalPlayerController then
        if lastTeleport == true and Pressed:get() == false then
            SendMessage("--------------------------------")
            SendMessage("Teleport")
            truegear.play_effect_by_uuid("Teleport")
            SendMessage(tostring(Pressed:get()))
            SendMessage(tostring(hand:get()))
        end
        lastTeleport = Pressed:get()
    end

end

function CloseBackpack(self)
    if self:get().Owner.bIsLocalPlayerController then
        SendMessage("--------------------------------")
        SendMessage("BackpackClosed")
        truegear.play_effect_by_uuid("BackpackClosed")
    end
end

function OpenBackpack(self)
    if self:get().Owner.bIsLocalPlayerController then
        SendMessage("--------------------------------")
        SendMessage("BackpackOpened")
        truegear.play_effect_by_uuid("BackpackOpened")
    end
end

function ReleaseMagazine(self,Weapon,MotionController,Pressed)
    if self:get().Owner.bIsLocalPlayerController then
        if Weapon:get().MagazineAttachment:GetFullName() == nil then
            return
        end
        if leftHandItem == Weapon:get():GetFullName() then
            SendMessage("--------------------------------")
            SendMessage("LeftHandMagazineEjected")
            truegear.play_effect_by_uuid("LeftHandMagazineEjected")
        elseif rightHandItem == Weapon:get():GetFullName() then
            SendMessage("--------------------------------")
            SendMessage("RightHandMagazineEjected")
            truegear.play_effect_by_uuid("RightHandMagazineEjected")
        end

        SendMessage(tostring(Weapon:get().MagazineAttachment:GetFullName()))
        SendMessage(tostring(self:get():GetFullName()))
        SendMessage(tostring(Weapon:get():GetFullName()))
        SendMessage(tostring(Pressed:get()))
    end
end

function InputCrouchToggle(self)
    if self:get().Owner.bIsLocalPlayerController then
        SendMessage("--------------------------------")
        SendMessage("Crouch")
        truegear.play_effect_by_uuid("Crouch")
        SendMessage(tostring(self:get():GetFullName()))
        SendMessage(tostring(self:get().Owner.bIsLocalPlayerController))
    end
end

function LightTrigger(self)
    if leftHandItem == self:get():GetFullName() then
        SendMessage("--------------------------------")
        SendMessage("LeftHandInteract")
        truegear.play_effect_by_uuid("LeftHandInteract")
    elseif rightHandItem == self:get():GetFullName() then
        SendMessage("--------------------------------")
        SendMessage("RightHandInteract")
        truegear.play_effect_by_uuid("RightHandInteract")
    end
end

function DrillStartTimeline__UpdateFunc(self)
    if leftHandItem == self:get():GetFullName() then
        -- SendMessage("--------------------------------")
        -- SendMessage("StartLeftHandDrill")
        canLeftHandDrill = true
    elseif rightHandItem == self:get():GetFullName() then
        -- SendMessage("--------------------------------")
        -- SendMessage("StartRightHandDrill")
        canRightHandDrill = true
    end
end


function DrillStopTimeline__UpdateFunc(self)
    if leftHandItem == self:get():GetFullName() then
        -- SendMessage("--------------------------------")
        -- SendMessage("StopLeftHandDrill")
        canLeftHandDrill = false
    elseif rightHandItem == self:get():GetFullName() then
        -- SendMessage("--------------------------------")
        -- SendMessage("StopRightHandDrill")
        canRightHandDrill = false
    end
end

function PlayerDied(self,Controller)
    if Controller:get():IsLocalPlayerController() then
        SendMessage("--------------------------------")
        SendMessage("PlayerDeath")
        truegear.play_effect_by_uuid("PlayerDeath")
        SendMessage(Controller:get():GetFullName())
        SendMessage(tostring(Controller:get():IsLocalPlayerController()))
    end
end


function OnGrip(self,GrippingController,GripInformation)
    if GrippingController:get():BP_IsLocallyControlled() == false then
        return
    end
    if string.find(GrippingController:get():GetFullName(),"Left") then
        SendMessage("--------------------------------")
        SendMessage("LeftHandPickupItem")
        truegear.play_effect_by_uuid("LeftHandPickupItem")
        leftHandItem = GripInformation:get().GrippedObject:GetFullName()
    else
        SendMessage("--------------------------------")
        SendMessage("RightHandPickupItem")
        truegear.play_effect_by_uuid("RightHandPickupItem")
        rightHandItem = GripInformation:get().GrippedObject:GetFullName()
    end
    SendMessage(GrippingController:get():GetFullName())
    SendMessage(GripInformation:get().GrippedObject:GetFullName())
end

function OnGripRelease(self,GrippingController,GripInformation)
    if GrippingController:get():BP_IsLocallyControlled() == false then
        return
    end
    if string.find(GrippingController:get():GetFullName(),"Left") then
        SendMessage("--------------------------------")
        SendMessage("LeftHandRelease")
        leftHandItem = nil
    else
        SendMessage("--------------------------------")
        SendMessage("RightHandRelease")
        rightHandItem = nil
    end
    SendMessage(GrippingController:get():GetFullName())
    SendMessage(GripInformation:get().GrippedObject:GetFullName())
end

function Shoot(self,Intensity,Duration,hand,WeaponType,kickPower,rumblePower,rumbleDuration,TwoHanded)
    if TwoHanded:get() then
        if WeaponType:get() == 1 then
            SendMessage("--------------------------------")
            SendMessage("LeftHandPistolShoot")
            SendMessage("RightHandPistolShoot")
            truegear.play_effect_by_uuid("LeftHandPistolShoot")
            truegear.play_effect_by_uuid("RightHandPistolShoot")
        elseif WeaponType:get() == 2 then
            SendMessage("--------------------------------")
            SendMessage("LeftHandRifleShoot")
            SendMessage("RightHandRifleShoot")
            truegear.play_effect_by_uuid("LeftHandRifleShoot")
            truegear.play_effect_by_uuid("RightHandRifleShoot")
        else
            SendMessage("--------------------------------")
            SendMessage("LeftHandShotgunShoot")
            SendMessage("RightHandShotgunShoot")
            truegear.play_effect_by_uuid("LeftHandShotgunShoot")
            truegear.play_effect_by_uuid("RightHandShotgunShoot")
        end

    else
        if hand:get() == 0 then
            if WeaponType:get() == 1 then
                SendMessage("--------------------------------")
                SendMessage("LeftHandPistolShoot")
                truegear.play_effect_by_uuid("LeftHandPistolShoot")
            elseif WeaponType:get() == 2 then
                SendMessage("--------------------------------")
                SendMessage("LeftHandRifleShoot")
                truegear.play_effect_by_uuid("LeftHandRifleShoot")
            else
                SendMessage("--------------------------------")
                SendMessage("LeftHandShotgunShoot")
                truegear.play_effect_by_uuid("LeftHandShotgunShoot")
            end
        else
            if WeaponType:get() == 1 then
                SendMessage("--------------------------------")
                SendMessage("RightHandPistolShoot")
                truegear.play_effect_by_uuid("RightHandPistolShoot")
            elseif WeaponType:get() == 2 then
                SendMessage("--------------------------------")
                SendMessage("RightHandRifleShoot")
                truegear.play_effect_by_uuid("RightHandRifleShoot")
            else
                SendMessage("--------------------------------")
                SendMessage("RightHandShotgunShoot")
                truegear.play_effect_by_uuid("RightHandShotgunShoot")
            end
        end
    end

    SendMessage(tostring(hand:get()))
    SendMessage(tostring("WeapenType :" .. WeaponType:get()))
    SendMessage(tostring(TwoHanded:get()))
end

function Damage(self,DamageType,DamageAmount,RelativeAngle)
    if string.find(DamageType:get():GetFullName(),"GasCloudDamageType") then
        SendMessage("--------------------------------")
        SendMessage("PoisonDamage")
        truegear.play_effect_by_uuid("PoisonDamage")
        return
    end
    local angle = RelativeAngle:get()
    if angle > 0 then
        angle = 360 - angle
    else
        angle = -angle
    end
    SendMessage("--------------------------------")
    SendMessage("DefaultDamage," .. angle .. ",0")
    PlayAngle("DefaultDamage",angle,0)
    SendMessage(tostring(DamageType:get():GetFullName()))
    SendMessage(tostring(DamageAmount:get()))
end

function Healing(self,Health)
    SendMessage("--------------------------------")
    SendMessage("Healing")
    truegear.play_effect_by_uuid("Healing")
    SendMessage(tostring(Health:get()))
end

function Food(self,Type)
    if Type:get() == 1 then
        SendMessage("--------------------------------")
        SendMessage("Drinking")
        truegear.play_effect_by_uuid("Drinking")
    else
        SendMessage("--------------------------------")
        SendMessage("Eating")
        truegear.play_effect_by_uuid("Eating")
    end
    SendMessage(tostring(Type:get()))
end

function MagazineInserted(self,hand)
    if hand:get() == 0 then
        SendMessage("--------------------------------")
        SendMessage("LeftHandMagazineInserted")
        truegear.play_effect_by_uuid("LeftHandMagazineInserted")
    else
        SendMessage("--------------------------------")
        SendMessage("RightHandMagazineInserted")
        truegear.play_effect_by_uuid("RightHandMagazineInserted")
    end

    SendMessage(tostring(hand:get()))
end

function Stew(self)
    SendMessage("--------------------------------")
    SendMessage("Stew")
    truegear.play_effect_by_uuid("Stew")
end

function StartHeartBeat(self,SoundType)
    -- SendMessage("--------------------------------")
    -- SendMessage("StartHeartBeat")
    canHeartBeat = true
    SendMessage(tostring(SoundType:get()))
end

function StopHeartBeat(self,Type)
    -- SendMessage("--------------------------------")
    -- SendMessage("StopHeartBeat")
    canHeartBeat = false
    SendMessage(tostring(Type:get()))
end

function Attach(self,Attaching,SocketLocationId,hand)
    SendMessage("--------------------------------")
    SendMessage("AttackSlot")
    if Attaching:get() then
        if SocketLocationId:get() == 0 then
            SendMessage("ItemSlotInputItem")
            truegear.play_effect_by_uuid("ItemSlotInputItem")
        elseif SocketLocationId:get() == 1 then
            SendMessage("ChestSlotInputItem")
            truegear.play_effect_by_uuid("ChestSlotInputItem")
        elseif SocketLocationId:get() == 2 then
            SendMessage("LeftBackSlotInputItem")
            truegear.play_effect_by_uuid("LeftBackSlotInputItem")
        elseif SocketLocationId:get() == 3 then
            SendMessage("RightBackSlotInputItem")
            truegear.play_effect_by_uuid("RightBackSlotInputItem")
        elseif SocketLocationId:get() == 4 then
            SendMessage("LeftLegSlotInputItem")
            truegear.play_effect_by_uuid("LeftLegSlotInputItem")
        elseif SocketLocationId:get() == 5 then
            SendMessage("RightLegSlotInputItem")
            truegear.play_effect_by_uuid("RightLegSlotInputItem")
        elseif SocketLocationId:get() == 6 then
            SendMessage("PadSlotInputItem")
            truegear.play_effect_by_uuid("PadSlotInputItem")
        elseif SocketLocationId:get() == 9 then
            SendMessage("MagazineSlotInputItem")
            truegear.play_effect_by_uuid("MagazineSlotInputItem")
        end
    else
        if SocketLocationId:get() == 0 then
            SendMessage("ItemSlotOutputItem")
            truegear.play_effect_by_uuid("ItemSlotOutputItem")
        elseif SocketLocationId:get() == 1 then
            SendMessage("ChestSlotOutputItem")
            truegear.play_effect_by_uuid("ChestSlotOutputItem")
        elseif SocketLocationId:get() == 2 then
            SendMessage("LeftBackSlotOutputItem")
            truegear.play_effect_by_uuid("LeftBackSlotOutputItem")
        elseif SocketLocationId:get() == 3 then
            SendMessage("RightBackSlotOutputItem")
            truegear.play_effect_by_uuid("RightBackSlotOutputItem")
        elseif SocketLocationId:get() == 4 then
            SendMessage("LeftLegSlotOutputItem")
            truegear.play_effect_by_uuid("LeftLegSlotOutputItem")
        elseif SocketLocationId:get() == 5 then
            SendMessage("RightLegSlotOutputItem")
            truegear.play_effect_by_uuid("RightLegSlotOutputItem")
        elseif SocketLocationId:get() == 6 then
            SendMessage("PadSlotOutputItem")
            truegear.play_effect_by_uuid("PadSlotOutputItem")
        elseif SocketLocationId:get() == 9 then
            SendMessage("MagazineSlotOutputItem")
            truegear.play_effect_by_uuid("MagazineSlotOutputItem")
        end
    end
    SendMessage(tostring(Attaching:get()))
    SendMessage(tostring("SocketSlotId :" .. SocketLocationId:get()))
    SendMessage(tostring(hand:get()))
end

function HandHit(self,Intensity,Duration,hand)
    
    SendMessage("--------------------------------")
    if Intensity:get() >= 1 then
        if hand:get() == 0 then
            SendMessage("LeftHandMeleeHit")
            truegear.play_effect_by_uuid("LeftHandMeleeHit")
        else
            SendMessage("RightHandMeleeHit")
            truegear.play_effect_by_uuid("RightHandMeleeHit")
        end
    else
        if hand:get() == 0 then
            SendMessage("LeftHandTouch")
            truegear.play_effect_by_uuid("LeftHandTouch")
        else
            SendMessage("RightHandTouch")
            truegear.play_effect_by_uuid("RightHandTouch")
        end
    end

    SendMessage(tostring(Intensity:get()))
    SendMessage(tostring(Duration:get()))
    SendMessage(tostring(hand:get()))
end

function ChamberedRound(self,BackMovement,hand)
    if hand:get() == 0 then
        SendMessage("--------------------------------")
        SendMessage("LeftHandChamber")
        truegear.play_effect_by_uuid("LeftHandChamber")
    else
        SendMessage("--------------------------------")
        SendMessage("RightHandChamber")
        truegear.play_effect_by_uuid("RightHandChamber")
    end
    SendMessage(tostring(BackMovement:get()))
    SendMessage(tostring(hand:get()))
end

function Radio(self)
    SendMessage("--------------------------------")
    SendMessage("Radio")
end

function HMD(self,HapticEffect)
    SendMessage("--------------------------------")
    SendMessage("HMD")
    SendMessage(HapticEffect:get():GetFullName())
end

function HeartBeat()
    if canHeartBeat then
        SendMessage("--------------------------------")
		SendMessage("HeartBeat")
		truegear.play_effect_by_uuid("HeartBeat")
    end
end

function LeftHandDrill()
    if canLeftHandDrill then
        SendMessage("--------------------------------")
		SendMessage("LeftHandDrill")
		truegear.play_effect_by_uuid("LeftHandDrill")
    end
end

function RightHandDrill()
    if canRightHandDrill then
        SendMessage("--------------------------------")
		SendMessage("RightHandDrill")
		truegear.play_effect_by_uuid("RightHandDrill")
    end
end

truegear.seek_by_uuid("DefaultDamage")
truegear.init("722180", "SURV1V3")

function CheckPlayerSpawned()
	RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
		if resetHook then
			local ran, errorMsg = pcall(RegisterHooks)
			if ran then
				SendMessage("--------------------------------")
				SendMessage("HeartBeat")
				truegear.play_effect_by_uuid("HeartBeat")
				resetHook = false
			else
				print(errorMsg)
			end
		end		
	end)
end

SendMessage("TrueGear Mod is Loaded");
CheckPlayerSpawned()

LoopAsync(1000, HeartBeat)
LoopAsync(190, LeftHandDrill)
LoopAsync(190, RightHandDrill)