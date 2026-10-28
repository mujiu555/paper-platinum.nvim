// Types, lifetimes, methods and constants
#[derive(Debug)]
struct Page<'a> { title: &'a str, lines: usize }
impl Page<'_> {
    fn summary(&self) -> String {
        format!("{}: {}", self.title, self.lines)
    }
}
const WIDTH: usize = 80;
