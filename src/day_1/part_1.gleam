import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(#(l1, l2)) = {
    use data <- result.map(simplifile.read("inputs/day_1.txt"))
    data |> parse_input
  }
  let l1 = l1 |> list.sort(int.compare)
  let l2 = l2 |> list.sort(int.compare)
  let diff_total =
    list.zip(l1, l2)
    |> list.map(fn(pair) {
      let #(a, b) = pair
      int.absolute_value(a - b)
    })
    |> list.fold(0, fn(acc, i) { acc + i })
  io.println(diff_total |> int.to_string)
}

/// Takes the unparsed input and returns two lists of numbers
pub fn parse_input(data) -> #(List(Int), List(Int)) {
  let assert Ok(list_pairs) =
    data
    |> string.trim_end
    |> string.split("\n")
    |> list.try_map(fn(x) {
      use #(a, b) <- result.try(string.split_once(x, "   "))
      use aint <- result.try(int.parse(a))
      use bint <- result.try(int.parse(b))
      Ok(#(aint, bint))
    })
  list_pairs
  |> list.unzip
}
