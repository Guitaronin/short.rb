# https://github.com/delight-im/ShortURL/commit/1044df79aebdabe437b269552bb9ed80df2c28e3
class ShortCodeUtil
  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  BASE = CHARACTERS.length

  def self.encode(id)
    short_code = ""

    while id > 0 do
      short_code = CHARACTERS[id % BASE] + short_code
      id /= BASE
    end

    short_code
  end

  def self.decode(short_code)
    short_code = short_code.to_s
    id = x = 0

    while x < short_code.length do
      id = id * BASE + CHARACTERS.index(short_code[x])
      x += 1
    end

    id
  end
end