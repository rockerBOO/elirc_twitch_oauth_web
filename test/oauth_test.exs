defmodule ElircTwitchOauthWeb.OAuthTest do

  setup do
    client = OAuth2.new([
      strategy: OAuth2.Strategy.AuthCode, #default
      client_id: "client_id",
      client_secret: "abc123",
      site: "https://auth.example.com",
      redirect_uri: "https://example.com/auth/callback"
    ])
  end

  test "" do
    OAuth2.Client.authorize_url(client)
  end

end