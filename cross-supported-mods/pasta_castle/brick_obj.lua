local returnInAct = {
    [ACT_WALKING] = true,
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_BRAKING] = true,
    [ACT_BRAKING_STOP] = true,
    [ACT_TURNING_AROUND] = true,
    [ACT_FINISH_TURNING_AROUND] = true,
    [ACT_SIDE_FLIP] = true,
}

---@param o Object
local brick_init = function(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_scale(o, 1)
end

blinkTimer = 0

---@param o Object
local brick_loop = function(o)
    local m = gMarioStates[o.oOwner]
    if o.oAction == BRICK_ACT_INACTIVE then
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE

        if blinkTimer > 2 then
            o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
            blinkTimer = 0
        end

        blinkTimer = blinkTimer + 1

        if (returnInAct[m.action] or (m.action & ACT_FLAG_IDLE) ~= 0 or gLandActions[m.action]) then
            if o.oTimer > 18 then
                o.oTimer = 0
                o.oAction = BRICK_ACT_RETURN
                o.oForwardVel = 46
            end
        else
            o.oTimer = 0
        end

        smlua_anim_util_set_animation(o, "BRICK_ANIM_IDLE")
    elseif o.oAction == BRICK_ACT_RETURN then
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE

        if blinkTimer > 2 then
            o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
            blinkTimer = 0
        end

        blinkTimer = blinkTimer + 1

        o.oForwardVel = o.oForwardVel + 4
        o.oMoveAngleYaw = obj_angle_to_object(o, m.marioObj)
        o.oMoveAnglePitch = 0
        obj_set_face_angle_to_move_angle(o)

        o.oVelX = o.oForwardVel * sins(o.oMoveAngleYaw) * coss(o.oMoveAnglePitch)
        o.oVelY = o.oForwardVel * sins(o.oMoveAnglePitch)
        o.oVelZ = o.oForwardVel * coss(o.oMoveAngleYaw) * coss(o.oMoveAnglePitch)

        o.oPosX = o.oVelX
        o.oPosY = o.oVelY
        o.oPosZ = o.oVelZ
        smlua_anim_util_set_animation(o, "BRICK_ANIM_WALK")

        cur_obj_set_hitbox_radius_and_height(100, 50)
        if not obj_check_hitbox_overlap(o, m.marioObj) then
            if (m.action & ACT_FLAG_MOVING) ~= 0 then
                set_mario_action(m, ACT_BRICK_MOVING, 0)
            elseif (m.action & ACT_FLAG_AIR) ~= 0 then
                set_mario_action(m, ACT_BRICK_AIR, 0)
            else
                set_mario_action(m, ACT_BRICK_IDLE, 0)
            end

            o.oTimer = 0
            o.oAction = BRICK_ACT_MOUNTED
        end
    elseif o.oAction == BRICK_ACT_MOUNTED then
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE

        o.oFaceAnglePitch = 0
        o.oFaceAngleYaw = m.faceAngle.y

        if m.action ~= ACT_BRICK_IDLE and m.action ~= ACT_BRICK_MOVING and m.action ~= ACT_BRICK_AIR then
            o.oTimer = 0
            o.oAction = BRICK_ACT_INACTIVE
        end

        obj_set_pos(o, m.pos.x, m.pos.y, m.pos.z)
        smlua_anim_util_set_animation(o, "BRICK_ANIM_WALK")
    end
end

id_bhvBrick = hook_behavior(nil, OBJ_LIST_DEFAULT, false, brick_init, brick_loop, "Brick")