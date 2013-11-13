get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  puts @access_token.inspect
  session.delete(:request_token)

  conditions = { oauth_token: @access_token.token,
                 oauth_secret: @access_token.secret,
                 username: @access_token.params[:screen_name]
  }
  user = User.find(:first, conditions: conditions) || User.create(conditions)
  # at this point in the code is where you'll need to create your user account and store the access token
  session[:user_id] = user.id
  session[:token] = user.oauth_token
  session[:secret] = user.oauth_secret
  erb :index
 end

post '/tweets' do
  puts params[:tweet]
  client.update(params[:tweet])
  redirect to '/'
end
