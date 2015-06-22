defmodule ElircTwitchOauthWeb.Router do
  use ElircTwitchOauthWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElircTwitchOauthWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/callback", CallbackController, :callback
    get "/auth", CallbackController, :index
  end

  defp assign_current_user(conn, _) do
    session = Plug.Conn.get_session(conn, :current_user)

    IO.inspect session
    assign(conn, :current_user, session)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElircTwitchOauthWeb do
  #   pipe_through :api
  # end
end
