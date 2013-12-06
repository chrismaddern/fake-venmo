class Card < ActiveRecord::Base

belongs_to :user

def to_s
   {"last_four" => last_four, "card_type" => card_type}.to_s
end

end
