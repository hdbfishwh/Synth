-- ForgeUI Theme System for Roblox
-- This is the heart of the UI library. Define all styles and visuals here.
-- Version: 1.0

loadstring(game:HttpGet("https://raw.githubusercontent.com/hdbfishwh/Synth/refs/heads/main/theme.lua"))()

local Theme = {}

--== PRIVATE INTERNAL STATE ==--
local _private = {
    current_theme = 'light' -- Default theme
}

--== PUBLIC THEME DEFINITION ==--
Theme.properties = {
    theme = _private.current_theme,

    -- Color Palettes (using Color3 for Roblox)
    colors = {
        light = {
            primary    = Color3.fromRGB(66, 135, 245),  -- Nice blue
            secondary  = Color3.fromRGB(156, 84, 184),  -- Purple
            success    = Color3.fromRGB(56, 168, 94),   -- Green
            danger     = Color3.fromRGB(232, 77, 61),   -- Red
            warning    = Color3.fromRGB(242, 156, 18),  -- Orange
            info       = Color3.fromRGB(41, 160, 176),  -- Teal
            background = Color3.fromRGB(242, 242, 242), -- Light grey
            surface    = Color3.fromRGB(255, 255, 255), -- White
            text       = Color3.fromRGB(33, 33, 33),    -- Near black
            text_light = Color3.fromRGB(242, 242, 242), -- Near white
            border     = Color3.fromRGB(204, 204, 204), -- Light grey border
        },
        dark = {
            primary    = Color3.fromRGB(92, 161, 255),
            secondary  = Color3.fromRGB(181, 110, 209),
            success    = Color3.fromRGB(82, 194, 120),
            danger     = Color3.fromRGB(255, 102, 86),
            warning    = Color3.fromRGB(255, 177, 43),
            info       = Color3.fromRGB(66, 186, 201),
            background = Color3.fromRGB(33, 33, 33),    -- Dark grey
            surface    = Color3.fromRGB(46, 46, 46),    -- Slightly lighter
            text       = Color3.fromRGB(242, 242, 242), -- Near white
            text_light = Color3.fromRGB(33, 33, 33),    -- Near black
            border     = Color3.fromRGB(89, 89, 89),    -- Dark grey border
        }
    },

    -- Typography (Using Roblox Fonts)
    typography = {
        fonts = {
            header  = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal),
            title   = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
            body    = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            caption = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            small   = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Light, Enum.FontStyle.Normal)
        },
        sizes = {
            header  = 24,
            title   = 20,
            body    = 16,
            caption = 12,
            small   = 10
        },
        line_height = 1.2
    },

    -- Spacing & Sizing System (using UDim2 scale and offset)
    spacing = {
        none   = UDim2.new(0, 0),
        tiny   = UDim2.new(0, 2),
        small  = UDim2.new(0, 4),
        medium = UDim2.new(0, 8),
        large  = UDim2.new(0, 16),
        xl     = UDim2.new(0, 24),
        xxl    = UDim2.new(0, 32)
    },

    -- Border & Rounding (for UICorner)
    borders = {
        radius = {
            none = 0,
            small = 2,
            medium = 4,
            large = 8,
            pill = 12
        }
    },

    -- Component-Specific Styles
    components = {
        button = {
            size = UDim2.new(0, 120, 0, 40), -- Default button size
            padding = UDim2.new(0, 16, 0, 8),
            default_color = 'primary',
            text_color = 'text_light',
            border_radius = 'medium',
            text_size = 'body',
            auto_button_color = false -- Important for custom styling
        },
        frame = {
            background_color = 'surface',
            border_color = 'border',
            border_radius = 'medium',
            padding = 'medium'
        },
        textlabel = {
            text_color = 'text',
            text_size = 'body',
            background_transparency = 1 -- Usually transparent background
        }
    }
}

--== PUBLIC API METHODS ==--

function Theme.setTheme(theme_name)
    if Theme.properties.colors[theme_name] then
        _private.current_theme = theme_name
        --print("ForgeUI: Theme set to '" .. theme_name .. "'")
    else
        warn("ForgeUI: Theme '" .. tostring(theme_name) .. "' not found. Using default.")
    end
    return Theme
end

function Theme.getColor(color_key)
    local theme_colors = Theme.properties.colors[_private.current_theme]
    if not theme_colors then
        warn("ForgeUI: ERROR! Current theme has no color definitions.")
        return Color3.fromRGB(255, 0, 255) -- Magenta for errors
    end

    local color = theme_colors[color_key]
    if not color then
        warn("ForgeUI: Color key '" .. tostring(color_key) .. "' not found. Returning primary.")
        return theme_colors.primary or Color3.fromRGB(255, 0, 0)
    end

    return color
end

function Theme.getFont(font_key)
    local font = Theme.properties.typography.fonts[font_key]
    if not font then
        warn("ForgeUI: Font key '" .. tostring(font_key) .. "' not found. Returning body font.")
        return Theme.properties.typography.fonts.body
    end
    return font
end

function Theme.getTextSize(font_key)
    local size = Theme.properties.typography.sizes[font_key]
    if not size then
        warn("ForgeUI: Text size key '" .. tostring(font_key) .. "' not found. Returning body size.")
        return Theme.properties.typography.sizes.body
    end
    return size
end

function Theme.getSpacing(size_key)
    local spacing = Theme.properties.spacing[size_key]
    if not spacing then
        warn("ForgeUI: Spacing key '" .. tostring(size_key) .. "' not found. Returning 'medium'.")
        return Theme.properties.spacing.medium
    end
    return spacing
end

function Theme.getBorderRadius(radius_key)
    local radius = Theme.properties.borders.radius[radius_key]
    if not radius then
        warn("ForgeUI: Radius key '" .. tostring(radius_key) .. "' not found. Returning 'medium'.")
        return Theme.properties.borders.radius.medium
    end
    return radius
end

function Theme.applyState(base_color, state_key)
    -- For Roblox, we might handle states differently (e.g., using TweenService)
    -- This is a placeholder for future state logic
    return base_color
end

-- Helper to create a new instance styled from the theme
function Theme.create(instance_type, properties)
    local new_instance = Instance.new(instance_type)
    if properties then
        for property, value in pairs(properties) do
            new_instance[property] = value
        end
    end
    return new_instance
end

--print("ForgeUI: Theme system loaded successfully. Current theme: '" .. _private.current_theme .. "'")

return Theme
