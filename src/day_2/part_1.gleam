import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(data) = {
    simplifile.read("inputs/day_2.txt")
    |> result.map(parse_input)
  }
  data
  |> list.count(fn(x) { x |> is_safe })
  |> int.to_string
  |> io.println
}

pub fn parse_input(data) -> List(List(Int)) {
  let assert Ok(val) =
    data
    |> string.trim
    // separate on linebreaks
    |> string.split("\n")
    |> list.map(string.trim)
    // convert each row into a list
    |> list.try_map(fn(x) { string.split(x, " ") |> list.try_map(int.parse) })
  val
}

/// takes a list of numbers and determines if they are 'Safe' or 'Unsafe' based 
/// upon a predefined set of rules
fn is_safe(record) -> Bool {
  // iterate over the list. if a rule is broken we return an error
  let out = {
    use #(a, b) <- list.map(list.window_by_2(record))
    a - b
  }
  // all list items must be either increasing or decreasing
  // the gaps between levels cannot be less than one or more than 3
  out
  |> io.debug
  |> list.try_map(fn(x) {
    // check that the absolute value of the diffs is within the acceptable range
    case x |> int.absolute_value {
      1 | 2 | 3 -> Ok(x)
      _ -> Error(False)
    }
  })
  |> io.debug
  |> result.try(fn(x) {
    let pos = x |> list.all(fn(x) { x > 0 })
    let neg = x |> list.all(fn(x) { x < 0 })
    case pos || neg {
      True -> Ok(True)
      False -> Error(False)
    }
  })
  |> result.unwrap_both
}
