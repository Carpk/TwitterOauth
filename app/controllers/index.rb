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

get '/status/:job_id' do
  # return the status of a job to an AJAX call
  jobID = params[:job_id]
  @jobStatus = job_is_complete(jobID)
  erb :index
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  conditions = { oauth_token: @access_token.token,
                 oauth_secret: @access_token.secret,
                 username: @access_token.params[:screen_name]
  }
  user = User.find(:first, conditions: conditions) || User.create(conditions)
  # at this point in the code is where you'll need to create your user account and store the access token
  set_oauth_session
  erb :index
 end

post '/tweets' do
  user = User.find(session[:user_id])
  jobID = user.tweet(params[:tweet])
end

post '/tweets/later' do
  user = User.find(session[:user_id])
  jobID = user.tweet_later(params[:tweet], params[:seconds].to_i)
end
