class OrdersController < ApplicationController

  def index
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"] # 公開鍵ではあるが、環境変数に置き換えるべし
    @order = Order.new # gon.（変数名） = （代入する値）と記述することで、JavaScriptで変数を使用できる
  end

  def create
    @order = Order.new(order_params)
    if @order.valid?
      pay_item
      @order.save
      return redirect_to root_path
    else
      gon.public_key = ENV["PAYJP_PUBLIC_KEY"] # バリデーションに引っかかった場合は、indexアクションが実行されることなくindex.html.erbがrenderされるため、別途gonの設定が必要
      render 'index', status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:price).merge(token: params[:token])
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]  # 自身のPAY.JPテスト秘密鍵を記述する→環境変数に置き換える(※秘密鍵の際は絶対にGitHubでPushしない!!)
    Payjp::Charge.create(
      amount: order_params[:price],  # 商品の値段
      card: order_params[:token],    # カードトークン
      currency: 'jpy'                # 通貨の種類（日本円）
    )
  end

end
