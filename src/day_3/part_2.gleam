import day_3/part_1
import gleam/io
import gleam/list
import gleam/regexp
import gleam/string
import simplifile

pub fn main() {
  // let data =
  //   "
  //   xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  // "
  let assert Ok(data) = simplifile.read("inputs/day_3.txt")

  data
  |> string.replace("\n", "")
  |> find_active_sections
  |> list.map(part_1.recover_and_do_operations)
  |> list.fold(0, fn(acc, i) { acc + i })
  |> io.debug
}

// The Twist
// The second part of the problem is to only apply operations to mul ops in between
// do() and dont() funcs

fn find_active_sections(input: String) -> List(String) {
  let wrapped_input = "do()" <> string.replace(input, "\n", "") <> "don't()"
  let assert Ok(re) = regexp.from_string("do\\(\\).*?don't\\(\\)")
  regexp.scan(re, wrapped_input)
  |> io.debug
  |> list.map(fn(x) { x.content })
}
