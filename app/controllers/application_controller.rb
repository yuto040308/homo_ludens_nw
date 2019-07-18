class ApplicationController < ActionController::Base

    # deviseのストロングパラメータを呼び出す。
    before_action :configure_permitted_parameters, if: :devise_controller?

    # devise標準で動くメゾット、sign_in(ログイン)が完了した場合に後から呼ばれるメゾット
    def after_sign_in_path_for(resourse)
        
        # 管理者フラグが立っている場合は、管理者マイページに遷移させる
		if current_user.admin_flg == 1
            admin_user_path

        # 一般ユーザーの場合、遊び一覧のページに遷移させるd
		else
            plays_path
        end
    end

    # devise標準で動くメゾット、sign_up(新規作成)が完了した場合に後から呼ばれるメゾット
    def after_sign_up_path_for(resourse)
        # 標準で、遊び一覧のページに戻す
        plays_path
    end

    # 管理者フラグをチェックし、ユーザーが管理者ページにアクセスした場合にTOPページに戻す
    def admin_flg_check?
		if current_user == nil
			redirect_to "/"
		else
			if current_user.admin_flg == 1
                # 管理者は何も制御しない
			else
				redirect_to "/"
			end
		end
    end

    # 退会状態、ログインしていないユーザーについて、アクセス制限をかける
	def resignation_flag_and_login_check?
		# ログインしているかで処理を分ける
		if current_user == nil
			redirect_to "/"
		else
			# 退会状態でアクセスされた場合、トップページにリダイレクトする。
			if current_user.resignation_flg == 1
				redirect_to "/"
			# 退会していない状態では、何もしません。
			else
				#処理しません
			end

		end
    end
    
    #デバイスでeメールパスワード以外を許可する
	protected
    def configure_permitted_parameters
        # 新規登録時に、devise標準カラム(email,password)以外を許可する。
		devise_parameter_sanitizer.permit(:sign_up, keys:[:name_kanji_sei, :name_kanji_mei, :name_kana_sei, :name_kana_mei, :nickname, :phone_number, :payment_method])
	end
end
