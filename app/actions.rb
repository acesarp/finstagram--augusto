
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
    @posts = Post.order(created_at: :desc)
    erb :index
end

get '/signup' do
    @user = User.new 
    erb(:signup)
end

post '/signup' do 
    
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]
    
    @user = User.new(email: email, avatar_url: avatar_url, username: username, password: password)
    
    # if email.present? && avatar_url.present? && username.present? && password.present?
    
    if @user.save
        redirect(to('/login'))
    else
        erb(:signup)
    end
end
    
get '/login' do
    @username = nil
    erb :login
end

post '/login' do
    username = params[:username]
    password = params[:password]
    
    user = User.find_by_username(username)
    
    if user && user.password == password
        session[:user_id ] = user.id
        "Success! User with id #{session[:user_id]} is logged in!"
        redirect(to('/'))
    else
        @error_message = "Invalid username or password"
        erb(:login)
    end
end

get '/' do
  @posts = Post.order(created_at: :desc)
  @current_user = User.find_by(id: session[:user_id])
  erb(:index)
end
  
get '/logout' do
  session[:user_id] = nil
  "Logout successful!"
  redirect(to('/signup'))
end


get '/posts/new' do
    @post = Post.new
    erb(:"posts/new")
end


post '/posts' do
  params.to_s
end


post '/posts' do
  photo_url = params[:photo_url]

  # instantiate new Post
  @post = Post.new({ photo_url: photo_url })

  # if @post validates, save
  if @post.save
    redirect(to('/'))
  else

    # if it doesn't validate, print error messages
    @post.errors.full_messages.inspect
  end
end


get '/posts/new' do
  @post = Post.new
  erb(:"posts/new")
end

post '/posts' do
  photo_url = params[:photo_url]

  @post = Post.new({ photo_url: photo_url, user_id: current_user.id })

  if @post.save
    redirect(to('/'))
  else
    erb(:"posts/new")
  end
end

get '/posts/:id' do
  params[:id]
end

get '/posts/:id' do
  @post = Post.find(params[:id])   # find the post with the ID from the URL
  escape_html @post.inspect        # print to the screen for now
end


get '/posts/:id' do
  @post = Post.find(params[:id])   # find the post with the ID from the URL
  erb(:"posts/show")               # render app/views/posts/show.erb
end

post '/comments' do
  text = params[:text]
  post_id = params[:post_id]
  comment = Comment.new({ text: text, post_id: post_id, user_id: current_user.id })
  comment.save
  redirect(back)
end


post '/likes' do
  post_id = params[:post_id]
  
  like = Like.new({ post_id: post_id, user_id: current_user.id })
  like.save

  redirect(back)
end


