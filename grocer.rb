require "pry"



def consolidate_cart(cart)
new_hash ={}
cart.each do |hash| 
  hash.each do |ingredient_name, ingredient_details|
    if new_hash.has_key?(ingredient_name) 
    
       new_hash[ingredient_name][:count] += 1
    else
     new_hash[ingredient_name] = {:price => ingredient_details[:price], :clearance => ingredient_details[:clearance], :count => 1} 
   end
  end
end
return new_hash
end

def apply_coupons(cart, coupons)
  new_cart ={}

  coupons.each do |coupon| 
    if cart.keys.include?(coupon[:item])
      item = coupon[:item]
      if cart[item][:count] >= coupon[:num]
        current_count = cart[item][:count]
        cart[item][:count] = current_count - coupon[:num]
        coupon_name = "#{item} W/COUPON"
        if cart.keys.include?(coupon_name)
          cart[coupon_name][:count] += coupon[:num]
      else
        cart[coupon_name] = {:price => coupon[:cost]/coupon[:num], :clearance => cart[item][:clearance], :count => coupon[:num]}
      end
    end
   end
  end
  return cart
end



def apply_clearance(cart)
  cart.each do |ingredient, ingredient_details|
    twenty_percent = ingredient_details[:price]/5
   if ingredient_details[:clearance] == true
    ingredient_details[:price] = ingredient_details[:price] - twenty_percent
  end
 end
end

def checkout(cart, coupons)
new_cart = consolidate_cart(cart)
value_new_cart = new_cart[:price]
cart_with_coupons =  apply_coupons(new_cart, coupons)
cart_with_discount = apply_clearance(cart_with_coupons)
total_price = 0
cart_with_discount.each do |item, item_details|
  total_price += item_details[:price]*item_details[:count]
end
ten_percent = total_price/10
if total_price > 100 
 total_price = total_price - ten_percent
end
return total_price
end


