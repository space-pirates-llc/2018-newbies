# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    puts "---------see what is the value of logged_in-----------"
    puts logged_in?
    puts "---------------------"
    redirect_to(login_path) unless logged_in?
    render :show
    #if logged_in?
    #  render :new
    #end



  end
end
