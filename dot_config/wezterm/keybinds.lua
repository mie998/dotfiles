local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.tmux_keybinds = {
  { key = "r",     mods = "LEADER",       action = "ReloadConfiguration" },
  { key = "|",     mods = "LEADER|SHIFT", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
  { key = "\\",    mods = "LEADER",       action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
  { key = "-",     mods = "LEADER",       action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  { key = "c",     mods = "LEADER",       action = act({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "w",     mods = "LEADER|CTRL",  action = act({ CloseCurrentTab = { confirm = true } }) },
  { key = "n",     mods = "LEADER",       action = act({ ActivateTabRelative = 1 }) },
  { key = "p",     mods = "LEADER",       action = act({ ActivateTabRelative = -1 }) },
  { key = "1",     mods = "LEADER",   action = act({ ActivateTab = 0 }) },
  { key = "2",     mods = "LEADER",   action = act({ ActivateTab = 1 }) },
  { key = "3",     mods = "LEADER",   action = act({ ActivateTab = 2 }) },
  { key = "4",     mods = "LEADER",   action = act({ ActivateTab = 3 }) },
  { key = "5",     mods = "LEADER",   action = act({ ActivateTab = 4 }) },
  { key = "6",     mods = "LEADER",   action = act({ ActivateTab = 5 }) },
  { key = "7",     mods = "LEADER",   action = act({ ActivateTab = 6 }) },
  { key = "8",     mods = "LEADER",   action = act({ ActivateTab = 7 }) },
  { key = "9",     mods = "LEADER",   action = act({ ActivateTab = 8 }) },
  { key = "h",     mods = "LEADER",   action = act({ ActivatePaneDirection = "Left" }) },
  { key = "j",     mods = "LEADER",   action = act({ ActivatePaneDirection = "Down" }) },
  { key = "k",     mods = "LEADER",   action = act({ ActivatePaneDirection = "Up" }) },
  { key = "l",     mods = "LEADER",   action = act({ ActivatePaneDirection = "Right" }) },
  { key = "H",     mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Left", 5 } }) },
  { key = "J",     mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Down", 5 } }) },
  { key = "K",     mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Up", 5 } }) },
  { key = "L",     mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Right", 5 } }) },
  { key = "/",     mods = "LEADER",      action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "u",     mods = "LEADER|CTRL", action = "QuickSelect" },
  {
    key = "i",
    mods = "LEADER|CTRL",
    action = act.QuickSelectArgs({ patterns = { "\\b\\d{1,3}(?:\\.\\d{1,3}){3}\\b" } }),
  },
  { key = "p", mods = "LEADER|CTRL", action = act({ PasteFrom = "Clipboard" }) },
  { key = "x", mods = "LEADER",      action = act({ CloseCurrentPane = { confirm = true } }) },
  {
    key = "g",
    mods = "LEADER",
    action = act({ SpawnCommandInNewTab = { args = { "lazygit" } } }),
  },
}

M.default_keybinds = {
  { key = "c",        mods = "CTRL|SHIFT", action = act({ CopyTo = "Clipboard" }) },
  { key = "c",        mods = "CMD",        action = act({ CopyTo = "Clipboard" }) },
  { key = "v",        mods = "CTRL|SHIFT", action = act({ PasteFrom = "Clipboard" }) },
  { key = "v",        mods = "CMD",        action = act({ PasteFrom = "Clipboard" }) },
  { key = "Insert",   mods = "SHIFT",      action = act({ PasteFrom = "PrimarySelection" }) },
  { key = "=",        mods = "CMD",        action = "ResetFontSize" },
  { key = "=",        mods = "ALT|CMD",    action = "ResetFontSize" },
  { key = "+",        mods = "ALT|SHIFT",  action = "IncreaseFontSize" },
  { key = "+",        mods = "CMD|SHIFT",  action = "IncreaseFontSize" },
  { key = "-",        mods = "ALT",        action = "DecreaseFontSize" },
  { key = "-",        mods = "CMD",        action = "DecreaseFontSize" },
  { key = "PageUp",   mods = "ALT",        action = act({ ScrollByPage = -1 }) },
  { key = "PageDown", mods = "ALT",        action = act({ ScrollByPage = 1 }) },
  { key = "b",        mods = "ALT",        action = act({ ScrollByPage = -1 }) },
  { key = "f",        mods = "ALT",        action = act({ ScrollByPage = 1 }) },
  { key = "a",        mods = "ALT|SHIFT",  action = wezterm.action.ShowLauncher },
  { key = "d",        mods = "ALT|SHIFT",  action = wezterm.action.ShowDebugOverlay },
  {
    key = "s",
    mods = "ALT",
    action = act.PaneSelect({
      alphabet = "1234567890",
    })
  },
  {
    key = "`",
    mods = "ALT",
    action = act.RotatePanes("CounterClockwise"),
  },
  { key = "`", mods = "ALT|SHIFT", action = act.RotatePanes("Clockwise") },
  {
    key = "E",
    mods = "ALT|SHIFT",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      -- selene: allow(unused_variable)
      ---@diagnostic disable-next-line: unused-local
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
}

function M.create_keybinds()
  return utils.merge_lists(M.default_keybinds, M.tmux_keybinds)
end

M.key_tables = {
  copy_mode = {
    {
      key = "Escape",
      mods = "NONE",
      action = act.Multiple({
        act.ClearSelection,
        act.CopyMode("ClearPattern"),
        act.CopyMode("Close"),
      }),
    },
    { key = "q",          mods = "NONE",  action = act.CopyMode("Close") },
    -- move cursor
    { key = "h",          mods = "NONE",  action = act.CopyMode("MoveLeft") },
    { key = "LeftArrow",  mods = "NONE",  action = act.CopyMode("MoveLeft") },
    { key = "j",          mods = "NONE",  action = act.CopyMode("MoveDown") },
    { key = "DownArrow",  mods = "NONE",  action = act.CopyMode("MoveDown") },
    { key = "k",          mods = "NONE",  action = act.CopyMode("MoveUp") },
    { key = "UpArrow",    mods = "NONE",  action = act.CopyMode("MoveUp") },
    { key = "l",          mods = "NONE",  action = act.CopyMode("MoveRight") },
    { key = "RightArrow", mods = "NONE",  action = act.CopyMode("MoveRight") },
    -- move word
    { key = "RightArrow", mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
    { key = "f",          mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
    { key = "\t",         mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
    { key = "w",          mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
    { key = "LeftArrow",  mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
    { key = "b",          mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
    { key = "\t",         mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
    { key = "b",          mods = "NONE",  action = act.CopyMode("MoveBackwardWord") },
    {
      key = "e",
      mods = "NONE",
      action = act({
        Multiple = {
          act.CopyMode("MoveRight"),
          act.CopyMode("MoveForwardWord"),
          act.CopyMode("MoveLeft"),
        },
      }),
    },
    -- move start/end
    { key = "0",  mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
    { key = "\n", mods = "NONE",  action = act.CopyMode("MoveToStartOfNextLine") },
    { key = "$",  mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "$",  mods = "NONE",  action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "e",  mods = "CTRL",  action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "m",  mods = "ALT",   action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "^",  mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "^",  mods = "NONE",  action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "a",  mods = "CTRL",  action = act.CopyMode("MoveToStartOfLineContent") },
    -- select
    { key = " ",  mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v",  mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    {
      key = "v",
      mods = "SHIFT",
      action = act({
        Multiple = {
          act.CopyMode("MoveToStartOfLineContent"),
          act.CopyMode({ SetSelectionMode = "Cell" }),
          act.CopyMode("MoveToEndOfLineContent"),
        },
      }),
    },
    -- copy
    {
      key = "y",
      mods = "NONE",
      action = act({
        Multiple = {
          act({ CopyTo = "ClipboardAndPrimarySelection" }),
          act.CopyMode("Close"),
        },
      }),
    },
    {
      key = "y",
      mods = "SHIFT",
      action = act({
        Multiple = {
          act.CopyMode({ SetSelectionMode = "Cell" }),
          act.CopyMode("MoveToEndOfLineContent"),
          act({ CopyTo = "ClipboardAndPrimarySelection" }),
          act.CopyMode("Close"),
        },
      }),
    },
    -- scroll
    { key = "G",        mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "G",        mods = "NONE",  action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "g",        mods = "NONE",  action = act.CopyMode("MoveToScrollbackTop") },
    { key = "H",        mods = "NONE",  action = act.CopyMode("MoveToViewportTop") },
    { key = "H",        mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
    { key = "M",        mods = "NONE",  action = act.CopyMode("MoveToViewportMiddle") },
    { key = "M",        mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
    { key = "L",        mods = "NONE",  action = act.CopyMode("MoveToViewportBottom") },
    { key = "L",        mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
    { key = "o",        mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEnd") },
    { key = "O",        mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "O",        mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "PageUp",   mods = "NONE",  action = act.CopyMode("PageUp") },
    { key = "PageDown", mods = "NONE",  action = act.CopyMode("PageDown") },
    { key = "b",        mods = "CTRL",  action = act.CopyMode("PageUp") },
    { key = "f",        mods = "CTRL",  action = act.CopyMode("PageDown") },
    {
      key = "Enter",
      mods = "NONE",
      action = act.CopyMode("ClearSelectionMode"),
    },
    -- search
    { key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
    {
      key = "n",
      mods = "NONE",
      action = act.Multiple({
        act.CopyMode("NextMatch"),
        act.CopyMode("ClearSelectionMode"),
      }),
    },
    {
      key = "N",
      mods = "SHIFT",
      action = act.Multiple({
        act.CopyMode("PriorMatch"),
        act.CopyMode("ClearSelectionMode"),
      }),
    },
  },
  search_mode = {
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    {
      key = "Enter",
      mods = "NONE",
      action = act.Multiple({
        act.CopyMode("ClearSelectionMode"),
        act.ActivateCopyMode,
      }),
    },
    { key = "p",      mods = "CTRL", action = act.CopyMode("PriorMatch") },
    { key = "n",      mods = "CTRL", action = act.CopyMode("NextMatch") },
    { key = "r",      mods = "CTRL", action = act.CopyMode("CycleMatchType") },
    { key = "/",      mods = "NONE", action = act.CopyMode("ClearPattern") },
    { key = "u",      mods = "CTRL", action = act.CopyMode("ClearPattern") },
  },
}

M.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act({ CompleteSelection = "PrimarySelection" }),
  },
  {
    event = { Up = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act({ CompleteSelection = "Clipboard" }),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = "OpenLinkAtMouseCursor",
  },
  -- {
  -- 	event = { Up = { streak = 1, button = 'Middle' } },
  -- 	mods = 'NONE',
  -- 	action = act({ PasteFrom = "PrimarySelection" })
  -- },
  -- {
  -- 	event = { Down = { streak = 1, button = 'Middle' } },
  -- 	mods = 'NONE',
  -- 	action = act.DisableDefaultAssignment
  -- },
}

return M
