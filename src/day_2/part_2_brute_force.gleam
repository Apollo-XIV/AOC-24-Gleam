import day_2/part_1
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  // let data =
  //   "
  //   7 6 4 2 1
  //   1 2 7 8 9
  //   9 7 6 2 1
  //   1 3 2 4 5
  //   8 6 4 4 1
  //   1 3 6 7 9
  // "
  let assert Ok(data) = simplifile.read("inputs/day_2.txt")

  data
  |> part_1.parse_input
  |> list.map(verify_row)
  |> list.count(fn(pair) { pair.second(pair) })
  |> io.debug
}

fn verify_row(row: List(Int)) -> #(List(Int), Bool) {
  let fmt_row =
    row
    |> list.map(int.to_string)
    |> string.join(", ")
  io.println("EVALUATING: " <> fmt_row)
  is_safe_with_grace(row, 0)
  |> io.debug
}

/// 1: all levels must be either increasing or decreasing, relative to the one 
///    prior
/// 2: the gap between levels must be no less than 1, and no more than 3
/// 3: a row may pass anyways if removing one level would cause it to pass the 
///    two previous checks
fn is_safe_with_grace(row: List(Int), depth) -> #(List(Int), Bool) {
  // whether the input row has passed all the checks so far
  let diffs =
    row
    |> list.window_by_2
    |> list.map(fn(pair) {
      let #(a, b) = pair
      b - a
    })
  let pos = diffs |> list.all(fn(x) { x > 0 })
  let neg = diffs |> list.all(fn(x) { x < 0 })
  let all_levels_descending_or_ascending = pos || neg
  let no_diffs_less_than_1_or_greater_than_3 =
    diffs
    |> list.all(fn(x) {
      case x |> int.absolute_value {
        1 | 2 | 3 -> True
        _ -> False
      }
    })

  let passes =
    no_diffs_less_than_1_or_greater_than_3 && all_levels_descending_or_ascending

  case passes, depth {
    // a rule can be checked again only if depth is 0
    False, 0 -> {
      // io.println("NO RECURSION ALLOWED >:(")
      // #(row, False)
      io.debug("We recursed!")
      let new_depth = depth + 1
      // create all the permutations of the list without one level
      row_sub_1_variants(row)
      // try running for all the permutations, use the first one that returns true
      |> list.find_map(fn(x) {
        case is_safe_with_grace(x, new_depth) {
          #(f_row, True) -> Ok(#(f_row, True))
          _ -> Error(Nil)
        }
      })
      // or just fail the row
      |> result.unwrap(#(row, False))
    }
    // The row then either passes or fails on its own merit
    passes, _ -> #(row, passes)
  }
}

/// return all variations of the list without one of the values
pub fn row_sub_1_variants(row: List(Int)) -> List(List(Int)) {
  row
  |> list.length
  |> fn(x) { list.range(0, x - 1) }
  |> list.map(fn(index_to_pop) {
    row
    |> list.index_fold([], fn(acc, i, n) {
      case n == index_to_pop {
        True -> acc
        False -> [i, ..acc]
      }
    })
    |> list.reverse
  })
}
