import day_1/part_1
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(#(l1, l2)) = {
    simplifile.read("inputs/day_1.txt")
    |> result.map(part_1.parse_input)
  }
  let l1 = l1 |> list.sort(int.compare)
  let l2 = l2 |> list.sort(int.compare)
  l1
  |> list.map(fn(x) { x * list.count(l2, fn(y) { x == y }) })
  |> list.fold(0, fn(acc, i) { acc + i })
  |> int.to_string
  |> io.println
}
