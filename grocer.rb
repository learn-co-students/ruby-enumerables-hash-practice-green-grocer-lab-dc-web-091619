def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |memo|
    k,v = memo.first
    if consolidated_cart[k]
        consolidated_cart[k][:count] += 1
    else
      consolidated_cart[k] = {
        :price => v[:price],
        :clearance => v[:clearance],
        :count => 1
      }
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |memo| 
   if cart.keys.any? memo[:item]
     if cart[memo[:item]][:count] >= memo[:num]
       new_item = "#{memo[:item]} W/COUPON"
       if cart[new_item]
          cart[new_item][:count] += memo[:num]
        else
            cart[new_item] = {
            count: memo[:num],
            price: memo[:cost]/memo[:num],
            clearance: cart[memo[:item]][:clearance]
       }
        end
        cart[memo[:item]][:count]-=memo[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |memo|
   if cart[memo][:clearance]
        cart[memo][:price] *= 0.80
        cart[memo][:price] = cart[memo][:price].round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  coupons_cart = consolidate_cart(cart)
  clearance_cart = apply_coupons(coupons_cart,coupons)
  checkout_cart = apply_clearance(clearance_cart)
  running_total = 0.0
  checkout_cart.keys.each do |memo|
    running_total += (checkout_cart[memo][:price]*checkout_cart[memo][:count])
  end
  if running_total >= 100.0
    running_total *= 0.9
    running_total = running_total.round(2)
  end
  running_total
end
