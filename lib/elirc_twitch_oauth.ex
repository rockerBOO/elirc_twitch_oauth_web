defmodule OAuth2.Twitch do
  use OAuth2.Strategy

  @state_token "Elirc-Temporary-Unique-Token"

  # Public API

  def new do
    OAuth2.new([
      strategy: __MODULE__,
      client_id: System.get_env("TWITCH_CLIENT_ID"),
      client_secret: System.get_env("TWITCH_CLIENT_SECRET"),
      redirect_uri: System.get_env("TWITCH_REDIRECT_URI"),
      site: "https://api.twitch.tv/kraken/",
      authorize_url: "https://api.twitch.tv/kraken/oauth2/authorize",
      token_url: "https://api.twitch.tv/kraken/oauth2/token"
    ])
  end

  def scopes() do 
    ["user_read", "chat_login", "channel_read",
     "channel_read", "channel_editor",
     "channel_stream", "channel_subscriptions", 
     "user_subscriptions"]
      |> Enum.join(" ")
  end

  def authorize_url!(params \\ []) do
    new()
    |> put_param(:state, @state_token)
    |> put_param(:scope, scopes)
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ []) do
    new()
      |> put_param(:state, @state_token)
      |> OAuth2.Client.get_token!(params, headers)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end