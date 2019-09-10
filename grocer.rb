require 'pry'

cart = [
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}},
    ]
coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.00}, {:item => "AVOCADO", :num => 2, :cost => 5.00}]

def consolidate_cart(cart)
  new_cart = {}
  
 cart.each do |item_hash|
 item_hash.each do |item, price_value|
    if new_cart[item].nil?
      new_cart[item] = price_value.merge({:count => 1})
     
    else
      new_cart[item][:count]+= 1
       
    end
  end
 end
cart = new_cart
end

consolidated_cart = consolidate_cart(cart)
      
def apply_coupons(cart, coupons)
coupons.each do |coupon|
  

if cart.keys.include?(coupon[:item])
  item = coupon[:item]
  if coupon[:num] <= cart[item][:count]
    price = coupon[:cost]/coupon[:num]
    clearance = cart[item][:clearance]
    
  if cart["#{item} W/COUPON"]
    count = cart["#{item} W/COUPON"][:count]
    cart["#{item} W/COUPON"] = {:price => price, :clearance => clearance, :count => count + coupon[:num]}
  else
    cart["#{item} W/COUPON"] = {:price => price, :clearance => clearance, :count => coupon[:num]}
  end
    newcount = cart[item][:count] - coupon[:num]
    cart[item] = {:price => cart[item][:price], :clearance => cart[item][:clearance], :count => newcount}
    
  
    
    end
  end
end
return cart
end

def apply_clearance(cart)
  h = {}
  cart.each do |cart|
 item = cart[0]
 price = cart[1][:price]
 discount = price* 20/100
 clearance = cart[1][:clearance]
 count = cart[1][:count]
 if clearance == true 
   h[item] = {:price => price - discount, :clearance => clearance, :count => count }
  else
    h[item]  = {:price => price, :clearance => clearance, :count => count}
  end
 end
 cart = h
end
apply_clearance(consolidated_cart)

def checkout(array,coupons)
hash_cart = consolidate_cart(array)
applied_coupons = apply_coupons(hash_cart, 
coupons)
applied_discount = apply_clearance(applied_coupons)
total = applied_discount.reduce(0) { |acc, (key,value) | 
acc += value[:price] }
total > 100 ? total * 0.9 : total 
end
checkout(cart,coupons

