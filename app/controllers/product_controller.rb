class ProductController < ApplicationController
  before_action :authenticate

  def index
    @products = Product.all

    render json: @products
  end
end
