class WishItemsController < ApplicationController

  get '/wishlists/:id/add_item' do
    if logged_in?
      if current_user == current_wishlist.user
        @errors = session[:errors]
        erb :'/wishitem/create_wishitem'
      else 
        redirect "wishlists/#{current_wishlist.id}/wishitems"
      end
    else
      redirect 'login'
    end
  end

  get '/wishlists/:id/wishitems' do
    erb :'/wishlist/show_wishlist'
  end

  get '/wishitems/:id/edit' do
    if logged_in?
      if current_user == current_wishitem.wishlist.user
        erb :'/wishitem/edit_wishitem'
      else
        redirect "wishlists/#{current_wishitem.wishlist.id}/wishitems"
      end
    else
      redirect '/login'
    end
  end

  post '/wishlists/:id/wishitems' do
    if logged_in?
      wishitem = WishItem.new(title: params[:title], url: params[:url], price: params[:price], quantity: params[:quantity], image: params[:image], note: params[:note])
      wishitem.wishlist = current_wishlist
      if wishitem.save
        redirect "/wishlists/#{wishitem.wishlist.id}/wishitems"
      else 
        session[:errors] = wishitem.errors.full_messages
        redirect "/wishlists/#{wishitem.wishlist.id}/add_item"
      end
    else
      redirect '/login'
    end
  end

  post '/wishitems/:id' do
    if logged_in?
      if wishitem_updated
        redirect "/wishlists/#{current_wishitem.wishlist.id}/wishitems"
      else 
        flash[:notice] = "Title, quantity, and image fields can't be blank"
        redirect "/wishitems/#{current_wishitem.id}/edit"
      end
    else
      redirect '/login'
    end
  end

  post '/wishitems/:id/delete' do
    @wishlist = current_wishitem.wishlist.id
    if logged_in?
      current_wishitem.delete
      redirect "/wishlists/#{@wishlist}/wishitems"
    else 
      redirect '/login'
    end
  end

  helpers do 
    def current_wishitem
      WishItem.find_by_id(params[:id])
    end

    def wishitem_updated
      current_wishitem.update(title: params[:title], url: params[:url], price: params[:price], quantity: params[:quantity], image: params[:image], note: params[:note])
    end
  end
end