defmodule RaccoonTest do
  use ExUnit.Case

  import(Raccoon)

  test "normalize all string to uppercase" do
    assert normalize(%{:description => "groceries", :bank => "santander"}) == %{
             :description => "GROCERIES",
             :bank => "SANTANDER"
           }
  end

  test "should remove currencies" do
    assert normalize(%{:real => "R$2,00", :dollar => "$5.00", :euro => "€7,00"}) == %{
             :real => "2,00",
             :dollar => "5.00",
             :euro => "7,00"
           }
  end
end
