defmodule RaccoonTest do
  use ExUnit.Case

  import(Raccoon)

  test "normalize all string to uppercase" do
    assert normalize(%{:description => "groceries", :bank => "santander"}) == %{
             :description => "GROCERIES",
             :bank => "SANTANDER"
           }
  end

  test "remove currencies" do
    assert normalize(%{:real => "R$2,00", :dollar => "$5.00", :euro => "€7,00"}) == %{
             :real => "2,00",
             :dollar => "5.00",
             :euro => "7,00"
           }
  end

  test "normlize currency float point" do
    assert normalize(%{:dollar => "9,999,999.9", :real => "666.555,5"}) == %{
             :dollar => "9,999,999.90",
             :real => "666.555,50"
           }
  end
end
