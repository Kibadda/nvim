local function each(z)
  return (function(x)
    return x(x)
  end)(function(x)
    return function(y)
      z(y)
      return x(x)
    end
  end)
end

do
  each(vim.print) "test" "hi" "wtf" "hallo" "nochmal test" "das ist ein ganz langer text" "kurz" "was soll das denn?" "ich bin neovim contributor" "hallo" "hallo" "hallo" "hallo" "hallo" "test" "test" "test" "test" "test" "test" "test" "test" "test" "test" "test" "test" "test"
end
