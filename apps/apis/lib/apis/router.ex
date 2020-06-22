defmodule Apis.Router do
  use Apis, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug(Apis.AuthPlug)
  end

  scope "/", Apis do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", Apis do
    pipe_through :api

    post "/new-file", NewFilesController, :new_file
    post "/batch-process/:bq_table_root", BatchCommandController, :batch_process
  end
end
