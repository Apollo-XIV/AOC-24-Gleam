import day_2/part_1.{parse_input}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import simplifile

pub fn main() {
  let assert Ok(data) = {
    simplifile.read("inputs/day_2.txt")
    |> result.map(parse_input)
  }
  //   let data =
  //     "
  // 7 6 4 2 1
  // 1 2 7 8 9
  // 9 7 6 2 1
  // 1 3 2 4 5
  // 8 6 4 4 1
  // 1 3 6 7 9
  //     "
  //     |> parse_input
  data |> list.length |> io.debug
  data
  |> list.count(fn(x) { is_safe_with_grace(x) |> io.debug })
  |> io.debug
}

fn is_safe_with_grace(row: List(Int)) -> Bool {
  let diffs =
    row
    |> list.window_by_2
    |> list.map(fn(pair) {
      let #(a, b) = pair
      b - a
    })
    |> io.debug

  // Grace Rule 1: make sure there's no more than one zero
  let zero_count = diffs |> list.count(fn(x) { x == 0 })
  let grace_filtered = case zero_count {
    // if there are no zeros, check the second grace rule
    0 -> grace_rule_2(diffs, row)
    // if there is 1 zero, remove the value and go straight to the final filter
    1 -> Ok(diffs |> list.filter(fn(x) { x != 0 }))
    // if there is more than 1 zero, immediately fail
    _ -> Error(Nil |> io.debug)
  }

  let filtered =
    grace_filtered
    |> result.try(fn(row) {
      row
      // breaking this rule is still unrecoverable
      |> list.try_map(fn(x) {
        case x |> int.absolute_value {
          1 | 2 | 3 -> Ok(x)
          _ -> Error(Nil)
        }
      })
    })

  case filtered {
    Ok(_) -> True
    Error(_) -> False
  }
}

fn grace_rule_2(diffs, original) -> Result(List(Int), Nil) {
  original |> io.debug
  let pos = diffs |> list.all(fn(x) { x > 0 })
  let neg = diffs |> list.all(fn(x) { x < 0 })
  let f1 = case pos || neg {
    True -> Ok(diffs)
    False -> Error(Nil)
  }
  use <- result.lazy_or(f1)

  // find the index of a value with unique parity
  let indexes = list.range(0, list.length(diffs))
  let #(pos, neg) =
    diffs
    |> list.map2(indexes, fn(a, b) { #(a, b) })
    |> list.partition(is_pos)
  let unique_index =
    case pos {
      [#(_value, index)] -> Ok(index)
      _ -> Error(Nil)
    }
    |> result.lazy_or(fn() {
      case neg {
        [#(_value, index)] -> Ok(index)
        _ -> Error(Nil)
      }
    })

  let _diffs_without_violating_index =
    unique_index
    |> result.map(fn(u_index) {
      original
      // |> io.debug
      |> list.reverse
      |> list.index_fold([], fn(acc, i, l_index) {
        case l_index == u_index - 1 {
          False -> [i, ..acc]
          True -> acc
        }
      })
      |> list.reverse
      |> io.debug
      |> list.window_by_2
      |> list.map(fn(pair) {
        let #(a, b) = pair
        a - b
      })
    })
}

fn is_pos(i_index: #(Int, Int)) -> Bool {
  let #(i, _index) = i_index
  i > 0
}
