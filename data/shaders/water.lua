local shader = [[

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {

        number y = screen_coords.y / love_ScreenSize.y;

        vec4 c = Texel(texture, texture_coords);
        c.r = 0.0;
        c.g = 1.0 - y;
        c.b = (c.b * 1.8) * (y * 3);
        c.a = 0.5 + (y / 3);
        return c;
    }
]]

return shader