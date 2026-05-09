defmodule RaccoonTest do
  use ExUnit.Case

  import(Raccoon)

  test "normalize all string to uppercase" do
    assert normalize(%{:description => "groceries", :bank => "santander"}) == %{
             :description => "GROCERIES",
             :bank => "SANTANDER"
           }
  end
end
