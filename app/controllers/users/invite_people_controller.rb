class Users::InvitePeopleController < ApplicationController
  before_action :set_url
  before_action :render_qr_code

  def show; end

  private

  def set_url
    if current_user
      @url="#{request.base_url}/users/sign_up?promoter=#{current_user&.email}"
    else
      @url="#{request.base_url}/users/sign_up"
      end
  end

  def render_qr_code
    qrcode = RQRCode::QRCode.new(@url)
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 8,
      standalone: true,
      use_path: true
    )
  end
end
