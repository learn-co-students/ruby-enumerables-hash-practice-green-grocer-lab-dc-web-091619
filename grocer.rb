def consolidate_cart(cart)
  before_final = cart.map{|hsh| hsh.to_a}.flatten
  new_hash = Hash[*before_final]
  for items in before_final do
    if items.class == String
      new_hash[items][:count] = before_final.count(items)
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each{|item|
    if cart.keys.include?(item[:item]) && item[:num] <= cart[item[:item]][:count]
      if !cart["#{item[:item]} W/COUPON"]
        cart["#{item[:item]} W/COUPON"] = {
          :price => item[:cost] / item[:num], 
          :clearance => cart[item[:item]][:clearance], 
          :count => item[:num]}
      else
        cart["#{item[:item]} W/COUPON"][:count] += item[:num]
      end
      cart[item[:item]][:count] -= item[:num]
    end
    }
  cart
end

def apply_clearance(cart)
  cart.each{|key, value|
    value[:price] = (value[:price] * 0.8).round(2) if value[:clearance]
    }
end

def checkout(cart, coupons)
  final_cart = consolidate_cart(cart)
  apply_coupons(final_cart, coupons)
  apply_clearance(final_cart)
  total = 0
  final_cart.each{|key, value|
    total += value[:price] * value[:count]}
  total *= 0.9 if total > 100
  total
end
