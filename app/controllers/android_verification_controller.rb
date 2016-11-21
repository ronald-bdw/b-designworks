class AndroidVerificationController < ApplicationController
  def create
    redirect_to "pairup://pearup.com?authcode=#{params[:authcode]}"
  end
end
