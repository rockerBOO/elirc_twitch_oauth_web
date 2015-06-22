defmodule ElircTwitchOauthWeb.CallbackController do
  use ElircTwitchOauthWeb.Web, :controller

  plug :action

  @doc """
  This action is reached via `/auth` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, _params) do
    redirect conn, external: OAuth2.Twitch.authorize_url!
  end

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    # Exchange an auth code for an access token
    token = OAuth2.Twitch.get_token!([code: code])

    # Request the user's data with the access token
    headers = [{"Authorization", "OAuth " <> token.access_token}]

    result = token |> OAuth2.AccessToken.get!("/user", headers)    

    case [conn, token, result] do 
      [conn, token, %{"error" => err, "message" => message}] -> error(conn, err, message)
      [conn, token, user] -> save(conn, user, token)
    end

    conn
    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
  end

  def error(conn, error, message) do
    IO.puts "#{error} !!! #{message}"
    
    conn
  end

  def save(conn, user, token) do
    # IO.inspect conn
    IO.inspect user
    IO.inspect token

    conn
      |> put_session(:current_user, user)
      |> put_session(:access_token, token)
      |> redirect(to: "/")
  end
end
