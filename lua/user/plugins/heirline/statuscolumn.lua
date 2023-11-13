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
    self.namespace = vim.api.nvim_get_namespaces()["gitsigns_extmark_signs_"]
  end,
  provider = function()
    return " ▏"
  end,
  hl = function(self)
    if self.namespace then
      local extmark = vim.api.nvim_buf_get_extmark_by_id(0, self.namespace, vim.v.lnum, { details = true })

      if extmark and extmark[3] then
        return extmark[3].sign_hl_group
      end
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
