local M = {}

M.diagnostics = {
  static = {
    texts = {
      { symbol = "E ", highlight = "DiagnosticSignError" },
      { symbol = "W ", highlight = "DiagnosticSignWarn" },
      { symbol = "I ", highlight = "DiagnosticSignInfo" },
      { symbol = "H ", highlight = "DiagnosticSignHint" },
    },
  },
  init = function(self)
    local signs = vim.diagnostic.get(vim.api.nvim_get_current_buf(), {
      lnum = vim.v.lnum - 1,
    })

    if #signs == 0 then
      self.sign = nil
    else
      self.sign = signs[1]
    end
  end,
  provider = function(self)
    if self.sign then
      return self.texts[self.sign.severity].symbol
    end

    return "  "
  end,
  hl = function(self)
    if self.sign then
      return self.texts[self.sign.severity].highlight
    end
  end,
}

M.gitsigns = {
  init = function(self)
    local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {
      group = "gitsigns_vimfn_signs_",
      id = vim.v.lnum,
      lnum = vim.v.lnum,
    })

    if not signs or #signs == 0 or not signs[1].signs or #signs[1].signs == 0 or not signs[1].signs[1].name then
      self.sign = nil
    else
      self.sign = signs[1].signs[1]
    end

    self.has_sign = self.sign ~= nil
  end,
  provider = function()
    return " ▏"
  end,
  hl = function(self)
    if self.has_sign then
      return self.sign.name
    end

    return "@comment"
  end,
}

M.line_numbers = {
  provider = function()
    if vim.v.virtnum > 0 then
      return ""
    end

    if vim.v.relnum == 0 then
      return ("%02d"):format(vim.v.lnum)
    end

    return ("%02d"):format(vim.v.relnum)
  end,
}

return M
