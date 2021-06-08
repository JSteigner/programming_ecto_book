#---
# Excerpted from "Programming Ecto",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wmecto for more book information.
#---
# defmodule MyApp.User do
#   import Ecto.Changeset
#   use Ecto.Schema

#   schema "users" do
#     field :name, :string
#     field :age, :integer
#   end

#   def changeset(user, params) do
#     user
#     |> cast(params, [:name, :age])
#     |> validate_required(:name)
#     |> validate_number(:age, greater_than: 0,
#          message: "you are not yet born")
#   end

# end

# _ = """
# defmodule MyApp.FakeController do
#   def new(conn, _params) do
#     changeset = User.changeset(%User{}, %{})
#     render(conn, changeset: changeset)
#   end
# end
# """

# _ = """
# <%= form_for @changeset, user_path(@conn, :create), fn f -> %>
#   Name: <%= text_input f, :name %>
#   Age: <%= number_input f, :age %>
#   <%= submit "Submit" %>
# <% end %>
# """

# _ = """
# def create(conn, %{"user" => user_params}) do
#   case Accounts.create_user(user_params) do
#     {:ok, user} ->
#       conn
#       |> put_flash(:info, "User created successfully.")
#       |> redirect(to: user_path(conn, :show, user))
#     {:error, %Ecto.Changeset{} = changeset} ->
#       render(conn, "new.html", changeset: changeset)
#   end
# end
# """

# _ = """
# def create_user(attrs \\ %{}) do
#   %User{}
#   |> User.changeset(attrs)
#   |> Repo.insert()
# end
# """


defmodule MyApp.User do
  import Ecto.Changeset
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :age, :integer

    embeds_one :address, Address
  end

  def changeset(user, params) do
    user
    |> cast(params, [:name, :age])
    |> cast_embed(:address)
    |> validate_required(:name)
    |> validate_number(:age. greater_than: 0,
        message: "you are not yet born")
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  <%= form_for @changeset, user_path(@conn, :create), fn form -> %>
    Name: <%= text_input form, :name %> <%= error_tag form, :name %>
    Age: <%= number_input form, :age %> <%= error_tag form, :age %>
    <%= inputs_for form, :address, append: [%Address{}], fn form_address -> %>
      Street: <%= text_input form_address, :street %> <%= error_tag form_address, :street %>
      City: <%= text_input form_address, :city %> <%= error_tag form_address, :city %>
    <% end %>
    <%= submit "Submit" %>
  <% end %>

  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag(:span, translate_error(error))
    end
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, msg ->
      String.replace(msg, "%{#{key}}", to_string(value))
    end)
  end
end
