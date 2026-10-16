pub fn add(a: i32, b: i32) -> i32 { a + b }
pub fn a() -> i32 { 1 }
pub fn b() -> i32 { 2 }
pub fn c() -> i32 { 3 }
pub fn d() -> i32 { 4 }

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn adds() { assert_eq!(add(1, 2), 3); }
}
