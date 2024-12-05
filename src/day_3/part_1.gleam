import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  // let data =
  // "
  // xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  // "
  let assert Ok(data) = simplifile.read("inputs/day_3.txt")

  data
  |> parse_input
  // |> io.debug
  |> list.map(fn(x) { recover_and_do_operations(x) })
  // |> io.debug
  |> list.fold(0, fn(acc, i) { acc + i })
  |> io.debug
}

pub fn parse_input(data: String) -> List(String) {
  data
  |> string.trim
  |> string.split("\n")
}

pub fn recover_and_do_operations(input: String) -> Int {
  let assert Ok(re) = regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)")
  regexp.scan(re, input)
  |> list.map(fn(match) {
    case match.submatches |> io.debug {
      [Some(a), Some(b)] ->
        {
          use a <- result.try(int.parse(a))
          use b <- result.map(int.parse(b))
          a * b
        }
        |> io.debug
      _ -> Error(Nil)
    }
    |> result.unwrap(0)
  })
  |> list.fold(0, fn(acc, i) { acc + i })
}
