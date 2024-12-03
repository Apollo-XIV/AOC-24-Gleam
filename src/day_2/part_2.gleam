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
  data
  |> list.map(is_safe_with_grace)
  |> io.debug
}

fn is_safe_with_grace(x: List(Int)) -> Bool {
  let diffs =
    x
    |> list.window_by_2
    |> list.map(fn(pair) {
      let #(a, b) = pair
      a - b
    })

  // Grace Rule 1: make sure there's no more than one zero
  let zero_count = diffs |> list.count(fn(x) { x == 0 })
  let grace_filtered = case zero_count {
    // if there are no zeros, check the second grace rule
    0 -> grace_rule_2(diffs)
    // if there is 1 zero, remove the value and go straight to the final filter
    1 -> Ok(diffs |> list.filter(fn(x) { x != 0 }))
    // if there is more than 1 zero, immediately fail
    _ -> Error(Nil)
  }

  let filtered =
    diffs
    // breaking this rule is still unrecoverable
    |> list.try_map(fn(x) {
      case x |> int.absolute_value {
        1 | 2 | 3 -> Ok(x)
        _ -> Error(False)
      }
    })

  // 
  True
}

fn grace_rule_2(diffs) -> Result(List(Int), Nil) {
  let pos = diffs |> list.all(fn(x) { x > 0 })
  let neg = diffs |> list.all(fn(x) { x < 0 })
  let f1 = case pos || neg {
    True -> Ok(diffs)
    False -> Error(Nil)
  }
  use <- result.lazy_or(f1)
  // find the index of a value with unique parity
  let #(pos, neg) = diffs |> list.partition(is_pos)
}

fn is_pos(i: Int) -> Bool {
  i > 0
}
