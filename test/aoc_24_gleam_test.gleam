import day_2/part_2_brute_force
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn row_sub_1_variant_test() {
  part_2_brute_force.row_sub_1_variants([1, 2, 3, 4, 5])
  |> should.equal([
    [2, 3, 4, 5],
    [1, 3, 4, 5],
    [1, 2, 4, 5],
    [1, 2, 3, 5],
    [1, 2, 3, 4],
  ])
}
