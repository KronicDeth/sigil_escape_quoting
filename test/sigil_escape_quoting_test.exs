defmodule SigilEscapeQuotingTest do
  use ExUnit.Case
  doctest SigilEscapeQuoting

  setup context do
    {:ok,
     Map.put(
       context,
       :quoted_sigil,
       "test/fixtures/escape_sequences.exs"
       |> File.read!
       |> Code.string_to_quoted!
     )
    }
  end

  test "quoting escapes in sigils", %{quoted_sigil: quoted_sigil} do
    assert quoted_sigil == {
                            :sigil_c,
                            [line: 1],
                            [
                             {
                              :<<>>,
                              [line: 1],
                              [
                               "\n'\n\#{}\n\\\"\n\\0\n\\1\n\\a\n\\b\n\\d\n\\e\n\\f\n\\b\n\\r\n\\s\n\\v\n\\x12\n\\x{100000}\n"
                              ]
                             },
                             []
                            ]
                           }
  end

  test "quoting escape length in sigils", %{quoted_sigil: {:sigil_c, _, [{:<<>>, _, [string]}, []]}} do
    assert byte_size(string) == 59
  end
end
