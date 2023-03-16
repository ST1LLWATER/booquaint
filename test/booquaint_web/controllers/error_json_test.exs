defmodule BooquaintWeb.ErrorJSONTest do
  use BooquaintWeb.ConnCase, async: true

  test "renders 404" do
    assert BooquaintWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BooquaintWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
