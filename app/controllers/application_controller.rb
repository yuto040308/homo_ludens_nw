class ApplicationController < ActionController::Base

    # deviseのストロングパラメータを呼び出す。
    before_action :configure_permitted_parameters, if: :devise_controller?

    #デバイスでeメールパスワード以外を許可する
	protected
    def configure_permitted_parameters
        # 新規登録時に、devise標準カラム(email,password)以外を許可する。
		devise_parameter_sanitizer.permit(:sign_up, keys:[:name_kanji_sei, :name_kanji_mei, :name_kana_sei, :name_kana_mei, :nickname, :phone_number, :payment_method])
	end
end
