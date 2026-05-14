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

  test "calculate hash from row" do
    assert hash(%{:des => "grocery", :amount => "55555.99"}) ==
             "55555.99|grocery"
  end

  test "recociliation exactly matchs" do
    left_set = %{
      200 => %{:des => "Insurance", :amount => "66.00"},
      300 => %{:des => "Groceries", :amount => "90.0"}
    }

    right_set = %{
      10 => %{:des => "groceries", :amount => "90.00"},
      11 => %{:des => "INSURANCE", :amount => "66.0"}
    }

    expected = [
      %{100 => %{200 => 11, 300 => 10}}
    ]

    assert reconciliate(left_set, right_set) == expected
  end

  test "fuzz" do
    left_set = %{
      200 => %{:des => "Insurance", :amount => "66.00"},
      300 => %{:des => "Groceries", :amount => "90.0"},
      500 => %{:des => "Bills", :amount => "550.0"}
    }

    right_set = %{
      10 => %{:des => "groceries", :amount => "90.00"},
      11 => %{:des => "INSURANCE", :amount => "66.0"}
    }

    expected = [
      %{100 => %{200 => 11, 300 => 10}},
      %{52 => %{500 => 10}}
    ]

    assert reconciliate_fuzz(left_set, right_set) == expected
  end
end
