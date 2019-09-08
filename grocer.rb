# def consolidate_cart(array)
#   new_cart = {}
#   array.each do |element|
#     item_name = element.keys[0]
#     if new_cart.keys.include?(item_name)
#       new_cart[item_name][:count] += 1
#     else
#     element[item_name][:count] = 1
#     new_cart[item_name] = element[item_name]
#     end
#   end
# return new_cart
# end

def consolidate_cart(cart)
  # Get hash of objects
  new_cart = cart.reduce(:merge)

  # Get list of keys
  item_names = cart.flat_map(&:keys)

  # Add count to object
  new_cart.keys.map{|key| new_cart[key][:count] = item_names.count(key)}

new_cart
end

def apply_coupons(cart, coupons)
  # Iterate over coupons
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    # See if the coupon item name is in our cart
    if cart.keys.include?(coupon_item) && cart[coupon_item][:count] >= coupon[:num]
      # Modify the existing cart item to decrement count
      cart[coupon_item][:count] -= coupon[:num]
      # if cart[coupon_item][:count] == 0
      #   cart.delete(coupon_item)
      # end
      # Create new cart item with new price, "W/COUPON", count
      reduced_price_item = coupon_item + " W/COUPON"
      if cart[reduced_price_item]
        cart[reduced_price_item][:count] += coupon[:num]
      else
        cart[reduced_price_item] = {:price => coupon[:cost] / coupon[:num], :clearance => cart[coupon_item][:clearance], :count => coupon[:num]}
      end
    end
  end
cart
end


# apply_coupons({
#   "AVOCADO" => {:price => 3.00, :clearance => true, :count => 3},
#   "KALE"    => {:price => 3.00, :clearance => false, :count => 1}
# }, [{:item => "AVOCADO", :num => 2, :cost => 5.00}])



def apply_clearance(cart)
  # code here
  cart.keys.each do |key|
    if cart[key][:clearance] == true
      cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
 consolidated = consolidate_cart(cart)
 coupons_applied = apply_coupons(consolidated, coupons)
 clearance_applied = apply_clearance(coupons_applied)
 
 total = 0
 clearance_applied.keys.each do |key|
   total += clearance_applied[key][:price] * clearance_applied[key][:count]
 end
 
 if total > 100
   total = (total * 0.9).round(2)
 end
  
 total
  
end
   