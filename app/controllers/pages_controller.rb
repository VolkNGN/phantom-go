class PagesController < ApplicationController
  before_action :authenticate_player!, only: [ :home ]

  def home
  end
end
