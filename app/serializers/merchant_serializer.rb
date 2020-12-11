class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :created_at, :updated_at
end
